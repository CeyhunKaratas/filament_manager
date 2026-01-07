import 'dart:ui';
import '../core/models/filament.dart';

class AppStrings {
  final Locale locale;

  AppStrings(this.locale);

  static AppStrings of(Locale locale) {
    return AppStrings(locale);
  }

  static const supportedLocales = [
    Locale('en'),
    Locale('de'),
    Locale('tr'),
    Locale('fr'),
    Locale('it'),
    Locale('es'),
  ];

  String get addFilament {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament Ekle';
      default:
        return 'Add Filament';
    }
  }

  String get brand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Marka';
      default:
        return 'Brand';
    }
  }

  String get color {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renk';
      default:
        return 'Color';
    }
  }

  String get material {
    switch (locale.languageCode) {
      case 'tr':
        return 'Malzeme';
      default:
        return 'Material';
    }
  }

  String get save {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kaydet';
      default:
        return 'Save';
    }
  }

  String get required {
    switch (locale.languageCode) {
      case 'tr':
        return 'Zorunlu';
      default:
        return 'Required';
    }
  }

  String get addNew {
    switch (locale.languageCode) {
      case 'tr':
        return '+ Yeni ekle';
      default:
        return '+ Add new';
    }
  }

  String get filaments {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filamentler';
      default:
        return 'Filaments';
    }
  }

  String get noFilaments {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament yok';
      default:
        return 'No filaments';
    }
  }

  String get error {
    switch (locale.languageCode) {
      case 'tr':
        return 'Hata';
      default:
        return 'Error';
    }
  }

  String get newBrand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni marka';
      default:
        return 'New brand';
    }
  }

  String get newColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni renk';
      default:
        return 'New color';
    }
  }

  String get deleteSpoolTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara Sil';
      default:
        return 'Delete Spool';
    }
  }

  String get deleteSpoolConfirm {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara silmek istediğinize emin misiniz?';
      default:
        return 'Do you want delete the spool?';
    }
  }

  String get cancel {
    switch (locale.languageCode) {
      case 'tr':
        return 'İptal';
      default:
        return 'Cancel';
    }
  }

  String get delete {
    switch (locale.languageCode) {
      case 'tr':
        return 'Sil';
      default:
        return 'Delete';
    }
  }

  String get spool {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara';
      default:
        return 'Spool';
    }
  }

  String get statusActive {
    switch (locale.languageCode) {
      case 'tr':
        return 'Aktif';
      default:
        return 'Active';
    }
  }

  String get statusLow {
    switch (locale.languageCode) {
      case 'tr':
        return 'Az';
      default:
        return 'Low';
    }
  }

  String get statusFinished {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bitti';
      default:
        return 'Finished';
    }
  }

  String statusLabel(FilamentStatus status) {
    switch (status) {
      case FilamentStatus.active:
        return statusActive;
      case FilamentStatus.low:
        return statusLow;
      case FilamentStatus.finished:
        return statusFinished;
    }
    return '';
  }

  String get assignTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara → Printer Atama';
      default:
        return 'Spool → Printer Assignment';
    }
  }

  String get assignSpool {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara Ata';
      default:
        return 'Assign Spool';
    }
  }

  String get assign {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ata';
      default:
        return 'Assign';
    }
  }

  String get unassign {
    switch (locale.languageCode) {
      case 'tr':
        return 'Atamayı Kaldır';
      default:
        return 'Unassign';
    }
  }

  String get unassigned {
    switch (locale.languageCode) {
      case 'tr':
        return 'Atanmamış';
      default:
        return 'Unassigned';
    }
  }

  String get printer {
    switch (locale.languageCode) {
      case 'tr':
        return 'Printer';
      default:
        return 'Printer';
    }
  }

  String get slot {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot';
      default:
        return 'Slot';
    }
  }

  String get noPrinters {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yazıcı yok';
      default:
        return 'No printers';
    }
  }

  String get slotAlreadyUsed {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bu slot zaten dolu';
      default:
        return 'This slot is already in use';
    }
  }

  String get ok {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tamam';
      default:
        return 'OK';
    }
  }

  String get changeSlot {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot Değiştir';
      default:
        return 'Change Slot';
    }
  }

  String get slotOccupiedTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot dolu';
      default:
        return 'Slot occupied';
    }
  }

  String get slotOccupiedMessage {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bu slot dolu. Devam ederseniz eski filament bu slottan kaldırılacak.';
      default:
        return 'This slot is occupied. If you continue, the old filament will be removed from this slot.';
    }
  }

  String get continueLabel {
    switch (locale.languageCode) {
      case 'tr':
        return 'Devam';
      default:
        return 'Continue';
    }
  }

  String get empty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Boş';
      default:
        return 'Empty';
    }
  }

  String get location {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon';
      default:
        return 'Location';
    }
  }

  String get defaultLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Varsayılan';
      default:
        return 'Default';
    }
  }

  String get noLocations {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon yok';
      default:
        return 'No location';
    }
  }

  String get locations {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon';
      default:
        return 'Location';
    }
  }

  String get addLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon ekle';
      default:
        return 'Add location';
    }
  }

  String get locationName {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon adı';
      default:
        return 'Location name';
    }
  }

  String get add {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ekle';
      default:
        return 'Add';
    }
  }

  String get locationNotEmpty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon boş değil';
      default:
        return 'Location is not empty';
    }
  }

  String get selectLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon seç';
      default:
        return 'Select location';
    }
  }

  String get moveToLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyona taşı';
      default:
        return 'Move to location';
    }
  }

  String get customColors {
    switch (locale.languageCode) {
      case 'tr':
        return 'Özel renkler';
      default:
        return 'Custom colors';
    }
  }

  String get scanOcrTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Scan / OCR';
      default:
        return 'Scan / OCR';
    }
  }

  String get scanOcrTakePhoto {
    switch (locale.languageCode) {
      case 'tr':
        return 'Fotoğraf çek ve OCR çalıştır';
      default:
        return 'Take photo & run OCR';
    }
  }

  String get scanOcrRawTextTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ham OCR Metni';
      default:
        return 'Raw OCR Text';
    }
  }

  String get scanOcrRawTextEmpty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Henüz OCR sonucu yok.';
      default:
        return 'No OCR result yet.';
    }
  }

  String get scanOcrAnalysisTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Basit Anahtar Kelime Analizi';
      default:
        return 'Basic Keyword Analysis';
    }
  }

  String get scanOcrAnalysisEmpty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Eşleşen anahtar kelime bulunamadı.';
      default:
        return 'No keyword hits found.';
    }
  }

  String get scanOcrNote {
    switch (locale.languageCode) {
      case 'tr':
        return 'Not: Bu ekran sadece OCR testi içindir. DB’ye kayıt yapmaz, filament oluşturmaz.';
      default:
        return 'Note: This page is for OCR testing only. It does not write to DB or create filaments.';
    }
  }

  String get scanReadFromCamera {
    switch (locale.languageCode) {
      case 'tr':
        return 'Verileri kameradan oku';
      default:
        return 'Read from camera';
    }
  }

  String get scanCaptureInstruction {
    switch (locale.languageCode) {
      case 'tr':
        return 'İhtiyacınız olan fotoğrafları çekin.';
      default:
        return 'Take the photos you need.';
    }
  }

  String photosTaken(int count) {
    switch (locale.languageCode) {
      case 'tr':
        return '$count foto çekildi';
      default:
        return '$count photos taken';
    }
  }

  String get doneUpper {
    switch (locale.languageCode) {
      case 'tr':
        return 'TAMAM';
      default:
        return 'DONE';
    }
  }

  String get cameraInitFailed {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kamera başlatılamadı';
      default:
        return 'Camera could not be initialized';
    }
  }

  String get scanProcessing {
    switch (locale.languageCode) {
      case 'tr':
        return 'OCR çalıştırılıyor...';
      default:
        return 'Running OCR...';
    }
  }

  String get scanMergedOcrTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Birleşik OCR Metni';
      default:
        return 'Merged OCR Text';
    }
  }

  String get scanPerPhotoOcrTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Fotoğraf Bazlı OCR Sonuçları';
      default:
        return 'Per-photo OCR Results';
    }
  }

  String get scanStartNewSession {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni tarama başlat';
      default:
        return 'Start new scan';
    }
  }

  // =========================
  // DEFINITIONS / COMMON UI
  // =========================

  String get definitionsTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tanımlar';
      default:
        return 'Definitions';
    }
  }

  String get brandsTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markalar';
      default:
        return 'Brands';
    }
  }

  String get materialsTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipler';
      default:
        return 'Materials';
    }
  }

  String get colorsTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renkler';
      default:
        return 'Colors';
    }
  }

  String get nameLabel {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ad';
      default:
        return 'Name';
    }
  }

  String get editBrandTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markayı düzenle';
      default:
        return 'Edit brand';
    }
  }

  String get editMaterialTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipi düzenle';
      default:
        return 'Edit material';
    }
  }

  String get editColorTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Rengi düzenle';
      default:
        return 'Edit color';
    }
  }

  String get newMaterial {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni tip';
      default:
        return 'New material';
    }
  }

  String get pickColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renk seç';
      default:
        return 'Pick color';
    }
  }

  String get changeColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Rengi değiştir';
      default:
        return 'Change color';
    }
  }

  String get manageColorsSubtitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renk listesini yönet';
      default:
        return 'Manage color list';
    }
  }

  String get manageBrandsSubtitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Marka listesini yönet';
      default:
        return 'Manage brand list';
    }
  }

  String get manageMaterialsSubtitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tip listesini yönet';
      default:
        return 'Manage material list';
    }
  }

  String get definitions {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tanımlar';
      default:
        return 'Definitions';
    }
  }

  String get manageColors {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renkleri yönet';
      default:
        return 'Manage colors';
    }
  }

  String get manageBrands {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markaları yönet';
      default:
        return 'Manage brands';
    }
  }

  String get manageMaterials {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipleri yönet';
      default:
        return 'Manage materials';
    }
  }

  String get editColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Rengi düzenle';
      default:
        return 'Edit color';
    }
  }

  String get editBrand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markayı düzenle';
      default:
        return 'Edit brand';
    }
  }

  String get editMaterial {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipi düzenle';
      default:
        return 'Edit material';
    }
  }

  String get appTitle {
    switch (locale.languageCode) {
      //Don't translate, always only one return
      default:
        return 'Filament Manager';
    }
  }

  String get printers {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yazıcılar';
      default:
        return 'Printers';
    }
  }

  String get scanOcr {
    switch (locale.languageCode) {
      case 'tr':
        return 'OCR Test';
      default:
        return 'Scan OCR';
    }
  }

  String get addBrand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Marka ekle';
      default:
        return 'Add brand';
    }
  }

  String get addMaterial {
    switch (locale.languageCode) {
      case 'tr':
        return 'Materyal ekle';
      default:
        return 'Add material';
    }
  }

  String get filament {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament';
      default:
        return 'Filament';
    }
  }

  String get status {
    switch (locale.languageCode) {
      case 'tr':
        return 'Durum';
      default:
        return 'Status';
    }
  }

  String get spools {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara';
      default:
        return 'Spools';
    }
  }
}
