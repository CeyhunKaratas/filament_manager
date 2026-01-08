# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

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
- No data export or backup yet

### Notes
- This is an **alpha release** intended for internal and limited testing
- Database schema is considered stable starting from this version
- Breaking DB changes will increment the major version