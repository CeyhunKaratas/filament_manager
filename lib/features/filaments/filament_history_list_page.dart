import 'package:flutter/material.dart';
import 'dart:io';
import '../../core/database/filament_history_repository.dart';
import '../../core/database/location_repository.dart';
import '../../core/database/printer_repository.dart';
import '../../core/models/filament_history.dart';
import '../../core/models/filament.dart';
import '../../l10n/app_strings.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class FilamentHistoryListPage extends StatefulWidget {
  final Filament filament;

  const FilamentHistoryListPage({super.key, required this.filament});

  @override
  State<FilamentHistoryListPage> createState() =>
      _FilamentHistoryListPageState();
}

class _FilamentHistoryListPageState extends State<FilamentHistoryListPage> {
  final FilamentHistoryRepository _historyRepo = FilamentHistoryRepository();
  final LocationRepository _locationRepo = LocationRepository();
  final PrinterRepository _printerRepo = PrinterRepository();

  List<FilamentHistory> _history = [];
  bool _isLoading = true;

  // Cache for location and printer names
  final Map<int, String> _locationNames = {};
  final Map<int, String> _printerNames = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _historyRepo.getHistoryForFilament(
        widget.filament.id,
      );

      // Load all locations and printers for name lookup
      final locations = await _locationRepo.getAllLocations();
      final printers = await _printerRepo.getAllPrinters();

      for (final loc in locations) {
        _locationNames[loc.id!] = loc.name;
      }

      for (final printer in printers) {
        _printerNames[printer.id!] = printer.name;
      }

      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showFullScreenPhoto(String photoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PhotoView(
            imageProvider: FileImage(File(photoPath)),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildMovementInfo(FilamentHistory record, AppStrings strings) {
    IconData icon;
    Color color;
    String title;
    String description;

    switch (record.type) {
      case HistoryType.assignedToPrinter:
        icon = Icons.print;
        color = Colors.blue;
        title = strings.assignedToPrinter;
        description =
            '${_printerNames[record.newPrinterId] ?? '?'}, '
            '${strings.slot} ${record.newSlot}';
        break;

      case HistoryType.unassignedFromPrinter:
        icon = Icons.remove_circle_outline;
        color = Colors.orange;
        title = strings.unassignedFromPrinter;
        description =
            '${strings.from}: ${_printerNames[record.oldPrinterId] ?? '?'}, '
            '${strings.slot} ${record.oldSlot}\n'
            '${strings.to}: ${_locationNames[record.newLocationId] ?? '?'}';
        break;

      case HistoryType.locationChanged:
        icon = Icons.move_to_inbox;
        color = Colors.purple;
        title = strings.locationChanged;
        description =
            '${strings.from}: ${_locationNames[record.oldLocationId] ?? '?'}\n'
            '${strings.to}: ${_locationNames[record.newLocationId] ?? '?'}';
        break;

      case HistoryType.slotChanged:
        icon = Icons.swap_horiz;
        color = Colors.teal;
        title = strings.slotChanged;
        description =
            '${_printerNames[record.oldPrinterId] ?? '?'}: '
            '${strings.slot} ${record.oldSlot} → ${record.newSlot}';
        break;

      case HistoryType.gramUpdate:
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text(strings.history)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? Center(child: Text(strings.noHistory))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              separatorBuilder: (_, __) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final record = _history[index];
                final isInitial =
                    index == _history.length - 1; // Last = first record

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date & Type indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dateFormat.format(record.createdAt),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            // Show gram only for gram updates
                            if (record.type == HistoryType.gramUpdate &&
                                record.gram != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${record.gram}g',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Initial tag
                        if (isInitial) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              strings.initialRecord,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ],

                        // Movement info (for non-gram records)
                        if (record.type != HistoryType.gramUpdate) ...[
                          const SizedBox(height: 12),
                          _buildMovementInfo(record, strings),
                        ],

                        // Photo
                        if (record.photo != null) ...[
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => _showFullScreenPhoto(record.photo!),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(record.photo!),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],

                        // Note
                        if (record.note != null && record.note!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.note, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    record.note!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
