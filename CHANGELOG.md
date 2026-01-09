# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

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

### Notes
- Database is persistent — uninstalling the app will remove data
- Export your data before updating to a new version
- Import mode guidance:
  - Replace All = default / safest
  - Merge = advanced / use carefully

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