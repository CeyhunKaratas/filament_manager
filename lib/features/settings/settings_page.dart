import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/export_import/export_import_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ExportImportService _exportImportService = ExportImportService();

  bool _isExporting = false;
  bool _isImporting = false;

  Future<void> _handleExport() async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    setState(() {
      _isExporting = true;
    });

    try {
      final filePath = await _exportImportService.exportData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${strings.exportSuccess}\n$filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      debugPrint('Export error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${strings.exportFailed}: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _handleImport() async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    // Show mode selection dialog
    final mode = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.selectImportMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_sweep, color: Colors.red),
              title: Text(strings.replaceAll),
              subtitle: Text(
                strings.replaceAllWarning,
                style: const TextStyle(fontSize: 12),
              ),
              onTap: () => Navigator.pop(context, 'replace'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.merge, color: Colors.blue),
              title: Text(strings.merge),
              subtitle: Text(
                strings.mergeInfo,
                style: const TextStyle(fontSize: 12),
              ),
              onTap: () => Navigator.pop(context, 'merge'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
        ],
      ),
    );

    if (mode == null) return;

    final replaceMode = mode == 'replace';

    setState(() {
      _isImporting = true;
    });

    try {
      await _exportImportService.importData(replaceMode: replaceMode);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.importSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Import error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${strings.importFailed}: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      drawer: const AppDrawer(current: 'settings'),
      appBar: AppBar(title: Text(strings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Export Data
          Card(
            child: ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text(strings.exportData),
              subtitle: const Text('Backup all data to a JSON file'),
              trailing: _isExporting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_forward_ios),
              onTap: _isExporting ? null : _handleExport,
            ),
          ),

          const SizedBox(height: 12),

          // Import Data
          Card(
            child: ListTile(
              leading: const Icon(Icons.download),
              title: Text(strings.importData),
              subtitle: const Text('Restore data from a JSON file'),
              trailing: _isImporting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_forward_ios),
              onTap: _isImporting ? null : _handleImport,
            ),
          ),

          const SizedBox(height: 32),

          // App Info
          const Divider(),
          ListTile(
            title: Text(strings.appTitle),
            subtitle: const Text('Version 0.2.0-alpha'),
          ),
        ],
      ),
    );
  }
}
