import 'package:flutter/material.dart';
import '../models/filament.dart';
import '../models/printer.dart';
import '../database/filament_repository.dart';
import '../database/filament_history_repository.dart';
import '../database/location_repository.dart';
import '../../features/filaments/filament_edit_page.dart';
import '../../features/filaments/filament_history_add_page.dart';
import '../../features/filaments/filament_history_list_page.dart';
import '../../l10n/app_strings.dart';

class FilamentActions {
  static final FilamentRepository _repository = FilamentRepository();
  static final FilamentHistoryRepository _historyRepository =
      FilamentHistoryRepository();
  static final LocationRepository _locationRepository = LocationRepository();

  /// Save status (open history add page)
  /// Returns true if data changed
  static Future<bool> saveStatus(
    BuildContext context,
    Filament filament,
  ) async {
    final latestHistory = await _historyRepository.getLatestGramUpdate(
      filament.id,
    );

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FilamentHistoryAddPage(
          filament: filament,
          lastGram: latestHistory?.gram,
        ),
      ),
    );

    return result ?? false;
  }

  /// View history (open history list page)
  /// Returns false as viewing doesn't change data
  static Future<bool> viewHistory(
    BuildContext context,
    Filament filament,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilamentHistoryListPage(filament: filament),
      ),
    );

    return false;
  }

  /// Edit filament
  /// Returns true if data changed
  static Future<bool> edit(BuildContext context, Filament filament) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FilamentEditPage(filament: filament)),
    );

    return result ?? false;
  }

  /// Delete filament with confirmation
  /// Returns true if deleted successfully
  static Future<bool> delete(BuildContext context, Filament filament) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.delete),
        content: Text(strings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(strings.delete),
          ),
        ],
      ),
    );

    if (confirm != true) return false;

    try {
      await _repository.deleteFilament(filament.id);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.deleted)));
      }

      return true;
    } catch (e) {
      debugPrint('Error deleting filament: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }

      return false;
    }
  }

  /// Assign to printer slot with slot occupied handling
  /// Returns true if assigned successfully
  static Future<bool> assignToPrinter(
    BuildContext context,
    Filament filament,
    List<Printer> printers,
  ) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    if (printers.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.noPrintersAvailable)));
      }
      return false;
    }

    // Load occupied slot counts for each printer
    final Map<int, int> occupiedSlots = {};
    for (final printer in printers) {
      final filaments = await _repository.getFilamentsByPrinter(printer.id!);
      occupiedSlots[printer.id!] = filaments.length;
    }

    // Select printer
    final selectedPrinter = await showDialog<Printer>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.selectPrinter),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: printers.map((printer) {
              final occupiedCount = occupiedSlots[printer.id!] ?? 0;
              final emptyCount = printer.slotCount - occupiedCount;

              return ListTile(
                title: Text(printer.name),
                subtitle: Row(
                  children: [
                    Text('${strings.slots}: ${printer.slotCount}'),
                    const SizedBox(width: 12),
                    Icon(Icons.check_circle, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '$occupiedCount',
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.circle_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '$emptyCount',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                onTap: () => Navigator.pop(context, printer),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
        ],
      ),
    );

    if (selectedPrinter == null) return false;

    // Get filaments already on this printer
    final filamentsOnPrinter = await _repository.getFilamentsByPrinter(
      selectedPrinter.id!,
    );

    // Select slot
    final selectedSlot = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${selectedPrinter.name} - ${strings.selectSlot}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(selectedPrinter.slotCount, (index) {
              final slotNumber = index + 1;

              // Check if slot is occupied
              final occupiedFilament = filamentsOnPrinter.firstWhere(
                (f) => f.slot == slotNumber,
                orElse: () => Filament(
                  id: -1,
                  brandId: -1,
                  materialId: -1,
                  colorId: -1,
                  status: FilamentStatus.active,
                  locationId: -1,
                ),
              );

              final isOccupied = occupiedFilament.id != -1;

              return ListTile(
                leading: Icon(
                  isOccupied ? Icons.cancel : Icons.check_circle,
                  color: isOccupied ? Colors.red : Colors.green,
                ),
                title: Text('${strings.slot} $slotNumber'),
                subtitle: isOccupied
                    ? Text(
                        '${strings.occupied} - ${strings.spool} ${occupiedFilament.id}',
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      )
                    : Text(
                        strings.available,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                onTap: () => Navigator.pop(context, slotNumber),
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
        ],
      ),
    );

    if (selectedSlot == null) return false;

    try {
      // Store old location before assignment
      final oldLocationId = filament.locationId;

      // First try without force
      await _repository.assignFilament(
        filament.id,
        selectedPrinter.id!,
        selectedSlot,
        force: false,
      );

      // Record assignment in history
      await _historyRepository.recordAssignedToPrinter(
        filamentId: filament.id,
        oldLocationId: oldLocationId,
        newPrinterId: selectedPrinter.id!,
        newSlot: selectedSlot,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.assigned)));
      }

      return true;
    } on SlotOccupiedException catch (e) {
      // Slot is occupied, ask where to move the old filament
      if (!context.mounted) return false;

      // Get the occupied filament details
      final occupiedFilament = filamentsOnPrinter.firstWhere(
        (f) => f.slot == selectedSlot,
      );

      // Get all storage locations (not "On Printer")
      final allLocations = await _locationRepository.getAllLocations();
      final storageLocations = allLocations
          .where((loc) => loc.name.toLowerCase() != 'on printer')
          .toList();

      if (storageLocations.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.noLocationsAvailable),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }

      // Ask user where to move the old filament
      final selectedLocation = await showDialog<dynamic>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(strings.selectLocationForOldFilament),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '${strings.spool} #${occupiedFilament.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageLocations.map((loc) {
                      return ListTile(
                        title: Text(loc.name),
                        onTap: () => Navigator.pop(context, loc),
                      );
                    }).toList(),
                  ),
                ),
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

      if (selectedLocation == null) return false;

      // Move old filament to selected location
      try {
        // Unassign old filament and record history
        await _repository.unassignFilamentToLocation(
          filamentId: occupiedFilament.id,
          locationId: selectedLocation.id,
        );

        await _historyRepository.recordUnassignedFromPrinter(
          filamentId: occupiedFilament.id,
          oldPrinterId: selectedPrinter.id!,
          oldSlot: selectedSlot,
          newLocationId: selectedLocation.id,
        );

        // Store old location of new filament before assignment
        final oldLocationId = filament.locationId;

        // Now assign new filament to the slot
        await _repository.assignFilament(
          filament.id,
          selectedPrinter.id!,
          selectedSlot,
          force: false, // Slot is now empty
        );

        // Record assignment in history
        await _historyRepository.recordAssignedToPrinter(
          filamentId: filament.id,
          oldLocationId: oldLocationId,
          newPrinterId: selectedPrinter.id!,
          newSlot: selectedSlot,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(strings.assigned)));
        }

        return true;
      } catch (e) {
        debugPrint('Error during slot replacement: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint('Error assigning: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
      return false;
    }
  }

  /// Unassign from printer (with location selection)
  /// Returns true if unassigned successfully
  static Future<bool> unassignWithLocation(
    BuildContext context,
    Filament filament,
    List<dynamic> locations,
  ) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    final selectedLocation = await showDialog<dynamic>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.selectLocation),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: locations.map((loc) {
              return ListTile(
                title: Text(loc.name),
                onTap: () => Navigator.pop(context, loc),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
        ],
      ),
    );

    if (selectedLocation == null) return false;

    try {
      // Store old printer info before unassignment
      final oldPrinterId = filament.printerId;
      final oldSlot = filament.slot;

      await _repository.unassignFilamentToLocation(
        filamentId: filament.id,
        locationId: selectedLocation.id,
      );

      // Record unassignment in history
      if (oldPrinterId != null && oldSlot != null) {
        await _historyRepository.recordUnassignedFromPrinter(
          filamentId: filament.id,
          oldPrinterId: oldPrinterId,
          oldSlot: oldSlot,
          newLocationId: selectedLocation.id,
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error unassigning: $e');
      return false;
    }
  }

  /// Move to different location
  /// Returns true if moved successfully
  static Future<bool> moveToLocation(
    BuildContext context,
    Filament filament,
    List<dynamic> locations,
  ) async {
    final strings = AppStrings.of(Localizations.localeOf(context));

    final availableLocations = locations
        .where((loc) => loc.id != filament.locationId)
        .toList();

    if (availableLocations.isEmpty) return false;

    final selectedLocation = await showDialog<dynamic>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.moveToLocation),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableLocations.map((loc) {
              return ListTile(
                title: Text(loc.name),
                onTap: () => Navigator.pop(context, loc),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
        ],
      ),
    );

    if (selectedLocation == null) return false;

    try {
      // Store old location before move
      final oldLocationId = filament.locationId;

      await _repository.updateFilament(
        filament.copyWith(locationId: selectedLocation.id),
      );

      // Record location change in history
      await _historyRepository.recordLocationChanged(
        filamentId: filament.id,
        oldLocationId: oldLocationId,
        newLocationId: selectedLocation.id,
      );

      return true;
    } catch (e) {
      debugPrint('Error moving: $e');
      return false;
    }
  }
}
