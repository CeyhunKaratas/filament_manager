# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

---

## [0.1.0-alpha] – 2026-01-XX

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
