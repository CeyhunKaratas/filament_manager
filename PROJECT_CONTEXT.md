# Filament Manager – Project Context

This document is the single source of truth for the Filament Manager project.
All discussions, reviews and revisions must follow the rules defined here.

---

## 1. Project Overview

Filament Manager is a Flutter + SQLite mobile application for managing 3D printer filaments.

The app allows users to:
- Track filaments by brand, material and color
- Group filaments logically (brand + material + color)
- Assign filaments to printers and slots
- Track filament status (active / low / finished)
- Store filaments in locations when not assigned
- Use OCR (camera-based) to assist filament entry (experimental)

The app is currently in **beta stage** and is actively used by the developer.

---

## 2. Current Version

- Version: **0.4.0-alpha**
- Version source: `pubspec.yaml`
- Changelog: `CHANGELOG.md`
- Database: SQLite (local, persistent)

From this version onward, the database is considered **persistent and real**.
No automatic DB resets are allowed.

---

## 3. Technical Stack

- Flutter
- Dart
- SQLite
- camera (Flutter plugin)
- OCR (local, on-device)
- No backend
- No cloud sync (yet)

---

## 4. Core Data Model Rules (NON-NEGOTIABLE)

### Filament
- Stored by **IDs**, not names
- Fields:
  - brandId
  - materialId
  - colorId
  - status
  - locationId OR printerId + slot

### UI vs DB
- UI shows **names**
- DB stores **IDs only**

### Filament Grouping
- Group key: brandId + materialId + colorId
- FilamentGroup model lives in: lib/core/models/filamentgroup.dart
- Any older group models under `features/` are invalid.

---

## 5. Filament Status Rules

Statuses:
- active
- low
- finished

Rules:
- Finished filaments:
- Are hidden from group list counts
- Are hidden from group detail screens
- Groups with only finished filaments are not shown
- Finished filaments may be used later for reporting

---

## 6. OCR Architecture

OCR is split into **core logic** and **UI layers**.

### Core OCR (reusable)
Location: lib/core/ocr/

Responsibilities:
- Text extraction
- Normalization
- Quality evaluation
- Keyword matching

Core OCR must be reusable by:
- Scan OCR test screen
- Add Filament screen
- Future features

### OCR Output Contract
OCR produces:
- foundBrandNames[]
- foundMaterialNames[]
- foundColorNames[]
- imagePaths[]

UI decides how to apply these results.

---

## 7. Add Filament Screen Rules

Location: lib/features/filaments/filament_add_page.dart

Rules:
- Uses Autocomplete fields for:
  - Brand
  - Material
  - Color
- Clicking into a field shows options even without typing
- If OCR pre-fills a field, resolution logic still applies
- New definitions (brand/material/color) can be created via dialogs
- Location selection is always visible

---

## 8. Revision Rules (STRICT)

### General
- NO assumptions
- NO guessing missing code
- If a file is needed and not provided → ask for it
- ZIP contents are the only valid source of truth

### Small revisions (≤ ~10 lines)
Allowed format:
- “Find this → replace with this”
- “Find this → append this”

### Large revisions
- Provide the **full file**
- Do NOT make unrelated changes
- If lines are removed:
  - State approximately how many lines were removed
  - Explain why

### Forbidden
- Refactoring without request
- Removing working logic
- Simplifying UI or flows on your own initiative

---

## 9. Versioning Rules

Semantic Versioning:
- MAJOR → breaking DB change
- MINOR → new feature, DB compatible
- PATCH → UI / bugfix

Alpha versions use: x.y.z-alpha  
Beta versions use: x.y.z-beta

Every version must be documented in `CHANGELOG.md`.

---

## 10. Development Philosophy

Current priority:
- Stability
- Daily usability
- UX polish
- No new major features

Future (not now):
- Reporting
- Export / backup
- Cloud sync
- Advanced OCR improvements

---

## 11. Communication Contract

When working on this project:
- Follow this document as absolute truth
- Ask before changing behavior
- Prefer clarity over speed
- Respect existing working code

This project is actively used by its author.
