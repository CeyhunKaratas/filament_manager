import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:archive/archive_io.dart';

import '../database/database_helper.dart';
import '../database/filament_history_repository.dart';
import '../database/filament_repository.dart';
import '../models/filament_history.dart';
import 'backup_data_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/beta_tracker_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExportResult {
  final bool success;
  final String? filePath;
  final String? fileName;
  final Map<String, int> stats;
  final String? error;

  ExportResult({
    required this.success,
    this.filePath,
    this.fileName,
    this.stats = const {},
    this.error,
  });
}

class ImportResult {
  final bool success;
  final Map<String, int> stats;
  final String? error;

  ImportResult({required this.success, this.stats = const {}, this.error});
}

class ExportImportService {
  static const String _backupVersion = '2'; // Updated for ZIP support

  /// Export all data to ZIP file (JSON + photos)
  Future<ExportResult> exportData() async {
    try {
      final db = await DatabaseHelper.instance.database;

      // Get app version dynamically
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;

      // Fetch all data
      final brands = await db.query('brands');
      final materials = await db.query('materials');
      final colors = await db.query('colors');
      final colorTerms = await db.query('color_terms');
      final locations = await db.query('locations');
      final printers = await db.query('printers');
      final filaments = await db.query('filaments');
      final filamentHistory = await db.query('filament_history');
      final betaTrackerInfo = await BetaTrackerService.getInstallationInfo();

      // Collect all photo paths
      final photoPaths = <String>[];
      for (final history in filamentHistory) {
        final photo = history['photo'] as String?;
        if (photo != null && photo.isNotEmpty) {
          photoPaths.add(photo);
        }
      }

      // Also collect main photos from filaments
      for (final filament in filaments) {
        final mainPhoto = filament['main_photo_path'] as String?;
        if (mainPhoto != null && mainPhoto.isNotEmpty) {
          photoPaths.add(mainPhoto);
        }
      }

      // Stats
      final stats = {
        'brands': brands.length,
        'materials': materials.length,
        'colors': colors.length,
        'locations': locations.length,
        'printers': printers.length,
        'filaments': filaments.length,
        'history': filamentHistory.length,
        'photos': photoPaths.length,
      };

      // Create backup
      final backup = BackupData(
        version: _backupVersion,
        appVersion: appVersion,
        exportDate: DateTime.now().toIso8601String(),
        databaseVersion: 1,
        data: {
          'beta_tracker': betaTrackerInfo,
          'brands': brands,
          'materials': materials,
          'colors': colors,
          'color_terms': colorTerms,
          'locations': locations,
          'printers': printers,
          'filaments': filaments,
          'filament_history': filamentHistory,
        },
      );

      // Convert to JSON
      final jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(backup.toJson());

      // Create temp directory for export
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final tempDir = Directory('${directory.path}/temp_export_$timestamp');
      await tempDir.create(recursive: true);

      // Save JSON to temp directory
      final jsonFile = File('${tempDir.path}/backup.json');
      await jsonFile.writeAsString(jsonString);

      // Copy photos to temp directory with new names
      final photoMap = <String, String>{}; // old_path -> new_name
      int photoIndex = 0;

      for (final photoPath in photoPaths) {
        final sourceFile = File(photoPath);
        if (await sourceFile.exists()) {
          final extension = photoPath.split('.').last;
          final newFileName = 'photo_$photoIndex.$extension';
          final destFile = File('${tempDir.path}/$newFileName');
          await sourceFile.copy(destFile.path);
          photoMap[photoPath] = newFileName;
          photoIndex++;
        }
      }

      // Save photo mapping
      final photoMapFile = File('${tempDir.path}/photo_map.json');
      await photoMapFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(photoMap),
      );

      // Create ZIP archive
      final zipFileName = 'filament_backup_$timestamp.zip';
      final zipFile = File('${directory.path}/$zipFileName');

      final encoder = ZipFileEncoder();
      encoder.create(zipFile.path);
      encoder.addDirectory(tempDir);
      encoder.close();

      // Clean up temp directory
      await tempDir.delete(recursive: true);

      return ExportResult(
        success: true,
        filePath: zipFile.path,
        fileName: zipFileName,
        stats: stats,
      );
    } catch (e) {
      return ExportResult(success: false, error: e.toString());
    }
  }

  /// Share the exported file
  Future<void> shareExportFile(String filePath) async {
    await Share.shareXFiles([
      XFile(filePath),
    ], subject: 'Filament Manager Backup');
  }

  /// Import data from ZIP file
  Future<ImportResult> importData({required bool replaceMode}) async {
    try {
      // File picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', 'json'], // Support both old and new format
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(success: false, error: 'No file selected');
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        return ImportResult(success: false, error: 'File path is null');
      }

      final file = File(filePath);
      final isZip = filePath.toLowerCase().endsWith('.zip');

      if (isZip) {
        return await _importFromZip(file, replaceMode);
      } else {
        return await _importFromJson(file, replaceMode);
      }
    } catch (e) {
      return ImportResult(success: false, error: e.toString());
    }
  }

  /// Import from ZIP file (new format with photos)
  Future<ImportResult> _importFromZip(File zipFile, bool replaceMode) async {
    try {
      // Extract ZIP to temp directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempDir = Directory('${directory.path}/temp_import_$timestamp');
      await tempDir.create(recursive: true);

      // Extract ZIP
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          // Remove any directory prefix from filename
          final cleanFilename = filename.split('/').last;
          if (cleanFilename.isNotEmpty) {
            final outFile = File('${tempDir.path}/$cleanFilename');
            await outFile.create(recursive: true);
            await outFile.writeAsBytes(data);
          }
        }
      }

      // Read JSON
      final jsonFile = File('${tempDir.path}/backup.json');
      if (!await jsonFile.exists()) {
        await tempDir.delete(recursive: true);
        return ImportResult(
          success: false,
          error: 'Invalid backup file: backup.json not found',
        );
      }

      final jsonString = await jsonFile.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final backup = BackupData.fromJson(jsonData);

      // Read photo mapping if exists
      final photoMapFile = File('${tempDir.path}/photo_map.json');
      Map<String, String> photoMap = {}; // old_path -> new_name
      if (await photoMapFile.exists()) {
        final photoMapString = await photoMapFile.readAsString();
        final photoMapData = jsonDecode(photoMapString) as Map<String, dynamic>;
        photoMap = photoMapData.map(
          (key, value) => MapEntry(key, value as String),
        );
      }

      // Import data
      final db = await DatabaseHelper.instance.database;
      final stats = <String, int>{};

      if (replaceMode) {
        await _clearAllData(db);
      }

      // Import tables
      stats['brands'] = await _importTable(
        db,
        'brands',
        backup.data['brands'] as List,
      );
      stats['materials'] = await _importTable(
        db,
        'materials',
        backup.data['materials'] as List,
      );
      stats['colors'] = await _importTable(
        db,
        'colors',
        backup.data['colors'] as List,
      );
      stats['color_terms'] = await _importTable(
        db,
        'color_terms',
        backup.data['color_terms'] as List,
      );
      stats['locations'] = await _importTable(
        db,
        'locations',
        backup.data['locations'] as List,
      );
      stats['printers'] = await _importTable(
        db,
        'printers',
        backup.data['printers'] as List,
      );

      // Create photos directory in app's permanent storage
      final photosDir = Directory('${directory.path}/photos');
      await photosDir.create(recursive: true);

      // Import filaments with photo path updates
      final filaments = backup.data['filaments'] as List;
      int filamentsImported = 0;
      for (final row in filaments) {
        final rowData = Map<String, dynamic>.from(row as Map);

        // Update main photo path if exists
        final oldMainPhoto = rowData['main_photo_path'] as String?;
        if (oldMainPhoto != null && photoMap.containsKey(oldMainPhoto)) {
          final tempPhotoPath = '${tempDir.path}/${photoMap[oldMainPhoto]}';
          final tempPhotoFile = File(tempPhotoPath);

          if (await tempPhotoFile.exists()) {
            final newPhotoPath = '${photosDir.path}/${photoMap[oldMainPhoto]}';
            await tempPhotoFile.copy(newPhotoPath);
            rowData['main_photo_path'] = newPhotoPath;
          }
        }

        final id = rowData['id'];
        if (id != null) {
          final existing = await db.query(
            'filaments',
            where: 'id = ?',
            whereArgs: [id],
          );
          if (existing.isNotEmpty) {
            await db.update(
              'filaments',
              rowData,
              where: 'id = ?',
              whereArgs: [id],
            );
          } else {
            await db.insert('filaments', rowData);
            filamentsImported++;
          }
        } else {
          await db.insert('filaments', rowData);
          filamentsImported++;
        }
      }
      stats['filaments'] = filamentsImported;

      // Import history with photo path updates
      if (backup.data.containsKey('filament_history')) {
        final history = backup.data['filament_history'] as List;
        int historyImported = 0;

        for (final row in history) {
          final rowData = Map<String, dynamic>.from(row as Map);

          // Update photo path if exists
          final oldPhoto = rowData['photo'] as String?;
          if (oldPhoto != null && photoMap.containsKey(oldPhoto)) {
            final tempPhotoPath = '${tempDir.path}/${photoMap[oldPhoto]}';
            final tempPhotoFile = File(tempPhotoPath);

            if (await tempPhotoFile.exists()) {
              final newPhotoPath = '${photosDir.path}/${photoMap[oldPhoto]}';
              await tempPhotoFile.copy(newPhotoPath);
              rowData['photo'] = newPhotoPath;
            } else {
              rowData['photo'] = null; // Photo not found
            }
          }

          final id = rowData['id'];
          if (id != null) {
            final existing = await db.query(
              'filament_history',
              where: 'id = ?',
              whereArgs: [id],
            );
            if (existing.isNotEmpty) {
              await db.update(
                'filament_history',
                rowData,
                where: 'id = ?',
                whereArgs: [id],
              );
            } else {
              await db.insert('filament_history', rowData);
              historyImported++;
            }
          } else {
            await db.insert('filament_history', rowData);
            historyImported++;
          }
        }
        stats['history'] = historyImported;
      }

      // Restore beta tracker info if present
      if (backup.data.containsKey('beta_tracker') &&
          backup.data['beta_tracker'] != null) {
        final trackerData = backup.data['beta_tracker'] as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('first_install_version', trackerData['version']);
        await prefs.setString(
          'first_install_timestamp',
          trackerData['installed_at'],
        );
      }

      // MIGRATION: Create initial history for filaments without history
      final filamentHistoryRepo = FilamentHistoryRepository();
      final filamentRepo = FilamentRepository();

      final allFilaments = await filamentRepo.getAllFilamentsWithStatus();
      int historyCreated = 0;

      for (final filament in allFilaments) {
        final existingHistory = await filamentHistoryRepo.getInitialHistory(
          filament.id,
        );

        if (existingHistory == null) {
          await filamentHistoryRepo.addHistory(
            FilamentHistory(
              filamentId: filament.id,
              gram: 1000,
              photo: null,
              note: 'Initial record (auto-created during import)',
              createdAt: DateTime.now(),
            ),
          );
          historyCreated++;
        }
      }

      if (historyCreated > 0) {
        stats['history_created'] = historyCreated;
      }

      // Clean up temp directory
      await tempDir.delete(recursive: true);

      return ImportResult(success: true, stats: stats);
    } catch (e) {
      return ImportResult(success: false, error: e.toString());
    }
  }

  /// Import from JSON file (legacy format without photos)
  Future<ImportResult> _importFromJson(File file, bool replaceMode) async {
    try {
      // Read file
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final backup = BackupData.fromJson(jsonData);

      // Validate
      if (backup.version != '1' && backup.version != _backupVersion) {
        return ImportResult(
          success: false,
          error: 'Incompatible version: ${backup.version}',
        );
      }

      final db = await DatabaseHelper.instance.database;
      final stats = <String, int>{};

      if (replaceMode) {
        await _clearAllData(db);
      }

      // Import
      stats['brands'] = await _importTable(
        db,
        'brands',
        backup.data['brands'] as List,
      );
      stats['materials'] = await _importTable(
        db,
        'materials',
        backup.data['materials'] as List,
      );
      stats['colors'] = await _importTable(
        db,
        'colors',
        backup.data['colors'] as List,
      );
      stats['color_terms'] = await _importTable(
        db,
        'color_terms',
        backup.data['color_terms'] as List,
      );
      stats['locations'] = await _importTable(
        db,
        'locations',
        backup.data['locations'] as List,
      );
      stats['printers'] = await _importTable(
        db,
        'printers',
        backup.data['printers'] as List,
      );
      stats['filaments'] = await _importTable(
        db,
        'filaments',
        backup.data['filaments'] as List,
      );

      // Import history if available (photos will be missing)
      if (backup.data.containsKey('filament_history')) {
        stats['history'] = await _importTable(
          db,
          'filament_history',
          backup.data['filament_history'] as List,
        );
      }

      // Restore beta tracker info if present
      if (backup.data.containsKey('beta_tracker') &&
          backup.data['beta_tracker'] != null) {
        final trackerData = backup.data['beta_tracker'] as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('first_install_version', trackerData['version']);
        await prefs.setString(
          'first_install_timestamp',
          trackerData['installed_at'],
        );
      }

      // MIGRATION: Create initial history for filaments without history
      final filamentHistoryRepo = FilamentHistoryRepository();
      final filamentRepo = FilamentRepository();

      final allFilaments = await filamentRepo.getAllFilamentsWithStatus();
      int historyCreated = 0;

      for (final filament in allFilaments) {
        final existingHistory = await filamentHistoryRepo.getInitialHistory(
          filament.id,
        );

        if (existingHistory == null) {
          await filamentHistoryRepo.addHistory(
            FilamentHistory(
              filamentId: filament.id,
              gram: 1000,
              photo: null,
              note: 'Initial record (auto-created during import)',
              createdAt: DateTime.now(),
            ),
          );
          historyCreated++;
        }
      }

      if (historyCreated > 0) {
        stats['history_created'] = historyCreated;
      }

      return ImportResult(success: true, stats: stats);
    } catch (e) {
      return ImportResult(success: false, error: e.toString());
    }
  }

  Future<void> _clearAllData(db) async {
    await db.delete('filament_history'); // History first (foreign key)
    await db.delete('filaments');
    await db.delete('printers');
    await db.delete('locations', where: 'is_default = 0');
    await db.delete('color_terms');
    await db.delete('colors', where: 'is_default = 0');
    await db.delete('materials', where: 'is_default = 0');
    await db.delete('brands', where: 'is_default = 0');
  }

  Future<int> _importTable(db, String tableName, List data) async {
    int count = 0;
    for (final row in data) {
      final rowData = Map<String, dynamic>.from(row as Map);
      final id = rowData['id'];

      if (id != null) {
        final existing = await db.query(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        );
        if (existing.isNotEmpty) {
          await db.update(tableName, rowData, where: 'id = ?', whereArgs: [id]);
        } else {
          await db.insert(tableName, rowData);
          count++;
        }
      } else {
        await db.insert(tableName, rowData);
        count++;
      }
    }
    return count;
  }
}
