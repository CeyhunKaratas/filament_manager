# Filament Manager

Filament Manager is a mobile application built with **Flutter + SQLite** to help 3D printer users track, organize and manage their filament inventory.

The app focuses on **clarity, speed and daily usability**, not cloud features or accounts.

---

## 🚧 Project Status

- **Current version:** `0.3.1-beta`
- **Stage:** Beta (limited public testing)
- **Database:** Local SQLite (persistent)
- **Platform:** Android (iOS not tested yet)

This project is actively used by its author and under continuous development.

---

## ✨ Features

### Filament Management
- Add filaments by **brand, material and color**
- Store filaments by **location** or assign them to **printers and slots**
- Track filament status:
  - Active
  - Low
  - Finished

### Grouping Logic
- Filaments are grouped by: brand + material + color
- Group list shows:
  - Only active / low filaments in counts
  - Groups with only finished filaments are hidden
- Group detail screens hide finished filaments

### Data Management
- **Export Data** - Backup all your data to a JSON file
- **Import Data** - Restore from backup with two modes:
  - Replace All: Delete existing data and restore from backup
  - Merge: Keep existing data and add items from backup
- Backup files can be shared via any app

### Reports
- **Inventory Report** - Detailed view of all filaments
  - Filter by status, brand, material
  - Toggle to show/hide finished filaments
  - Summary of total spools

### Onboarding
- First-time user tutorial
- Introduction to key features
- Can be skipped

### OCR (Experimental)
- Scan filament labels using the device camera
- OCR assists with:
  - Brand detection
  - Material detection
  - Color detection
- OCR results **never auto-save**
- User confirmation is always required

### UI / UX
- Real filament colors are shown in the UI
- Fast, list-based navigation
- Autocomplete fields for all definitions
- Inline creation of new brands, materials and colors

---

## 🧱 Technical Overview

- **Flutter**
- **Dart**
- **SQLite**
- **camera plugin**
- **On-device OCR**
- No backend
- No cloud sync
- No user accounts

---

## 🗄️ Data Model Principles

- Database stores **IDs only**
- UI displays **names**
- Filament grouping is strictly ID-based
- **Database version: v1** (stable as of v0.1.1-alpha)
- Breaking database changes will increment the **major version**

---

## 📦 Project Structure (Simplified)
lib/
├─ core/
│ ├─ database/
│ ├─ models/
│ ├─ ocr/
│ ├─ export_import/
│ └─ widgets/
├─ features/
│ ├─ filaments/
│ ├─ printers/
│ ├─ scan/
│ ├─ definitions/
│ ├─ settings/
│ ├─ onboarding/
│ └─ reports/
├─ l10n/
└─ main.dart

---

## 🔖 Versioning

This project follows **Semantic Versioning**: MAJOR.MINOR.PATCH[-stage]

Examples:
- `0.1.0-alpha`
- `0.2.0-alpha`
- `0.3.0-beta`
- `1.0.0`

All changes are documented in [`CHANGELOG.md`](./CHANGELOG.md).

---

## ⚠️ Known Limitations

- OCR accuracy depends on lighting and label quality
- No cloud sync
- UI polish is still in progress
- Import requires backup file to be in Downloads folder

---

## 🧪 Beta Usage Notes

- This version is intended for **limited public testing**
- The database is persistent — uninstalling the app will remove data
- Always export your data before updating to a new version
- Import mode guidance:
  - **Replace All** is the default / safest option
  - **Merge** is advanced and should be used carefully

---

## 🛣️ Roadmap

### Planned for Future Versions
- Statistics dashboard
- UI polish and refinements
- Advanced reporting features

### Future (post-beta)
- Cloud sync (optional)
- Multiple language support improvements
- Cost analysis and usage trends

---

## 📄 License

License will be defined later.