# 3D Farm Manager

3D Farm Manager is a mobile application built with **Flutter + SQLite** to help 3D printer users track, organize and manage their filament inventory.

The app focuses on **clarity, speed and daily usability**, not cloud features or accounts.

---

## 🚧 Project Status

- **Current version:** `0.5.1-beta`
- **Stage:** Beta (limited public testing)
- **Database:** Local SQLite (persistent)
- **Platform:** Android (iOS not tested yet)

This project is actively used by its author and under continuous development.

---

## 🎁 Beta Tester Program

**Install v0.5.0-beta before March 1, 2026 and get LIFETIME FREE ACCESS!**

Anyone who installs this beta version will receive permanent free access to all features, even if the app becomes paid in the future. Your beta tester status is preserved through Export/Import.

---

## ✨ Features

### Dashboard
- Quick overview of your filament inventory
- Total filaments and grams at a glance
- Status distribution (Active/Used/Low/Finished)
- Printer occupancy summary
- Low stock alerts
- Quick navigation buttons to key features

### Filament Management
- Add filaments by **brand, material and color**
- **Gram-based history tracking** with photos and notes
- **Movement tracking** - Full audit trail of all filament movements
  - Assignment to printers
  - Location changes
  - Slot changes
  - Unassignments
- Full-screen photo viewer for history images
- Store filaments by **location** or assign them to **printers and slots**
- Automatic status calculation based on remaining grams
- Track filament status:
  - Active (>500g)
  - Used (100-500g)
  - Low (<100g)
  - Finished (0g)

### Grouping Logic
- Filaments are grouped by: brand + material + color
- Group list shows:
  - Only active / low filaments in counts
  - Groups with only finished filaments are hidden
- Group detail screens hide finished filaments

### Data Management
- **Export Data** - Backup all your data to a JSON file (includes history records)
- **Import Data** - Restore from backup with two modes:
  - Replace All: Delete existing data and restore from backup
  - Merge: Keep existing data and add items from backup
- Backup files can be shared via any app
- Beta tester status preserved in backups

### Reports
- **Inventory Report** - Detailed view of all filaments
  - Filter by status, brand, material, location
  - "On Printers" filter to show only assigned filaments
  - Toggle to show/hide finished filaments
  - Displays current gram weight for each spool
  - Summary of total spools

### Help System
- Comprehensive in-app documentation
- HELP.md with full feature guide
- Accessible from navigation menu

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
- Quick action buttons on dashboard cards

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
```
lib/
├── core/
│   ├── database/
│   ├── models/
│   ├── ocr/
│   ├── export_import/
│   ├── services/
│   └── widgets/
├── features/
│   ├── dashboard/
│   ├── filaments/
│   ├── printers/
│   ├── scan/
│   ├── definitions/
│   ├── settings/
│   ├── onboarding/
│   ├── help/
│   └── reports/
├── l10n/
└── main.dart
```

---

## 📖 Versioning

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
- OCR cannot read digital scale displays (7-segment LEDs)
- No cloud sync
- UI polish is still in progress

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

### Planned for v0.6.0
- Statistics & Reports dashboard
- Monthly/yearly consumption charts
- Brand and material usage statistics
- CSV/PDF export

### Future (post-beta)
- Cloud sync (optional)
- Multiple language support improvements
- Cost analysis and usage trends
- Advanced filtering and search

---

## 📄 License & Copyright

**© 2026 Ceyhun Karataş. All Rights Reserved.**

This software is provided free of charge for personal use. The source code is publicly available for transparency and security review purposes only.

**You may NOT:**
- Copy, modify, or redistribute this code
- Create derivative works
- Use this code in commercial projects
- Relicense or sublicense this software

**You may:**
- Use the application for free
- Review the code for security purposes
- Report issues and contribute ideas

For any other use, please contact the author.

---

**Contact:** [GitHub Issues](https://github.com/CeyhunKaratas/filament_manager/issues)