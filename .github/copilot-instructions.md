# Filament Manager – Copilot Instructions

**Version:** 0.5.3-beta | **Stack:** Flutter + Dart + SQLite (local-only, no backend/cloud)

## Architecture Overview

The app manages 3D printer filament inventory with **ID-based data modeling** and **audit trail history**. No cloud sync or state management library—uses direct repository pattern with context-based navigation.

### Core Layers

1. **Models** (`lib/core/models/`) – Data structures (Filament, Printer, Location, FilamentGroup)
2. **Database** (`lib/core/database/`) – SQLite repositories (FilamentRepository, FilamentHistoryRepository, LocationRepository, PrinterRepository)
3. **Services** (`lib/core/services/`) – Business logic (FilamentActions, ExportImportService, BetaTrackerService)
4. **Features** (`lib/features/`) – UI pages organized by domain (filaments, printers, locations, reports, etc.)
5. **OCR** (`lib/core/ocr/`) – Core OCR logic (reusable across features)
6. **L10n** (`lib/l10n/`) – Localization via AppStrings (manual switch-case, supports en/tr/de/fr/it/es)

## Critical Data Model Rules (Non-Negotiable)

### ID-Based Storage
- **All definitions** (brand, material, color, location, printer) are stored by **IDs**, not names
- UI displays names; DB stores only IDs
- Example: `Filament` has `brandId`, `materialId`, `colorId` → repository resolves IDs to names for display

### Filament Location Model
- Each filament is **either**:
  - Stored in a location: `locationId` is set
  - Assigned to printer: `printerId + slot` are set
- Never both simultaneously

### Filament Grouping
- **Group key:** `brandId + materialId + colorId`
- Finished filaments are **hidden** from group counts and list displays
- Groups with **only finished filaments** are not shown at all
- FilamentGroup model: `lib/core/models/filamentgroup.dart`

### Filament Status
- Enum: `FilamentStatus { active, used, low, finished }`
- **Calculated** from gram history (see `lib/core/utils/status_calculator.dart`):
  - active: >500g
  - used: 100–500g
  - low: <100g
  - finished: 0g
- Storage value may differ from calculated value

## History & Audit Trail

**Every filament state change is recorded** in FilamentHistoryRepository:

- `recordAssignedToPrinter()` – Assignment to printer slot + old location tracking
- `recordUnassignedFromPrinter()` – Unassignment from printer
- `recordLocationChanged()` – Movement between storage locations
- `recordGramUpdate()` – Weight updates with optional photos/notes

**Key pattern:** Always store **old state before change**, then record the transition (see lines 529–534 in FilamentActions.dart).

## FilamentActions Service

Central business logic for filament operations. All methods:
- Accept `BuildContext` for dialogs and snackbars
- Return `Future<bool>` (whether data changed)
- Handle errors gracefully with user feedback
- Record history after state changes

**Example operations:**
- `saveStatus()` – Open history add page
- `assignToPrinter()` – Complex: handles slot conflicts, prompts user to relocate existing filament
- `moveToLocation()` – Store old location, update, record history
- `delete()` – Confirmation dialog, cleanup, feedback

## Navigation & State Management

- **No state management library** (no Provider, Bloc, etc.) – uses direct repository calls
- **Navigation:** `Navigator.push()` with `MaterialPageRoute`
- **Return values:** Pages return booleans (true = data changed) to signal refresh to caller
- **UI refresh:** Caller re-fetches data after page returns

## Localization (L10n)

- Manual implementation via `AppStrings` class
- Access: `AppStrings.of(Localizations.localeOf(context)).addFilament`
- Define all strings in `lib/l10n/app_strings.dart` using switch on `locale.languageCode`
- **Never hardcode English strings**
- Supported locales: en, tr, de, fr, it, es

## Export/Import (Data Backup)

- **Location:** `lib/core/export_import/export_import_service.dart`
- **Format:** JSON (includes all filaments, definitions, printers, history)
- **Modes:**
  - Replace All: Delete existing data, restore from backup
  - Merge: Keep existing data, add items from backup
- **Beta tracker:** Preserved in backups (see `BetaTrackerService`)

## OCR Architecture

**Split into core logic and UI:**

### Core OCR Layer (`lib/core/ocr/`)
- `OcrAnalyzer` – Entry point; calls text extraction + normalization
- `OcrTextExtractor` – Extracts and cleans text from images
- `OcrResult` – Data class with `foundBrandNames[]`, `foundMaterialNames[]`, `foundColorNames[]`, `imagePaths[]`

**Reusable by:** FilamentAddPage, ScanOcrPage, future features

### UI Integration Rules
- OCR is **never auto-save** – user must confirm results
- Results are suggestions, not facts
- Can pre-fill fields in add/edit pages

## Project-Specific Conventions

### File Naming
- Pages: `*_page.dart` (e.g., `filament_add_page.dart`)
- Screens: `*_screen.dart` (e.g., `definitions_home_screen.dart`)
- Repositories: `*_repository.dart`

### Repository Pattern
- Singleton instances in services/pages (not global)
- No async initialization – database is lazy-loaded
- Methods return typed Future (e.g., `Future<Filament>`, not `Future<dynamic>`)

### Error Handling
- Custom exceptions: `SlotOccupiedException` (caught and handled in FilamentActions)
- User-facing errors: Show SnackBar via `ScaffoldMessenger`
- Debug errors: `debugPrint()`

### Dialog/Navigation Returns
- Dialogs return `Navigator.pop(context, value)`
- Check for `null` before using (user cancelled)
- Example: `final selectedPrinter = await showDialog<Printer>(...)`

## Database & SQLite

**Initialization:** `DatabaseHelper.instance.database` (lazy singleton)

**Tables:** See `lib/core/database/tables.dart`

**Key repositories:**
- `FilamentRepository` – CRUD filaments, assign to printer, move to location
- `FilamentHistoryRepository` – Insert history records, query gram updates
- `LocationRepository`, `PrinterRepository` – Definition management

**No migrations visible to features** – DatabaseHelper handles schema

## Build & Run

- **Flutter version:** ^3.10.4
- **Target:** Android (iOS untested)
- **Database:** Local SQLite (persistent after first run – no auto-reset)
- **Build command:** `flutter build apk` (release) or `flutter run` (debug)

## Important Dev Rules (from PROJECT_CONTEXT.md)

1. **NO assumptions** – Ask if a file is missing
2. **Small revisions** (≤10 lines): Use "Find this → Replace with this" format
3. **Large revisions:** Provide the full file, state lines removed, explain why
4. **Database is persistent** – No auto-resets after v0.5.0
5. **Filament grouping** – Use `lib/core/models/filamentgroup.dart`; ignore older group models under `features/`

## Common Workflows

### Adding a New Feature
1. Create page in `lib/features/[feature]/`
2. If data is needed, use existing repository (or extend if necessary)
3. Use `FilamentActions` for business logic, not raw repositories
4. Use `AppStrings` for all user-facing text
5. Record history via `FilamentHistoryRepository` if data changes

### Modifying Filament State
1. Store **old state** before change
2. Call repository method to update
3. Call `_historyRepository.record*()` with old + new state
4. Show user feedback via SnackBar
5. Return `true` to signal data change

### Debugging Database Issues
- Check `lib/core/database/database_helper.dart` for schema
- Use `FilamentRepository.getAllFilamentsWithStatus()` to check calculated status
- Verify `locationId` is always set (not null)
- Check `FilamentHistoryRepository` for audit trail
