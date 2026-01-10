import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import '../database/database_helper.dart';
import 'backup_data_model.dart';

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
  static const String _backupVersion = '1';
  static const String _appVersion = '0.3.2-beta';

  /// Export all data to JSON file
  Future<ExportResult> exportData() async {
    try {
      final db = await DatabaseHelper.instance.database;

      // Fetch all data
      final brands = await db.query('brands');
      final materials = await db.query('materials');
      final colors = await db.query('colors');
      final colorTerms = await db.query('color_terms');
      final locations = await db.query('locations');
      final printers = await db.query('printers');
      final filaments = await db.query('filaments');

      // Stats
      final stats = {
        'brands': brands.length,
        'materials': materials.length,
        'colors': colors.length,
        'locations': locations.length,
        'printers': printers.length,
        'filaments': filaments.length,
      };

      // Create backup
      final backup = BackupData(
        version: _backupVersion,
        appVersion: _appVersion,
        exportDate: DateTime.now().toIso8601String(),
        databaseVersion: 1,
        data: {
          'brands': brands,
          'materials': materials,
          'colors': colors,
          'color_terms': colorTerms,
          'locations': locations,
          'printers': printers,
          'filaments': filaments,
        },
      );

      // Convert to JSON
      final jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(backup.toJson());

      // Filename
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final fileName = 'filament_backup_$timestamp.json';

      // Save to app documents (no permission needed)
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);

      return ExportResult(
        success: true,
        filePath: file.path,
        fileName: fileName,
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

  /// Import data
  Future<ImportResult> importData({required bool replaceMode}) async {
    try {
      // File picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(success: false, error: 'No file selected');
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        return ImportResult(success: false, error: 'File path is null');
      }

      // Read file
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final backup = BackupData.fromJson(jsonData);

      // Validate
      if (backup.version != _backupVersion) {
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

      return ImportResult(success: true, stats: stats);
    } catch (e) {
      return ImportResult(success: false, error: e.toString());
    }
  }

  Future<void> _clearAllData(db) async {
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
