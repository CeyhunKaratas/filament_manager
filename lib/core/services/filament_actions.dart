import 'package:flutter/material.dart';
import '../models/filament.dart';
import '../models/printer.dart';
import '../database/filament_repository.dart';
import '../database/filament_history_repository.dart';
import '../../features/filaments/filament_edit_page.dart';
import '../../features/filaments/filament_history_add_page.dart';
import '../../features/filaments/filament_history_list_page.dart';
import '../../l10n/app_strings.dart';

class FilamentActions {
  static final FilamentRepository _repository = FilamentRepository();
  static final FilamentHistoryRepository _historyRepository =
      FilamentHistoryRepository();

  /// Save status (open history add page)
  /// Returns true if data changed
  static Future<bool> saveStatus(
    BuildContext context,
    Filament filament,
  ) async {
    final latestHistory = await _historyRepository.getLatestHistory(
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

    // Select printer
    final selectedPrinter = await showDialog<Printer>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.selectPrinter),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: printers.map((printer) {
              return ListTile(
                title: Text(printer.name),
                subtitle: Text('${strings.slots}: ${printer.slotCount}'),
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
              return ListTile(
                title: Text('${strings.slot} $slotNumber'),
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
      // First try without force
      await _repository.assignFilament(
        filament.id,
        selectedPrinter.id!,
        selectedSlot,
        force: false,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.assigned)));
      }

      return true;
    } on SlotOccupiedException catch (e) {
      // Slot is occupied, ask for confirmation
      if (!context.mounted) return false;

      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(strings.slotOccupied),
          content: Text(strings.slotOccupiedMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(strings.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(strings.replace),
            ),
          ],
        ),
      );

      if (confirm != true) return false;

      // Retry with force=true
      try {
        await _repository.assignFilament(
          filament.id,
          selectedPrinter.id!,
          selectedSlot,
          force: true,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(strings.assigned)));
        }

        return true;
      } catch (e) {
        debugPrint('Error force assigning: $e');
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
      await _repository.unassignFilamentToLocation(
        filamentId: filament.id,
        locationId: selectedLocation.id,
      );
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
      await _repository.updateFilament(
        filament.copyWith(locationId: selectedLocation.id),
      );
      return true;
    } catch (e) {
      debugPrint('Error moving: $e');
      return false;
    }
  }
}
