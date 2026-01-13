# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

---
## [0.4.2-beta] — 2026-01-14

### Added
- **Dashboard** - New home screen with inventory overview
  - Total filaments and grams display
  - Status distribution (Active/Used/Low/Finished)
  - Printer occupancy summary
  - Low stock alerts
  - Recent filaments list
- **Help System** - In-app user guide with full documentation
  - Comprehensive HELP.md file
  - In-app markdown viewer
  - Help menu in drawer

### Changed
- Project stage changed from Alpha to Beta
- Dashboard is now the default landing page
- Reports renamed to Inventory in menu
- Ready for public testing

### Technical
- Added flutter_markdown dependency
- HELP.md added to assets

---

## [0.4.1-alpha] — 2026-01-13

### Fixed
- **Issue #7 - Bug 1**: Inventory Report location sorting now groups printers first, then sorts by printer name and slot
- **Issue #7 - Bug 1**: Inventory Report location filter now correctly excludes filaments assigned to printers
- **Issue #7 - Bug 1**: Location filter dropdown now only shows storage locations (excludes printer assignments)
- Printer Detail page status calculation bug fixed (was showing incorrect status due to duplicate setState)

### Added
- **Issue #7 - Enhancement 1**: Assign dialog now shows slot availability status (occupied/empty with spool ID)
- **Issue #7 - Enhancement 1**: Printer selection dialog shows occupied/empty slot counts
- **Issue #7 - Enhancement 1**: Printer list page shows occupied/empty slot counts for each printer
- **Issue #7 - Enhancement 2**: Save Status dialog auto-selects and highlights gram input for faster editing
- **Issue #7 - Enhancement 3**: Inventory Report now displays current gram weight for each filament
- **Issue #7 - Enhancement 4**: Filament Group Detail now displays current gram weight for each spool
- **Issue #7 - Bug 1**: "On Printers" filter added to Inventory Report to show only assigned filaments
- Printer Detail page now displays spool ID next to filament information

### Changed
- Improved location filtering logic to distinguish between storage locations and printer assignments
- Printer list and assign dialogs now provide better visibility of slot occupancy

---

## [0.4.0-alpha] — 2026-01-12

### Added
- **Gram-based history system** (Work in Progress)
  - FilamentHistory table for tracking gram changes
  - Automatic status calculation based on gram
  - Photo and note support in history

### Changed
- Status is now calculated automatically, not manually set
- Breaking change: Status system redesigned

---

## [0.3.2-beta] — 2026-01-11

### Added
- **Color and Location filters** in Inventory Report
- **Sorting options** in Inventory Report
  - Sort by: Spool ID, Brand, Material, Status, Location
  - Ascending/Descending toggle
- Only used definitions shown in filters and dropdowns
  - Add/Edit filament screens show only brands/materials/colors that are in use
  - Inventory Report filters show only used options

### Fixed
- Issue #3: Add filtering and sorting options to Reports screen
- Issue #4: Hide unused brands, materials and colors from selection popups
- Issue #5: Import fails silently - no error message shown to user
- Improved export/import system with file picker and detailed statistics
- Android APK signing configuration added for proper app updates

### Changed
- Export/Import now uses file picker for better UX
- Export shows detailed statistics (counts of exported items)
- Import shows detailed statistics (counts of imported items)

---

## [0.3.1-beta] — 2026-01-10

### Added
- **Edit Filament** - Edit existing filament properties
  - Change brand, material, color, location
  - Filament automatically moves to correct group if brand/material/color changed
  - OCR support for re-scanning labels
- **Delete Filament** - Delete unwanted filaments
  - Confirmation dialog before deletion
  - Group automatically removed if all filaments deleted

### Fixed
- **Issue #1**: Cannot change filament color after creation (forces "Finished" workaround)
  - Users can now edit filament properties after creation
  - No need to mark as "Finished" for incorrect data

---

## [0.3.0-beta] — 2026-01-09

### Added
- **Inventory Report** - New reporting feature
  - View all filaments in a filterable list
  - Filter by status (Active/Low/Finished)
  - Filter by brand
  - Filter by material
  - Toggle to show/hide finished filaments
  - Summary count of total spools
  - Visual status indicators with color dots
  - Location display (printer/slot or storage location)
- Reports menu item added to navigation drawer

### Changed
- Project stage changed from Alpha to Beta
- App is now ready for limited public testing

---

## [0.2.0-alpha] — 2026-01-09

### Added
- **Export/Import Data** - Backup and restore all data as JSON
  - Export creates shareable JSON file
  - Import supports two modes: Replace All or Merge
  - Automatic backup file copying to Downloads folder
- **Settings Page** - New dedicated settings screen
  - Export data functionality
  - Import data functionality
  - App version info
- **Onboarding Screen** - First-time user tutorial
  - 4-slide introduction to app features
  - Welcome, Add Filaments, Assign to Printers, OCR Scan
  - Skip and Next navigation
  - Shows only on first launch

### Fixed
- Black screen when deleting last filament in group
- Definition cache not updating after adding new brand/material/color
- Autocomplete search not filtering results properly

### Improved
- All artifact code now includes proper error handling
- Better user feedback with loading indicators
- Consistent error messages across the app

### Technical
- Added `path_provider`, `share_plus`, `shared_preferences` packages
- Android SDK updated to compile against SDK 36
- Build configuration optimized for release

---

## [0.1.1-alpha] — 2026-01-08

### Changed
- **Database version reset to v1** - Fresh start for official first release
- Previous development versions (v2-v6) deprecated

### Fixed
- Slot list not updating when changing printer in assign dialog
- Autocomplete search not filtering results in filament add screen
- New brands/materials/colors showing as "-" in group list after adding
- Printer deletion leaving orphan filaments (now moves them to default location)

### Improved
- Added error handling to all database operations
- Fixed memory leaks (TextEditingController disposal)
- Added loading indicators for async operations
- Improved printer deletion flow with user confirmation

### Notes
- ⚠️ **Breaking Change**: Previous development versions require app reinstall
- This is the first stable database version (v1)
- Database schema is now considered stable

---

## [0.1.0-alpha] — 2026-01-07

### Added
- Core filament management with brand, material and color definitions
- Filament grouping by brand + material + color
- Group list and group detail screens
- Filament status management (active / low / finished)
- Printer slot assignment and unassignment
- Location-based filament storage
- OCR scanning from camera (experimental)
- OCR-based prefill for brand, material and color fields
- Persistent local SQLite database (no automatic resets)

### Changed
- Filament identification standardized to ID-based storage (UI shows names, DB stores IDs)
- Group detail header simplified (brand / material / color shown once)
- Finished filaments hidden from group list counts

### Known Issues
- OCR accuracy depends heavily on lighting and label quality
- Autocomplete fields may require focus change to trigger resolution

### Notes
- This is an **alpha release** intended for internal and limited testing
- Database schema is considered stable starting from this version
- Breaking DB changes will increment the major version