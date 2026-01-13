import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/export_import/export_import_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      final result = await _exportImportService.exportData();

      if (!mounted) return;

      if (result.success) {
        // Show success dialog with stats
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(strings.exportSuccess)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📁 ${strings.fileSavedTo}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    result.filePath ?? '',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '📊 ${strings.exportedData}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...result.stats.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${_getTableName(e.key)}: ${e.value}'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(strings.ok),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: Text(strings.share),
                onPressed: () async {
                  Navigator.pop(context);
                  if (result.filePath != null) {
                    await _exportImportService.shareExportFile(
                      result.filePath!,
                    );
                  }
                },
              ),
            ],
          ),
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${strings.exportFailed}: ${result.error}'),
            backgroundColor: Colors.red,
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
      final result = await _exportImportService.importData(
        replaceMode: replaceMode,
      );

      if (!mounted) return;

      if (result.success) {
        // Show success dialog with stats
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(strings.importSuccess)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 ${strings.importedData}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...result.stats.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• ${_getTableName(e.key)}: ${e.value}'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    replaceMode
                        ? '⚠️ ${strings.allDataReplaced}'
                        : 'ℹ️ ${strings.dataMerged}',
                    style: TextStyle(
                      fontSize: 12,
                      color: replaceMode ? Colors.orange : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Reload the app or current screen
                  setState(() {});
                },
                child: Text(strings.ok),
              ),
            ],
          ),
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${strings.importFailed}: ${result.error ?? "Unknown error"}',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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

  String _getTableName(String key) {
    switch (key) {
      case 'brands':
        return 'Brands';
      case 'materials':
        return 'Materials';
      case 'colors':
        return 'Colors';
      case 'locations':
        return 'Locations';
      case 'printers':
        return 'Printers';
      case 'filaments':
        return 'Filaments';
      default:
        return key;
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
          // Export/Import Section
          Text(
            strings.dataManagement,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          // Export Data
          Card(
            child: ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.blue),
              title: Text(strings.exportData),
              subtitle: Text(strings.backupAllData),
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
              leading: const Icon(Icons.download, color: Colors.green),
              title: Text(strings.importData),
              subtitle: Text(strings.restoreFromBackup),
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
          FutureBuilder<String>(
            future: _getVersion(),
            builder: (context, snapshot) {
              return ListTile(
                title: Text(strings.appTitle),
                subtitle: Text('Version ${snapshot.data ?? "..."}'),
              );
            },
          ),

          const SizedBox(height: 12),

          // Durumade Info
          const Divider(),
          const ListTile(
            title: Text('About Durumade'),
            subtitle: Text(
              'This app was originally created to support internal inventory '
              'tracking for the Durumade handmade workshop.',
            ),
          ),

          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Durumade on Instagram'),
            subtitle: const Text('instagram.com/duruepoxidharz'),
            onTap: () async {
              final uri = Uri.parse('https://instagram.com/duruepoxidharz');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Durumade Website'),
            subtitle: const Text('durumade.com'),
            onTap: () async {
              final uri = Uri.parse('https://durumade.com');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),

          const SizedBox(height: 24),

          // Feedback
          const Divider(),
          const ListTile(
            title: Text('Feedback'),
            subtitle: Text(
              'Help improve the app by reporting issues or sharing ideas.',
            ),
          ),

          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report a bug / Send feedback'),
            subtitle: const Text('GitHub Issues'),
            onTap: () async {
              final uri = Uri.parse(
                'https://github.com/CeyhunKaratas/filament_manager/issues',
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<String> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
