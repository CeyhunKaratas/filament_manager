import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/database_helper.dart';
import 'backup_data_model.dart';

class ExportImportService {
  static const String _backupVersion = '1';
  static const String _appVersion = '0.3.0-beta';

  /// Export all data to JSON file and share it
  Future<String> exportData() async {
    try {
      final db = await DatabaseHelper.instance.database;

      // Fetch all data from database
      final brands = await db.query('brands');
      final materials = await db.query('materials');
      final colors = await db.query('colors');
      final colorTerms = await db.query('color_terms');
      final locations = await db.query('locations');
      final printers = await db.query('printers');
      final filaments = await db.query('filaments');

      // Create backup object
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

      // Save to file in app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final fileName = 'filament_backup_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);

      // Also copy to Downloads for easy import testing
      if (Platform.isAndroid) {
        try {
          final downloadsDir = Directory('/storage/emulated/0/Download');
          if (await downloadsDir.exists()) {
            final downloadFile = File('${downloadsDir.path}/$fileName');
            await downloadFile.writeAsString(jsonString);
          }
        } catch (e) {
          debugPrint('Could not copy to Downloads: $e');
        }
      }

      // Share file (user can save it wherever they want)
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Filament Manager Backup',
        text: 'Backup file: $fileName',
      );

      return file.path;
    } catch (e) {
      throw Exception('Export failed: $e');
    }
  }

  /// Import data from a file path
  /// Note: For import, user must manually place the backup file in Downloads folder
  /// and we'll read from there
  Future<bool> importData({required bool replaceMode}) async {
    try {
      // Get Downloads directory (Android specific)
      Directory? downloadsDir;

      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
      } else {
        // For other platforms, use app directory
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (!await downloadsDir.exists()) {
        throw Exception('Downloads folder not found');
      }

      // Find backup files
      final files = downloadsDir
          .listSync()
          .where(
            (f) =>
                f.path.endsWith('.json') && f.path.contains('filament_backup'),
          )
          .toList();

      if (files.isEmpty) {
        throw Exception('No backup files found in Downloads folder');
      }

      // Get the most recent backup file
      files.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );
      final latestFile = files.first;

      // Read file
      final file = File(latestFile.path);
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Parse backup
      final backup = BackupData.fromJson(jsonData);

      // Validate version
      if (backup.version != _backupVersion) {
        throw Exception('Incompatible backup version: ${backup.version}');
      }

      final db = await DatabaseHelper.instance.database;

      if (replaceMode) {
        // Replace mode: Delete all data first
        await _clearAllData(db);
      }

      // Import data
      await _importTable(db, 'brands', backup.data['brands'] as List);
      await _importTable(db, 'materials', backup.data['materials'] as List);
      await _importTable(db, 'colors', backup.data['colors'] as List);
      await _importTable(db, 'color_terms', backup.data['color_terms'] as List);
      await _importTable(db, 'locations', backup.data['locations'] as List);
      await _importTable(db, 'printers', backup.data['printers'] as List);
      await _importTable(db, 'filaments', backup.data['filaments'] as List);

      return true;
    } catch (e) {
      debugPrint('Import failed: $e');
      return false;
    }
  }

  /// Clear all data from database (for replace mode)
  Future<void> _clearAllData(db) async {
    await db.delete('filaments');
    await db.delete('printers');
    await db.delete('locations', where: 'is_default = 0');
    await db.delete('color_terms');
    await db.delete('colors', where: 'is_default = 0');
    await db.delete('materials', where: 'is_default = 0');
    await db.delete('brands', where: 'is_default = 0');
  }

  /// Import data into a table
  Future<void> _importTable(db, String tableName, List data) async {
    for (final row in data) {
      final rowData = Map<String, dynamic>.from(row as Map);

      // For merge mode: check if record exists
      final id = rowData['id'];
      if (id != null) {
        final existing = await db.query(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        );

        if (existing.isNotEmpty) {
          // Update existing
          await db.update(tableName, rowData, where: 'id = ?', whereArgs: [id]);
        } else {
          // Insert new
          await db.insert(tableName, rowData);
        }
      } else {
        // No ID, just insert
        await db.insert(tableName, rowData);
      }
    }
  }
}
