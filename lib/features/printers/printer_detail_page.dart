import 'package:flutter/material.dart';
import 'package:filament_manager/core/models/printer.dart';
import 'package:filament_manager/core/models/filament.dart';
import 'package:filament_manager/core/database/filament_repository.dart';
import 'package:filament_manager/l10n/app_strings.dart';

import 'package:filament_manager/features/definitions/brands/brand_repository.dart';
import 'package:filament_manager/features/definitions/materials/material_repository.dart';
import 'package:filament_manager/features/definitions/colors/color_repository.dart';
import 'package:filament_manager/features/definitions/brands/brand_model.dart';
import 'package:filament_manager/features/definitions/materials/material_model.dart';
import 'package:filament_manager/features/definitions/colors/color_model.dart';
import '../../core/database/filament_history_repository.dart';
import '../../core/utils/status_calculator.dart';

class PrinterDetailPage extends StatefulWidget {
  final Printer printer;

  const PrinterDetailPage({super.key, required this.printer});

  @override
  State<PrinterDetailPage> createState() => _PrinterDetailPageState();
}

class _PrinterDetailPageState extends State<PrinterDetailPage> {
  final FilamentRepository _filamentRepository = FilamentRepository();
  final BrandRepository _brandRepository = BrandRepository();
  final MaterialRepository _materialRepository = MaterialRepository();
  final ColorRepository _colorRepository = ColorRepository();

  List<Filament> _filaments = [];

  final Map<int, BrandModel> _brands = {};
  final Map<int, MaterialModel> _materials = {};
  final Map<int, ColorModel> _colors = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilaments();
  }

  Future<void> _loadFilaments() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await _filamentRepository.getFilamentsByPrinter(
        widget.printer.id!,
      );

      // Calculate status for each filament
      final historyRepo = FilamentHistoryRepository();
      final List<Filament> filamentsWithStatus = [];

      for (final filament in result) {
        final initialHistory = await historyRepo.getInitialHistory(filament.id);
        final latestHistory = await historyRepo.getLatestHistory(filament.id);

        if (initialHistory != null && latestHistory != null) {
          final calculatedStatus = StatusCalculator.calculateStatus(
            currentGram: latestHistory.gram,
            initialGram: initialHistory.gram,
          );
          filamentsWithStatus.add(filament.copyWith(status: calculatedStatus));
        } else {
          filamentsWithStatus.add(filament);
        }
      }

      if (mounted) {
        setState(() {
          _filaments = filamentsWithStatus;
          _isLoading = false;
        });
      }

      final allBrands = await _brandRepository.getAll();
      final allMaterials = await _materialRepository.getAll();
      final allColors = await _colorRepository.getAll();

      for (final b in allBrands) {
        _brands[b.id] = b;
      }

      for (final m in allMaterials) {
        _materials[m.id] = m;
      }

      for (final c in allColors) {
        _colors[c.id] = c;
      }

      if (mounted) {
        setState(() {
          _filaments = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading filaments: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load filaments: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _statusColor(FilamentStatus status) {
    switch (status) {
      case FilamentStatus.active:
        return Colors.green;
      case FilamentStatus.used:
        return Colors.blue;
      case FilamentStatus.low:
        return Colors.orange;
      case FilamentStatus.finished:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      appBar: AppBar(title: Text(widget.printer.name)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.printer,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  if (_filaments.isEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      strings.noFilaments,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                  ],

                  const SizedBox(height: 8),
                  Text(widget.printer.name),
                  const SizedBox(height: 16),
                  Text('${strings.slot}: ${widget.printer.slotCount}'),
                  const SizedBox(height: 24),

                  Text(
                    strings.slot,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.printer.slotCount,
                      itemBuilder: (context, index) {
                        final slotNumber = index + 1;

                        Filament? filamentForSlot;
                        for (final f in _filaments) {
                          if (f.slot == slotNumber) {
                            filamentForSlot = f;
                            break;
                          }
                        }

                        return ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: filamentForSlot == null
                                      ? Colors.transparent
                                      : _statusColor(filamentForSlot.status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('#$slotNumber'),
                            ],
                          ),
                          title: filamentForSlot == null
                              ? Text(strings.empty)
                              : Text(
                                  '${_brands[filamentForSlot.brandId]?.name ?? ''} '
                                  '${_materials[filamentForSlot.materialId]?.name ?? ''}',
                                ),
                          subtitle: filamentForSlot == null
                              ? null
                              : Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(
                                          _colors[filamentForSlot.colorId]
                                                  ?.flutterColor ??
                                              0xFF9E9E9E,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${strings.status}: '
                                      '${strings.statusLabel(filamentForSlot.status)}',
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),

                  Row(
                    children: [
                      _LegendItem(
                        color: Colors.green,
                        label: strings.statusActive,
                      ),
                      const SizedBox(width: 12),
                      _LegendItem(
                        color: Colors.blue,
                        label: strings.statusUsed,
                      ),
                      const SizedBox(width: 12),
                      _LegendItem(
                        color: Colors.orange,
                        label: strings.statusLow,
                      ),
                      const SizedBox(width: 12),
                      _LegendItem(
                        color: Colors.red,
                        label: strings.statusFinished,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
