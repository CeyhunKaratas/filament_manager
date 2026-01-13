import 'package:flutter/material.dart';
import '../../core/models/filament.dart';
import '../../l10n/app_strings.dart';

class FilamentPopupMenu extends StatelessWidget {
  final Filament filament;
  final Function(String action, Filament filament) onAction;
  final bool showLocationOptions;

  const FilamentPopupMenu({
    super.key,
    required this.filament,
    required this.onAction,
    this.showLocationOptions = true,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context));

    return PopupMenuButton<String>(
      onSelected: (value) => onAction(value, filament),
      itemBuilder: (_) => [
        // Save Status
        PopupMenuItem<String>(
          value: 'save_status',
          child: Text(strings.saveStatus),
        ),

        // View History
        PopupMenuItem<String>(
          value: 'view_history',
          child: Text(strings.history),
        ),

        const PopupMenuDivider(),

        // Edit
        PopupMenuItem<String>(value: 'edit', child: Text(strings.edit)),

        // Delete
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            strings.delete,
            style: const TextStyle(color: Colors.red),
          ),
        ),

        const PopupMenuDivider(),

        // Assign/Change Slot
        PopupMenuItem<String>(
          value: 'assign',
          child: Text(
            filament.printerId == null ? strings.assign : strings.changeSlot,
          ),
        ),

        // Conditional: Location options
        if (showLocationOptions) ...[
          const PopupMenuDivider(),

          // Move to Location (only if not assigned)
          if (filament.printerId == null)
            PopupMenuItem<String>(
              value: 'move_location',
              child: Text(strings.moveToLocation),
            ),

          // Unassign (only if assigned)
          if (filament.printerId != null)
            PopupMenuItem<String>(
              value: 'unassign',
              child: Text(strings.unassign),
            ),
        ],
      ],
    );
  }
}
