# Filament Manager - User Guide

Welcome to **Filament Manager**! This guide will help you get the most out of the app.

---

## 📖 Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Dashboard](#dashboard)
4. [Filament Management](#filament-management)
5. [Printer Management](#printer-management)
6. [Location Management](#location-management)
7. [Inventory](#reports)
8. [Definitions](#definitions)
9. [OCR Scanning](#ocr-scanning)
10. [Export & Import](#export--import)
11. [FAQ](#faq)
12. [Tips & Tricks](#tips--tricks)

---

## 🎯 Introduction

Filament Manager is a mobile app designed to help 3D printing enthusiasts track and manage their filament inventory efficiently.

**Key Features:**
- Track filament by brand, material, and color
- Monitor filament weight (gram tracking)
- Assign filaments to printers and slots
- View comprehensive reports
- Export/Import data for backup

---

## 🚀 Getting Started

### First Launch

When you first open the app, you'll see an **onboarding tutorial** that introduces you to the main features.

### Main Navigation

Access all features from the **side menu** (☰):
- **Dashboard** - Overview of your inventory
- **Inventory** - Detailed inventory reports
- **Filaments** - Browse all filaments
- **Printers** - Manage your 3D printers
- **Locations** - Storage locations
- **Scan OCR** - Quick filament entry
- **Definitions** - Brands, materials, colors
- **Settings** - App configuration

---

## 📊 Dashboard

The Dashboard provides a quick overview of your entire filament inventory.

**What You'll See:**
- **Total Filaments** - Number of active spools
- **Total Grams** - Combined weight of all filaments
- **Status Distribution** - Breakdown by Active/Used/Low/Finished
- **Printer Occupancy** - How many slots are occupied
- **Low Stock Alert** - Filaments running low
- **Recent Filaments** - Last 5 added spools

**Refresh:** Pull down to refresh data or tap the refresh icon.

---

## 🎨 Filament Management

### Adding a Filament

1. Go to **Filaments** from the menu
2. Tap the **+** (floating action button)
3. Fill in the details:
   - **Brand** (e.g., eSun, Prusament)
   - **Material** (e.g., PLA, PETG, ABS)
   - **Color**
   - **Initial Weight** (grams)
   - **Location** (where it's stored)
4. Tap **Save**

**Tip:** Use the **Scan OCR** feature to quickly fill in brand/material/color from the filament label!

---

### Viewing Filaments

**Filament List Page:**
- Filaments are **grouped** by Brand + Material + Color
- Each group shows:
  - Number of Active/Used/Low spools
  - Color indicator
  - Quick status overview
- Tap a group to see individual spools

**Group Detail Page:**
- View all spools in the group
- See current location or printer assignment
- Each spool shows:
  - Spool ID
  - Current weight (gram)
  - Status (Active/Used/Low/Finished)
  - Location or Printer + Slot

---

### Gram Tracking (Save Status)

Track how much filament remains on each spool.

**How to Save Status:**
1. Tap the **⋮** menu on any spool
2. Select **Save Status**
3. Enter current weight in grams
4. Optionally:
   - Add a **photo** of the spool
   - Add a **note**
5. Tap **Save**

**Auto Status Calculation:**
- **Active** - Above 70% remaining
- **Used** - Between 30-70% remaining
- **Low** - Between 1-30% remaining
- **Finished** - 0 grams

**View History:**
- Tap **⋮** → **History**
- See all weight records with photos and notes

---

### Editing a Filament

1. Tap **⋮** menu on any spool
2. Select **Edit**
3. Modify any details
4. Tap **Save**

**Note:** Changing brand/material/color will move the filament to a different group.

---

### Deleting a Filament

1. Tap **⋮** menu on any spool
2. Select **Delete**
3. Confirm deletion

**Swipe to Delete:** In Group Detail page, swipe left on any spool.

---

## 🖨️ Printer Management

### Adding a Printer

1. Go to **Printers** from menu
2. Tap the **+** button
3. Enter:
   - **Printer Name**
   - **Number of Slots** (e.g., 4 for AMS)
4. Tap **Add**

---

### Viewing Printer Details

Tap on any printer to see:
- Printer name and total slots
- Which filaments are in which slots
- Empty slots
- Status indicators for each slot

---

### Assigning Filaments to Printers

**Method 1: From Filament Menu**
1. In Group Detail, tap **⋮** on a spool
2. Select **Assign** or **Change Slot**
3. Choose a printer
4. Choose a slot
5. If slot is occupied, confirm replacement

**Method 2: Direct Tap**
1. In Group Detail, **tap on a spool**
2. Assign dialog opens automatically

**Slot Status:**
- **Green checkmark** - Slot is occupied
- **Gray circle** - Slot is empty
- Shows which spool ID occupies each slot

---

### Unassigning Filaments

1. Tap **⋮** menu on assigned spool
2. Select **Unassign**
3. Choose a storage location

The filament returns to storage.

---

### Deleting a Printer

1. **Long press** on a printer in the list
2. If printer has filaments:
   - Confirm moving them to storage
   - Printer will be deleted
3. If printer is empty:
   - Simple confirmation dialog

---

## 📍 Location Management

Locations are storage places for filaments not currently on printers.

### Default Location

Every installation has a **DEFAULT** location that cannot be deleted.

### Adding a Location

1. Go to **Locations** from menu
2. Tap the **+** button
3. Enter location name (e.g., "Shelf A", "Dry Box", "Basement")
4. Tap **Add**

### Moving Filaments Between Locations

1. Tap **⋮** menu on a spool (must not be on printer)
2. Select **Move to Location**
3. Choose destination location

---

## 📈 Inventory

### Inventory Report

Comprehensive view of all filaments with advanced filtering and sorting.

**Access:** Menu → Inventory

**Features:**
- View all filaments in a list
- Each filament shows:
  - Brand / Material / Color
  - Current weight (grams)
  - Location or Printer + Slot
  - Status indicator
  - Spool ID

**Show Finished Toggle:**
- By default, finished filaments are hidden
- Check the box to include them

**Filtering (tap filter icon):**
- **Status** - Active/Used/Low/Finished
- **Brand** - Filter by specific brand
- **Material** - Filter by material type
- **Color** - Filter by color
- **Location** - Storage locations only
- **On Printers** - Show only filaments on printers

**Sorting (tap sort icon):**
- **Spool ID** - Numerical order
- **Brand** - Alphabetical
- **Material** - Alphabetical
- **Status** - By status type
- **Location** - Printers first, then storage (alphabetical)
- **Ascending/Descending** toggle

**Active filters** are indicated by a blue filter icon.

---

## 🏷️ Definitions

Manage your brands, materials, and colors.

### Brands

Add brands you use (e.g., eSun, Prusament, Overture).

**Adding a Brand:**
1. Go to **Definitions** → **Brands**
2. Tap **+**
3. Enter brand name
4. Tap **Save**

### Materials

Add material types (e.g., PLA, PETG, ABS, TPU).

**Adding a Material:**
1. Go to **Definitions** → **Materials**
2. Tap **+**
3. Enter material name
4. Tap **Save**

### Colors

Add colors with visual representation.

**Adding a Color:**
1. Go to **Definitions** → **Colors**
2. Tap **+**
3. Enter color name
4. Pick color from palette
5. Tap **Save**

**Note:** Only brands/materials/colors that are currently in use will appear in dropdown lists when adding filaments.

---

## 📸 OCR Scanning

Use your camera to quickly extract information from filament labels.

### How to Use OCR

1. Go to **Scan OCR** from menu
2. Tap **Take Photo**
3. Photograph the filament label
   - Ensure good lighting
   - Label should be clear and readable
4. Tap the camera button to capture
5. OCR will analyze the image and suggest:
   - Brand
   - Material
   - Color

### Using OCR Results

After scanning, you can:
- **Use detected values** - Pre-fill Add Filament form
- **Edit manually** - Adjust if OCR was inaccurate
- **Scan again** - Take a new photo

**Tips for Better OCR:**
- Use good lighting
- Keep label flat and in focus
- Avoid glare and shadows
- Text should be horizontal

**Note:** OCR is experimental and may not always be accurate. Always verify the results!

---

## 💾 Export & Import

Backup and restore your data.

### Exporting Data

1. Go to **Settings**
2. Tap **Export Data**
3. File is saved to Downloads folder
4. Share the JSON file via any app

**What's Exported:**
- All filaments
- All history records
- Brands, materials, colors
- Printers
- Locations

### Importing Data

1. Go to **Settings**
2. Tap **Import Data**
3. Select the JSON file
4. Choose import mode:
   - **Replace All** - Delete existing data, restore from backup (recommended)
   - **Merge** - Keep existing data, add items from backup (advanced)
5. Confirm

**Important:**
- Always export before updating the app
- Keep backups in a safe place (Google Drive, etc.)
- Test imports on a fresh install first

---

## ❓ FAQ

### How do I update a filament's weight?

Use **Save Status** from the filament menu (⋮). Enter the current weight, and status will be automatically calculated.

### Can I track multiple spools of the same brand/material/color?

Yes! Each spool gets a unique ID. They are grouped together for easy viewing.

### What happens when a filament reaches 0g?

Status automatically becomes **Finished**. Finished filaments are hidden from most views but can be seen in Reports.

### Can I delete a brand/material/color?

Currently, definitions can only be added. Deleting would require ensuring no filaments use them.

### How do I move a filament from one printer to another?

1. **Change Slot** from the menu
2. Select the new printer
3. Select the new slot

### What if I delete a printer that has filaments?

The app will ask if you want to move those filaments to storage. They will be unassigned and moved to the default location.

### Can I use the app offline?

Yes! All data is stored locally on your device. No internet connection required.

### How do I change the app language?

The app follows your device's language settings. Supported languages: English, German, Turkish, French, Italian, Spanish.

---

## 💡 Tips & Tricks

### Tip 1: Use OCR for Quick Entry
When adding multiple filaments, use **Scan OCR** to speed up data entry.

### Tip 2: Regular Status Updates
Update filament weights regularly (e.g., after each print job) for accurate tracking.

### Tip 3: Color Coding
Use the actual filament color when adding colors in Definitions for visual clarity.

### Tip 4: Backup Regularly
Export your data monthly or after significant changes.

### Tip 5: Low Stock Planning
Check the Dashboard's **Low Stock Alert** to know when to reorder filaments.

### Tip 6: Printer Slot Labels
Consider labeling your physical printer slots (1, 2, 3, 4) to match the app.

### Tip 7: Photo Documentation
Use the photo feature in Save Status to visually track filament condition.

### Tip 8: Location Names
Use descriptive location names like "Dry Box A" or "Shelf 2 - Left" for easy identification.

### Tip 9: Status Filters
Use **On Printers** filter in Reports to quickly see what's currently loaded.

### Tip 10: Refresh Dashboard
Pull down on Dashboard to refresh if data seems outdated.

---

## 🆘 Need More Help?

- **GitHub Issues:** [Report bugs or request features](https://github.com/CeyhunKaratas/filament_manager/issues)
- **Contact:** durumade@gmail.com

---

**Version:** 0.4.2-beta  
**Last Updated:** January 2026

---

**Happy Printing!** 🎉🖨️