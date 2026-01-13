import 'package:flutter/material.dart';
import '../../core/database/filament_repository.dart';
import '../../core/database/filament_history_repository.dart';
import '../../core/database/printer_repository.dart';
import '../../core/models/filament.dart';
import '../../core/models/printer.dart';
import '../../core/widgets/app_drawer.dart';
import '../../l10n/app_strings.dart';
import '../definitions/brands/brand_repository.dart';
import '../definitions/materials/material_repository.dart';
import '../definitions/colors/color_repository.dart';
import '../definitions/colors/color_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FilamentRepository _filamentRepo = FilamentRepository();
  final FilamentHistoryRepository _historyRepo = FilamentHistoryRepository();
  final PrinterRepository _printerRepo = PrinterRepository();
  final BrandRepository _brandRepo = BrandRepository();
  final MaterialRepository _materialRepo = MaterialRepository();
  final ColorRepository _colorRepo = ColorRepository();

  bool _isLoading = true;

  // Stats
  int _totalFilaments = 0;
  int _totalGrams = 0;
  int _activeCount = 0;
  int _usedCount = 0;
  int _lowCount = 0;
  int _finishedCount = 0;
  int _totalSlots = 0;
  int _occupiedSlots = 0;

  List<Filament> _recentFilaments = [];
  List<Filament> _lowStockFilaments = [];

  final Map<int, String> _brandNames = {};
  final Map<int, String> _materialNames = {};
  final Map<int, ColorModel> _colors = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load definitions
      final brands = await _brandRepo.getAll();
      final materials = await _materialRepo.getAll();
      final colors = await _colorRepo.getAll();

      for (final b in brands) {
        _brandNames[b.id] = b.name;
      }
      for (final m in materials) {
        _materialNames[m.id] = m.name;
      }
      for (final c in colors) {
        _colors[c.id] = c;
      }

      // Load filaments
      final allFilaments = await _filamentRepo.getAllFilamentsWithStatus();

      // Calculate stats
      _totalFilaments = allFilaments
          .where((f) => f.status != FilamentStatus.finished)
          .length;

      _activeCount = allFilaments
          .where((f) => f.status == FilamentStatus.active)
          .length;
      _usedCount = allFilaments
          .where((f) => f.status == FilamentStatus.used)
          .length;
      _lowCount = allFilaments
          .where((f) => f.status == FilamentStatus.low)
          .length;
      _finishedCount = allFilaments
          .where((f) => f.status == FilamentStatus.finished)
          .length;

      // Calculate total grams
      int totalGrams = 0;
      for (final filament in allFilaments) {
        if (filament.status != FilamentStatus.finished) {
          final latestHistory = await _historyRepo.getLatestHistory(
            filament.id,
          );
          if (latestHistory != null) {
            totalGrams += latestHistory.gram;
          }
        }
      }
      _totalGrams = totalGrams;

      // Recent filaments (last 5, excluding finished)
      final nonFinished = allFilaments
          .where((f) => f.status != FilamentStatus.finished)
          .toList();
      nonFinished.sort((a, b) => b.id.compareTo(a.id)); // Sort by ID desc
      _recentFilaments = nonFinished.take(5).toList();

      // Low stock filaments
      _lowStockFilaments = allFilaments
          .where((f) => f.status == FilamentStatus.low)
          .toList();

      // Printer occupancy
      final printers = await _printerRepo.getAllPrinters();
      _totalSlots = printers.fold(0, (sum, p) => sum + p.slotCount);

      int occupiedCount = 0;
      for (final printer in printers) {
        final filaments = await _filamentRepo.getFilamentsByPrinter(
          printer.id!,
        );
        occupiedCount += filaments.length;
      }
      _occupiedSlots = occupiedCount;

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return Scaffold(
      drawer: const AppDrawer(current: 'dashboard'),
      appBar: AppBar(
        title: Text(strings.dashboard),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Section
                    Text(
                      strings.overview,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Stats Cards Row 1
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: strings.totalFilaments,
                            value: _totalFilaments.toString(),
                            icon: Icons.inventory_2,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: strings.totalGrams,
                            value: '${_totalGrams}g',
                            icon: Icons.scale,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Status Distribution
                    Text(
                      strings.statusDistribution,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _StatusRow(
                              label: strings.statusActive,
                              count: _activeCount,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 8),
                            _StatusRow(
                              label: strings.statusUsed,
                              count: _usedCount,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            _StatusRow(
                              label: strings.statusLow,
                              count: _lowCount,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 8),
                            _StatusRow(
                              label: strings.statusFinished,
                              count: _finishedCount,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Printer Occupancy
                    Text(
                      strings.printerOccupancy,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  strings.occupiedSlots,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  _occupiedSlots.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(
                                  Icons.circle_outlined,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  strings.emptySlots,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  (_totalSlots - _occupiedSlots).toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Low Stock Alert
                    if (_lowStockFilaments.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            strings.lowStockAlert,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Card(
                        color: Colors.orange.shade50,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _lowStockFilaments.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final filament = _lowStockFilaments[index];
                            return _FilamentTile(
                              filament: filament,
                              brandNames: _brandNames,
                              materialNames: _materialNames,
                              colors: _colors,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],

                    // Recent Filaments
                    Text(
                      strings.recentFilaments,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: _recentFilaments.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(strings.noFilaments),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _recentFilaments.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final filament = _recentFilaments[index];
                                return _FilamentTile(
                                  filament: filament,
                                  brandNames: _brandNames,
                                  materialNames: _materialNames,
                                  colors: _colors,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Status Row Widget
class _StatusRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatusRow({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(
          count.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Filament Tile Widget
class _FilamentTile extends StatelessWidget {
  final Filament filament;
  final Map<int, String> brandNames;
  final Map<int, String> materialNames;
  final Map<int, ColorModel> colors;

  const _FilamentTile({
    required this.filament,
    required this.brandNames,
    required this.materialNames,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final brandName = brandNames[filament.brandId] ?? '—';
    final materialName = materialNames[filament.materialId] ?? '—';
    final color = colors[filament.colorId];

    return ListTile(
      leading: CircleAvatar(
        radius: 8,
        backgroundColor: color != null
            ? Color(color.flutterColor)
            : Colors.grey,
      ),
      title: Text(
        '$brandName • ${materialName.toUpperCase()}',
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(color?.name ?? '-', style: const TextStyle(fontSize: 12)),
      trailing: Text(
        '#${filament.id}',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
