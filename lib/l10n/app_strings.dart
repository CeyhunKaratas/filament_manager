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
      case 'de':
        return 'Filament hinzufügen';
      case 'fr':
        return 'Add Filament';
      case 'it':
        return 'Add Filament';
      case 'es':
        return 'Add Filament';
      default:
        return 'Add Filament';
    }
  }

  String get brand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Marka';
      case 'de':
        return 'Marke';
      case 'fr':
        return 'Brand';
      case 'it':
        return 'Brand';
      case 'es':
        return 'Brand';
      default:
        return 'Brand';
    }
  }

  String get color {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renk';
      case 'de':
        return 'Farbe';
      case 'fr':
        return 'Color';
      case 'it':
        return 'Color';
      case 'es':
        return 'Color';
      default:
        return 'Color';
    }
  }

  String get material {
    switch (locale.languageCode) {
      case 'tr':
        return 'Malzeme';
      case 'de':
        return 'Material';
      case 'fr':
        return 'Material';
      case 'it':
        return 'Material';
      case 'es':
        return 'Material';
      default:
        return 'Material';
    }
  }

  String get save {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kaydet';
      case 'de':
        return 'Speichern';
      case 'fr':
        return 'Save';
      case 'it':
        return 'Save';
      case 'es':
        return 'Save';
      default:
        return 'Save';
    }
  }

  String get required {
    switch (locale.languageCode) {
      case 'tr':
        return 'Zorunlu';
      case 'de':
        return 'Erforderlich';
      case 'fr':
        return 'Required';
      case 'it':
        return 'Required';
      case 'es':
        return 'Required';
      default:
        return 'Required';
    }
  }

  String get addNew {
    switch (locale.languageCode) {
      case 'tr':
        return '+ Yeni ekle';
      case 'de':
        return '+ Neu hinzufügen';
      case 'fr':
        return '+ Add new';
      case 'it':
        return '+ Add new';
      case 'es':
        return '+ Add new';
      default:
        return '+ Add new';
    }
  }

  String get filaments {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filamentler';
      case 'de':
        return 'Filamente';
      case 'fr':
        return 'Filaments';
      case 'it':
        return 'Filaments';
      case 'es':
        return 'Filaments';
      default:
        return 'Filaments';
    }
  }

  String get noFilaments {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament yok';
      case 'de':
        return 'Keine Filamente';
      case 'fr':
        return 'No filaments';
      case 'it':
        return 'No filaments';
      case 'es':
        return 'No filaments';
      default:
        return 'No filaments';
    }
  }

  String get error {
    switch (locale.languageCode) {
      case 'tr':
        return 'Hata';
      case 'de':
        return 'Fehler';
      case 'fr':
        return 'Error';
      case 'it':
        return 'Error';
      case 'es':
        return 'Error';
      default:
        return 'Error';
    }
  }

  String get newBrand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni marka';
      case 'de':
        return 'Neue Marke';
      case 'fr':
        return 'New brand';
      case 'it':
        return 'New brand';
      case 'es':
        return 'New brand';
      default:
        return 'New brand';
    }
  }

  String get newColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni renk';
      case 'de':
        return 'Neue Farbe';
      case 'fr':
        return 'New color';
      case 'it':
        return 'New color';
      case 'es':
        return 'New color';
      default:
        return 'New color';
    }
  }

  String get deleteSpoolTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara Sil';
      case 'de':
        return 'Spule löschen';
      case 'fr':
        return 'Delete Spool';
      case 'it':
        return 'Delete Spool';
      case 'es':
        return 'Delete Spool';
      default:
        return 'Delete Spool';
    }
  }

  String get deleteSpoolConfirm {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara silmek istediğinize emin misiniz?';
      case 'de':
        return 'Möchten Sie die Spule wirklich löschen?';
      case 'fr':
        return 'Do you want delete the spool?';
      case 'it':
        return 'Do you want delete the spool?';
      case 'es':
        return 'Do you want delete the spool?';
      default:
        return 'Do you want delete the spool?';
    }
  }

  String get cancel {
    switch (locale.languageCode) {
      case 'tr':
        return 'İptal';
      case 'de':
        return 'Abbrechen';
      case 'fr':
        return 'Cancel';
      case 'it':
        return 'Cancel';
      case 'es':
        return 'Cancel';
      default:
        return 'Cancel';
    }
  }

  String get delete {
    switch (locale.languageCode) {
      case 'tr':
        return 'Sil';
      case 'de':
        return 'Löschen';
      case 'fr':
        return 'Delete';
      case 'it':
        return 'Delete';
      case 'es':
        return 'Delete';
      default:
        return 'Delete';
    }
  }

  String get spool {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara';
      case 'de':
        return 'Spule';
      case 'fr':
        return 'Spool';
      case 'it':
        return 'Spool';
      case 'es':
        return 'Spool';
      default:
        return 'Spool';
    }
  }

  String get statusActive {
    switch (locale.languageCode) {
      case 'tr':
        return 'Aktif';
      case 'de':
        return 'Aktiv';
      case 'fr':
        return 'Active';
      case 'it':
        return 'Active';
      case 'es':
        return 'Active';
      default:
        return 'Active';
    }
  }

  String get statusLow {
    switch (locale.languageCode) {
      case 'tr':
        return 'Az';
      case 'de':
        return 'Niedrig';
      case 'fr':
        return 'Low';
      case 'it':
        return 'Low';
      case 'es':
        return 'Low';
      default:
        return 'Low';
    }
  }

  String get statusFinished {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bitti';
      case 'de':
        return 'Aufgebraucht';
      case 'fr':
        return 'Finished';
      case 'it':
        return 'Finished';
      case 'es':
        return 'Finished';
      default:
        return 'Finished';
    }
  }

  String get statusUsed {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kullanılmış';
      case 'de':
        return 'Benutzt';
      case 'fr':
        return 'Utilisé';
      case 'it':
        return 'Usato';
      case 'es':
        return 'Usado';
      default:
        return 'Used';
    }
  }

  String statusLabel(FilamentStatus status) {
    switch (status) {
      case FilamentStatus.active:
        return statusActive;
      case FilamentStatus.used:
        return statusUsed;
      case FilamentStatus.low:
        return statusLow;
      case FilamentStatus.finished:
        return statusFinished;
    }
  }

  String get assignTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara → Printer Atama';
      case 'de':
        return 'Spool → Printer Assignment';
      case 'fr':
        return 'Spool → Printer Assignment';
      case 'it':
        return 'Spool → Printer Assignment';
      case 'es':
        return 'Spool → Printer Assignment';
      default:
        return 'Spool → Printer Assignment';
    }
  }

  String get assignSpool {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara Ata';
      case 'de':
        return 'Spule zuweisen';
      case 'fr':
        return 'Assign Spool';
      case 'it':
        return 'Assign Spool';
      case 'es':
        return 'Assign Spool';
      default:
        return 'Assign Spool';
    }
  }

  String get assign {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ata';
      case 'de':
        return 'Zuweisen';
      case 'fr':
        return 'Assign';
      case 'it':
        return 'Assign';
      case 'es':
        return 'Assign';
      default:
        return 'Assign';
    }
  }

  String get unassign {
    switch (locale.languageCode) {
      case 'tr':
        return 'Atamayı Kaldır';
      case 'de':
        return 'Zuweisung entfernen';
      case 'fr':
        return 'Unassign';
      case 'it':
        return 'Unassign';
      case 'es':
        return 'Unassign';
      default:
        return 'Unassign';
    }
  }

  String get unassigned {
    switch (locale.languageCode) {
      case 'tr':
        return 'Atanmamış';
      case 'de':
        return 'Nicht zugewiesen';
      case 'fr':
        return 'Unassigned';
      case 'it':
        return 'Unassigned';
      case 'es':
        return 'Unassigned';
      default:
        return 'Unassigned';
    }
  }

  String get printer {
    switch (locale.languageCode) {
      case 'tr':
        return 'Printer';
      case 'de':
        return 'Drucker';
      case 'fr':
        return 'Printer';
      case 'it':
        return 'Printer';
      case 'es':
        return 'Printer';
      default:
        return 'Printer';
    }
  }

  String get slot {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot';
      case 'de':
        return 'Slot';
      case 'fr':
        return 'Slot';
      case 'it':
        return 'Slot';
      case 'es':
        return 'Slot';
      default:
        return 'Slot';
    }
  }

  String get noPrinters {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yazıcı yok';
      case 'de':
        return 'Keine Drucker';
      case 'fr':
        return 'No printers';
      case 'it':
        return 'No printers';
      case 'es':
        return 'No printers';
      default:
        return 'No printers';
    }
  }

  String get slotAlreadyUsed {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bu slot zaten dolu';
      case 'de':
        return 'Dieser Slot ist bereits belegt';
      case 'fr':
        return 'This slot is already in use';
      case 'it':
        return 'This slot is already in use';
      case 'es':
        return 'This slot is already in use';
      default:
        return 'This slot is already in use';
    }
  }

  String get ok {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tamam';
      case 'de':
        return 'OK';
      case 'fr':
        return 'OK';
      case 'it':
        return 'OK';
      case 'es':
        return 'OK';
      default:
        return 'OK';
    }
  }

  String get changeSlot {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot Değiştir';
      case 'de':
        return 'Slot ändern';
      case 'fr':
        return 'Change Slot';
      case 'it':
        return 'Change Slot';
      case 'es':
        return 'Change Slot';
      default:
        return 'Change Slot';
    }
  }

  String get slotOccupiedTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot dolu';
      case 'de':
        return 'Slot belegt';
      case 'fr':
        return 'Slot occupied';
      case 'it':
        return 'Slot occupied';
      case 'es':
        return 'Slot occupied';
      default:
        return 'Slot occupied';
    }
  }

  String get slotOccupiedMessage {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bu slot dolu. Devam ederseniz eski filament bu slottan kaldırılacak.';
      case 'de':
        return 'Dieser Slot ist belegt. Wenn Sie fortfahren, wird das alte Filament entfernt.';
      case 'fr':
        return 'This slot is occupied. If you continue, the old filament will be removed from this slot.';
      case 'it':
        return 'This slot is occupied. If you continue, the old filament will be removed from this slot.';
      case 'es':
        return 'This slot is occupied. If you continue, the old filament will be removed from this slot.';
      default:
        return 'This slot is occupied. If you continue, the old filament will be removed from this slot.';
    }
  }

  String get continueLabel {
    switch (locale.languageCode) {
      case 'tr':
        return 'Devam';
      case 'de':
        return 'Fortfahren';
      case 'fr':
        return 'Continue';
      case 'it':
        return 'Continue';
      case 'es':
        return 'Continue';
      default:
        return 'Continue';
    }
  }

  String get empty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Boş';
      case 'de':
        return 'Leer';
      case 'fr':
        return 'Empty';
      case 'it':
        return 'Empty';
      case 'es':
        return 'Empty';
      default:
        return 'Empty';
    }
  }

  String get location {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon';
      case 'de':
        return 'Standort';
      case 'fr':
        return 'Location';
      case 'it':
        return 'Location';
      case 'es':
        return 'Location';
      default:
        return 'Location';
    }
  }

  String get defaultLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Varsayılan';
      case 'de':
        return 'Standard';
      case 'fr':
        return 'Default';
      case 'it':
        return 'Default';
      case 'es':
        return 'Default';
      default:
        return 'Default';
    }
  }

  String get noLocations {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon yok';
      case 'de':
        return 'Keine Standorte';
      case 'fr':
        return 'No location';
      case 'it':
        return 'No location';
      case 'es':
        return 'No location';
      default:
        return 'No location';
    }
  }

  String get locations {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon';
      case 'de':
        return 'Standort';
      case 'fr':
        return 'Location';
      case 'it':
        return 'Location';
      case 'es':
        return 'Location';
      default:
        return 'Location';
    }
  }

  String get addLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon ekle';
      case 'de':
        return 'Standort hinzufügen';
      case 'fr':
        return 'Add location';
      case 'it':
        return 'Add location';
      case 'es':
        return 'Add location';
      default:
        return 'Add location';
    }
  }

  String get locationName {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon adı';
      case 'de':
        return 'Standortname';
      case 'fr':
        return 'Location name';
      case 'it':
        return 'Location name';
      case 'es':
        return 'Location name';
      default:
        return 'Location name';
    }
  }

  String get add {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ekle';
      case 'de':
        return 'Hinzufügen';
      case 'fr':
        return 'Add';
      case 'it':
        return 'Add';
      case 'es':
        return 'Add';
      default:
        return 'Add';
    }
  }

  String get locationNotEmpty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon boş değil';
      case 'de':
        return 'Standort ist nicht leer';
      case 'fr':
        return 'Location is not empty';
      case 'it':
        return 'Location is not empty';
      case 'es':
        return 'Location is not empty';
      default:
        return 'Location is not empty';
    }
  }

  String get selectLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyon seç';
      case 'de':
        return 'Standort auswählen';
      case 'fr':
        return 'Select location';
      case 'it':
        return 'Select location';
      case 'es':
        return 'Select location';
      default:
        return 'Select location';
    }
  }

  String get moveToLocation {
    switch (locale.languageCode) {
      case 'tr':
        return 'Lokasyona taşı';
      case 'de':
        return 'Zu Standort verschieben';
      case 'fr':
        return 'Move to location';
      case 'it':
        return 'Move to location';
      case 'es':
        return 'Move to location';
      default:
        return 'Move to location';
    }
  }

  String get customColors {
    switch (locale.languageCode) {
      case 'tr':
        return 'Özel renkler';
      case 'de':
        return 'Benutzerdefinierte Farben';
      case 'fr':
        return 'Custom colors';
      case 'it':
        return 'Custom colors';
      case 'es':
        return 'Custom colors';
      default:
        return 'Custom colors';
    }
  }

  String get scanOcrTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Scan / OCR';
      case 'de':
        return 'Scan / OCR';
      case 'fr':
        return 'Scan / OCR';
      case 'it':
        return 'Scan / OCR';
      case 'es':
        return 'Scan / OCR';
      default:
        return 'Scan / OCR';
    }
  }

  String get scanOcrTakePhoto {
    switch (locale.languageCode) {
      case 'tr':
        return 'Fotoğraf çek ve OCR çalıştır';
      case 'de':
        return 'Foto aufnehmen und OCR starten';
      case 'fr':
        return 'Take photo & run OCR';
      case 'it':
        return 'Take photo & run OCR';
      case 'es':
        return 'Take photo & run OCR';
      default:
        return 'Take photo & run OCR';
    }
  }

  String get scanOcrRawTextTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ham OCR Metni';
      case 'de':
        return 'Roh-OCR-Text';
      case 'fr':
        return 'Raw OCR Text';
      case 'it':
        return 'Raw OCR Text';
      case 'es':
        return 'Raw OCR Text';
      default:
        return 'Raw OCR Text';
    }
  }

  String get scanOcrRawTextEmpty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Henüz OCR sonucu yok.';
      case 'de':
        return 'Noch kein OCR-Ergebnis.';
      case 'fr':
        return 'No OCR result yet.';
      case 'it':
        return 'No OCR result yet.';
      case 'es':
        return 'No OCR result yet.';
      default:
        return 'No OCR result yet.';
    }
  }

  String get scanOcrAnalysisTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Basit Anahtar Kelime Analizi';
      case 'de':
        return 'Einfache Schlüsselwortanalyse';
      case 'fr':
        return 'Basic Keyword Analysis';
      case 'it':
        return 'Basic Keyword Analysis';
      case 'es':
        return 'Basic Keyword Analysis';
      default:
        return 'Basic Keyword Analysis';
    }
  }

  String get scanOcrAnalysisEmpty {
    switch (locale.languageCode) {
      case 'tr':
        return 'Eşleşen anahtar kelime bulunamadı.';
      case 'de':
        return 'Keine passenden Schlüsselwörter gefunden.';
      case 'fr':
        return 'No keyword hits found.';
      case 'it':
        return 'No keyword hits found.';
      case 'es':
        return 'No keyword hits found.';
      default:
        return 'No keyword hits found.';
    }
  }

  String get scanOcrNote {
    switch (locale.languageCode) {
      case 'tr':
        return 'Not: Bu ekran sadece OCR testi içindir. DB’ye kayıt yapmaz, filament oluşturmaz.';
      case 'de':
        return 'Note: This page is for OCR testing only. It does not write to DB or create filaments.';
      case 'fr':
        return 'Note: This page is for OCR testing only. It does not write to DB or create filaments.';
      case 'it':
        return 'Note: This page is for OCR testing only. It does not write to DB or create filaments.';
      case 'es':
        return 'Note: This page is for OCR testing only. It does not write to DB or create filaments.';
      default:
        return 'Note: This page is for OCR testing only. It does not write to DB or create filaments.';
    }
  }

  String get scanReadFromCamera {
    switch (locale.languageCode) {
      case 'tr':
        return 'Verileri kameradan oku';
      case 'de':
        return 'Daten aus der Kamera lesen';
      case 'fr':
        return 'Read from camera';
      case 'it':
        return 'Read from camera';
      case 'es':
        return 'Read from camera';
      default:
        return 'Read from camera';
    }
  }

  String get scanCaptureInstruction {
    switch (locale.languageCode) {
      case 'tr':
        return 'İhtiyacınız olan fotoğrafları çekin.';
      case 'de':
        return 'Machen Sie die benötigten Fotos.';
      case 'fr':
        return 'Take the photos you need.';
      case 'it':
        return 'Take the photos you need.';
      case 'es':
        return 'Take the photos you need.';
      default:
        return 'Take the photos you need.';
    }
  }

  String photosTaken(int count) {
    switch (locale.languageCode) {
      case 'tr':
        return '$count foto çekildi';
      case 'de':
        return '$count photos taken';
      case 'fr':
        return '$count photos taken';
      case 'it':
        return '$count photos taken';
      case 'es':
        return '$count photos taken';
      default:
        return '$count photos taken';
    }
  }

  String get doneUpper {
    switch (locale.languageCode) {
      case 'tr':
        return 'TAMAM';
      case 'de':
        return 'FERTIG';
      case 'fr':
        return 'DONE';
      case 'it':
        return 'DONE';
      case 'es':
        return 'DONE';
      default:
        return 'DONE';
    }
  }

  String get cameraInitFailed {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kamera başlatılamadı';
      case 'de':
        return 'Kamera konnte nicht gestartet werden';
      case 'fr':
        return 'Camera could not be initialized';
      case 'it':
        return 'Camera could not be initialized';
      case 'es':
        return 'Camera could not be initialized';
      default:
        return 'Camera could not be initialized';
    }
  }

  String get scanProcessing {
    switch (locale.languageCode) {
      case 'tr':
        return 'OCR çalıştırılıyor...';
      case 'de':
        return 'OCR wird ausgeführt...';
      case 'fr':
        return 'Running OCR...';
      case 'it':
        return 'Running OCR...';
      case 'es':
        return 'Running OCR...';
      default:
        return 'Running OCR...';
    }
  }

  String get scanMergedOcrTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Birleşik OCR Metni';
      case 'de':
        return 'Zusammengeführter OCR-Text';
      case 'fr':
        return 'Merged OCR Text';
      case 'it':
        return 'Merged OCR Text';
      case 'es':
        return 'Merged OCR Text';
      default:
        return 'Merged OCR Text';
    }
  }

  String get scanPerPhotoOcrTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Fotoğraf Bazlı OCR Sonuçları';
      case 'de':
        return 'OCR-Ergebnisse pro Foto';
      case 'fr':
        return 'Per-photo OCR Results';
      case 'it':
        return 'Per-photo OCR Results';
      case 'es':
        return 'Per-photo OCR Results';
      default:
        return 'Per-photo OCR Results';
    }
  }

  String get scanStartNewSession {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni tarama başlat';
      case 'de':
        return 'Neuen Scan starten';
      case 'fr':
        return 'Start new scan';
      case 'it':
        return 'Start new scan';
      case 'es':
        return 'Start new scan';
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
      case 'de':
        return 'Definitionen';
      case 'fr':
        return 'Definitions';
      case 'it':
        return 'Definitions';
      case 'es':
        return 'Definitions';
      default:
        return 'Definitions';
    }
  }

  String get brandsTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markalar';
      case 'de':
        return 'Marken';
      case 'fr':
        return 'Brands';
      case 'it':
        return 'Brands';
      case 'es':
        return 'Brands';
      default:
        return 'Brands';
    }
  }

  String get materialsTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipler';
      case 'de':
        return 'Materialien';
      case 'fr':
        return 'Materials';
      case 'it':
        return 'Materials';
      case 'es':
        return 'Materials';
      default:
        return 'Materials';
    }
  }

  String get colorsTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renkler';
      case 'de':
        return 'Farben';
      case 'fr':
        return 'Colors';
      case 'it':
        return 'Colors';
      case 'es':
        return 'Colors';
      default:
        return 'Colors';
    }
  }

  String get nameLabel {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ad';
      case 'de':
        return 'Name';
      case 'fr':
        return 'Name';
      case 'it':
        return 'Name';
      case 'es':
        return 'Name';
      default:
        return 'Name';
    }
  }

  String get editBrandTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markayı düzenle';
      case 'de':
        return 'Marke bearbeiten';
      case 'fr':
        return 'Edit brand';
      case 'it':
        return 'Edit brand';
      case 'es':
        return 'Edit brand';
      default:
        return 'Edit brand';
    }
  }

  String get editMaterialTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipi düzenle';
      case 'de':
        return 'Material bearbeiten';
      case 'fr':
        return 'Edit material';
      case 'it':
        return 'Edit material';
      case 'es':
        return 'Edit material';
      default:
        return 'Edit material';
    }
  }

  String get editColorTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Rengi düzenle';
      case 'de':
        return 'Farbe bearbeiten';
      case 'fr':
        return 'Edit color';
      case 'it':
        return 'Edit color';
      case 'es':
        return 'Edit color';
      default:
        return 'Edit color';
    }
  }

  String get newMaterial {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeni tip';
      case 'de':
        return 'Neues Material';
      case 'fr':
        return 'New material';
      case 'it':
        return 'New material';
      case 'es':
        return 'New material';
      default:
        return 'New material';
    }
  }

  String get pickColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renk seç';
      case 'de':
        return 'Farbe wählen';
      case 'fr':
        return 'Pick color';
      case 'it':
        return 'Pick color';
      case 'es':
        return 'Pick color';
      default:
        return 'Pick color';
    }
  }

  String get changeColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Rengi değiştir';
      case 'de':
        return 'Farbe ändern';
      case 'fr':
        return 'Change color';
      case 'it':
        return 'Change color';
      case 'es':
        return 'Change color';
      default:
        return 'Change color';
    }
  }

  String get manageColorsSubtitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renk listesini yönet';
      case 'de':
        return 'Farbliste verwalten';
      case 'fr':
        return 'Manage color list';
      case 'it':
        return 'Manage color list';
      case 'es':
        return 'Manage color list';
      default:
        return 'Manage color list';
    }
  }

  String get manageBrandsSubtitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Marka listesini yönet';
      case 'de':
        return 'Markenliste verwalten';
      case 'fr':
        return 'Manage brand list';
      case 'it':
        return 'Manage brand list';
      case 'es':
        return 'Manage brand list';
      default:
        return 'Manage brand list';
    }
  }

  String get manageMaterialsSubtitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tip listesini yönet';
      case 'de':
        return 'Materialliste verwalten';
      case 'fr':
        return 'Manage material list';
      case 'it':
        return 'Manage material list';
      case 'es':
        return 'Manage material list';
      default:
        return 'Manage material list';
    }
  }

  String get definitions {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tanımlar';
      case 'de':
        return 'Definitionen';
      case 'fr':
        return 'Definitions';
      case 'it':
        return 'Definitions';
      case 'es':
        return 'Definitions';
      default:
        return 'Definitions';
    }
  }

  String get manageColors {
    switch (locale.languageCode) {
      case 'tr':
        return 'Renkleri yönet';
      case 'de':
        return 'Farben verwalten';
      case 'fr':
        return 'Manage colors';
      case 'it':
        return 'Manage colors';
      case 'es':
        return 'Manage colors';
      default:
        return 'Manage colors';
    }
  }

  String get manageBrands {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markaları yönet';
      case 'de':
        return 'Marken verwalten';
      case 'fr':
        return 'Manage brands';
      case 'it':
        return 'Manage brands';
      case 'es':
        return 'Manage brands';
      default:
        return 'Manage brands';
    }
  }

  String get manageMaterials {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipleri yönet';
      case 'de':
        return 'Materialien verwalten';
      case 'fr':
        return 'Manage materials';
      case 'it':
        return 'Manage materials';
      case 'es':
        return 'Manage materials';
      default:
        return 'Manage materials';
    }
  }

  String get editColor {
    switch (locale.languageCode) {
      case 'tr':
        return 'Rengi düzenle';
      case 'de':
        return 'Farbe bearbeiten';
      case 'fr':
        return 'Edit color';
      case 'it':
        return 'Edit color';
      case 'es':
        return 'Edit color';
      default:
        return 'Edit color';
    }
  }

  String get editBrand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Markayı düzenle';
      case 'de':
        return 'Marke bearbeiten';
      case 'fr':
        return 'Edit brand';
      case 'it':
        return 'Edit brand';
      case 'es':
        return 'Edit brand';
      default:
        return 'Edit brand';
    }
  }

  String get editMaterial {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tipi düzenle';
      case 'de':
        return 'Material bearbeiten';
      case 'fr':
        return 'Edit material';
      case 'it':
        return 'Edit material';
      case 'es':
        return 'Edit material';
      default:
        return 'Edit material';
    }
  }

  String get appTitle {
    switch (locale.languageCode) {
      //Don't translate, always only one return
      case 'de':
        return '3D Farm Manager';
      case 'fr':
        return '3D Farm Manager';
      case 'it':
        return '3D Farm Manager';
      case 'es':
        return '3D Farm Manager';
      default:
        return '3D Farm Manager';
    }
  }

  String get printers {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yazıcılar';
      case 'de':
        return 'Drucker';
      case 'fr':
        return 'Printers';
      case 'it':
        return 'Printers';
      case 'es':
        return 'Printers';
      default:
        return 'Printers';
    }
  }

  String get scanOcr {
    switch (locale.languageCode) {
      case 'tr':
        return 'OCR Test';
      case 'de':
        return 'OCR scannen';
      case 'fr':
        return 'Scan OCR';
      case 'it':
        return 'Scan OCR';
      case 'es':
        return 'Scan OCR';
      default:
        return 'Scan OCR';
    }
  }

  String get addBrand {
    switch (locale.languageCode) {
      case 'tr':
        return 'Marka ekle';
      case 'de':
        return 'Marke hinzufügen';
      case 'fr':
        return 'Add brand';
      case 'it':
        return 'Add brand';
      case 'es':
        return 'Add brand';
      default:
        return 'Add brand';
    }
  }

  String get addMaterial {
    switch (locale.languageCode) {
      case 'tr':
        return 'Materyal ekle';
      case 'de':
        return 'Material hinzufügen';
      case 'fr':
        return 'Add material';
      case 'it':
        return 'Add material';
      case 'es':
        return 'Add material';
      default:
        return 'Add material';
    }
  }

  String get filament {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament';
      case 'de':
        return 'Filament';
      case 'fr':
        return 'Filament';
      case 'it':
        return 'Filament';
      case 'es':
        return 'Filament';
      default:
        return 'Filament';
    }
  }

  String get status {
    switch (locale.languageCode) {
      case 'tr':
        return 'Durum';
      case 'de':
        return 'Status';
      case 'fr':
        return 'Status';
      case 'it':
        return 'Status';
      case 'es':
        return 'Status';
      default:
        return 'Status';
    }
  }

  String get spools {
    switch (locale.languageCode) {
      case 'tr':
        return 'Makara';
      case 'de':
        return 'Spulen';
      case 'fr':
        return 'Spools';
      case 'it':
        return 'Spools';
      case 'es':
        return 'Spools';
      default:
        return 'Spools';
    }
  }

  // Mevcut dosyanın SONUNA ekleyin (spools getter'ından sonra):

  String get settings {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ayarlar';
      case 'de':
        return 'Einstellungen';
      case 'fr':
        return 'Settings';
      case 'it':
        return 'Settings';
      case 'es':
        return 'Settings';
      default:
        return 'Settings';
    }
  }

  String get exportData {
    switch (locale.languageCode) {
      case 'tr':
        return 'Verileri Dışa Aktar';
      case 'de':
        return 'Daten exportieren';
      case 'fr':
        return 'Export Data';
      case 'it':
        return 'Export Data';
      case 'es':
        return 'Export Data';
      default:
        return 'Export Data';
    }
  }

  String get importData {
    switch (locale.languageCode) {
      case 'tr':
        return 'Verileri İçe Aktar';
      case 'de':
        return 'Daten importieren';
      case 'fr':
        return 'Import Data';
      case 'it':
        return 'Import Data';
      case 'es':
        return 'Import Data';
      default:
        return 'Import Data';
    }
  }

  String get exportSuccess {
    switch (locale.languageCode) {
      case 'tr':
        return 'Veriler başarıyla dışa aktarıldı';
      case 'de':
        return 'Daten erfolgreich exportiert';
      case 'fr':
        return 'Data exported successfully';
      case 'it':
        return 'Data exported successfully';
      case 'es':
        return 'Data exported successfully';
      default:
        return 'Data exported successfully';
    }
  }

  String get exportFailed {
    switch (locale.languageCode) {
      case 'tr':
        return 'Dışa aktarma başarısız';
      case 'de':
        return 'Export fehlgeschlagen';
      case 'fr':
        return 'Export failed';
      case 'it':
        return 'Export failed';
      case 'es':
        return 'Export failed';
      default:
        return 'Export failed';
    }
  }

  String get importSuccess {
    switch (locale.languageCode) {
      case 'tr':
        return 'Veriler başarıyla içe aktarıldı';
      case 'de':
        return 'Daten erfolgreich importiert';
      case 'fr':
        return 'Data imported successfully';
      case 'it':
        return 'Data imported successfully';
      case 'es':
        return 'Data imported successfully';
      default:
        return 'Data imported successfully';
    }
  }

  String get importFailed {
    switch (locale.languageCode) {
      case 'tr':
        return 'İçe aktarma başarısız';
      case 'de':
        return 'Import fehlgeschlagen';
      case 'fr':
        return 'Import failed';
      case 'it':
        return 'Import failed';
      case 'es':
        return 'Import failed';
      default:
        return 'Import failed';
    }
  }

  String get replaceAll {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tümünü Değiştir';
      case 'de':
        return 'Alle ersetzen';
      case 'fr':
        return 'Replace All';
      case 'it':
        return 'Replace All';
      case 'es':
        return 'Replace All';
      default:
        return 'Replace All';
    }
  }

  String get replaceAllWarning {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bu işlem mevcut tüm verileri silip dosyadan yükleyecek. Devam edilsin mi?';
      case 'de':
        return 'This will delete all existing data and import from file. Continue?';
      case 'fr':
        return 'This will delete all existing data and import from file. Continue?';
      case 'it':
        return 'This will delete all existing data and import from file. Continue?';
      case 'es':
        return 'This will delete all existing data and import from file. Continue?';
      default:
        return 'This will delete all existing data and import from file. Continue?';
    }
  }

  String get merge {
    switch (locale.languageCode) {
      case 'tr':
        return 'Birleştir';
      case 'de':
        return 'Zusammenführen';
      case 'fr':
        return 'Merge';
      case 'it':
        return 'Merge';
      case 'es':
        return 'Merge';
      default:
        return 'Merge';
    }
  }

  String get mergeInfo {
    switch (locale.languageCode) {
      case 'tr':
        return 'Mevcut verileri koru, dosyadan yenilerini ekle';
      case 'de':
        return 'Keep existing data and add new items from file';
      case 'fr':
        return 'Keep existing data and add new items from file';
      case 'it':
        return 'Keep existing data and add new items from file';
      case 'es':
        return 'Keep existing data and add new items from file';
      default:
        return 'Keep existing data and add new items from file';
    }
  }

  String get selectImportMode {
    switch (locale.languageCode) {
      case 'tr':
        return 'İçe Aktarma Modunu Seç';
      case 'de':
        return 'Importmodus auswählen';
      case 'fr':
        return 'Select Import Mode';
      case 'it':
        return 'Select Import Mode';
      case 'es':
        return 'Select Import Mode';
      default:
        return 'Select Import Mode';
    }
  }

  String get fileNotSelected {
    switch (locale.languageCode) {
      case 'tr':
        return 'Dosya seçilmedi';
      case 'de':
        return 'No file selected';
      case 'fr':
        return 'No file selected';
      case 'it':
        return 'No file selected';
      case 'es':
        return 'No file selected';
      default:
        return 'No file selected';
    }
  }

  String get invalidFileFormat {
    switch (locale.languageCode) {
      case 'tr':
        return 'Geçersiz dosya formatı';
      case 'de':
        return 'Ungültiges Dateiformat';
      case 'fr':
        return 'Invalid file format';
      case 'it':
        return 'Invalid file format';
      case 'es':
        return 'Invalid file format';
      default:
        return 'Invalid file format';
    }
  }

  // Onboarding
  String get onboardingWelcomeTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament Manager\'a Hoş Geldiniz';
      case 'de':
        return 'Willkommen bei Filament Manager';
      case 'fr':
        return 'Welcome to Filament Manager';
      case 'it':
        return 'Welcome to Filament Manager';
      case 'es':
        return 'Welcome to Filament Manager';
      default:
        return 'Welcome to Filament Manager';
    }
  }

  String get onboardingWelcomeDesc {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament stokunuzu kolayca takip edin, yazıcılara atayın ve organize edin.';
      case 'de':
        return 'Easily track your filament stock, assign to printers, and stay organized.';
      case 'fr':
        return 'Easily track your filament stock, assign to printers, and stay organized.';
      case 'it':
        return 'Easily track your filament stock, assign to printers, and stay organized.';
      case 'es':
        return 'Easily track your filament stock, assign to printers, and stay organized.';
      default:
        return 'Easily track your filament stock, assign to printers, and stay organized.';
    }
  }

  String get onboardingAddTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filamentlerinizi Ekleyin';
      case 'de':
        return 'Add Your Filaments';
      case 'fr':
        return 'Add Your Filaments';
      case 'it':
        return 'Add Your Filaments';
      case 'es':
        return 'Add Your Filaments';
      default:
        return 'Add Your Filaments';
    }
  }

  String get onboardingAddDesc {
    switch (locale.languageCode) {
      case 'tr':
        return 'Marka, malzeme ve renk bilgileriyle filamentlerinizi kaydedin. Durum takibi yapın.';
      case 'de':
        return 'Save your filaments with brand, material and color info. Track their status.';
      case 'fr':
        return 'Save your filaments with brand, material and color info. Track their status.';
      case 'it':
        return 'Save your filaments with brand, material and color info. Track their status.';
      case 'es':
        return 'Save your filaments with brand, material and color info. Track their status.';
      default:
        return 'Save your filaments with brand, material and color info. Track their status.';
    }
  }

  String get onboardingPrinterTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yazıcılara Atayın';
      case 'de':
        return 'Assign to Printers';
      case 'fr':
        return 'Assign to Printers';
      case 'it':
        return 'Assign to Printers';
      case 'es':
        return 'Assign to Printers';
      default:
        return 'Assign to Printers';
    }
  }

  String get onboardingPrinterDesc {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filamentleri yazıcı slotlarına atayın. Hangi filament hangi yazıcıda hızlıca görün.';
      case 'de':
        return 'Assign filaments to printer slots. Quickly see which filament is in which printer.';
      case 'fr':
        return 'Assign filaments to printer slots. Quickly see which filament is in which printer.';
      case 'it':
        return 'Assign filaments to printer slots. Quickly see which filament is in which printer.';
      case 'es':
        return 'Assign filaments to printer slots. Quickly see which filament is in which printer.';
      default:
        return 'Assign filaments to printer slots. Quickly see which filament is in which printer.';
    }
  }

  String get onboardingOcrTitle {
    switch (locale.languageCode) {
      case 'tr':
        return 'OCR ile Etiket Tarayın';
      case 'de':
        return 'Scan Labels with OCR';
      case 'fr':
        return 'Scan Labels with OCR';
      case 'it':
        return 'Scan Labels with OCR';
      case 'es':
        return 'Scan Labels with OCR';
      default:
        return 'Scan Labels with OCR';
    }
  }

  String get onboardingOcrDesc {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kamerayı kullanarak etiketleri tarayın. Marka, renk ve malzeme bilgileri otomatik doldurulur.';
      case 'de':
        return 'Use the camera to scan labels. Brand, color and material info are auto-filled.';
      case 'fr':
        return 'Use the camera to scan labels. Brand, color and material info are auto-filled.';
      case 'it':
        return 'Use the camera to scan labels. Brand, color and material info are auto-filled.';
      case 'es':
        return 'Use the camera to scan labels. Brand, color and material info are auto-filled.';
      default:
        return 'Use the camera to scan labels. Brand, color and material info are auto-filled.';
    }
  }

  String get skip {
    switch (locale.languageCode) {
      case 'tr':
        return 'Atla';
      case 'de':
        return 'Überspringen';
      case 'fr':
        return 'Skip';
      case 'it':
        return 'Skip';
      case 'es':
        return 'Skip';
      default:
        return 'Skip';
    }
  }

  String get next {
    switch (locale.languageCode) {
      case 'tr':
        return 'İleri';
      case 'de':
        return 'Weiter';
      case 'fr':
        return 'Next';
      case 'it':
        return 'Next';
      case 'es':
        return 'Next';
      default:
        return 'Next';
    }
  }

  String get getStarted {
    switch (locale.languageCode) {
      case 'tr':
        return 'Başlayalım';
      case 'de':
        return 'Los geht’s';
      case 'fr':
        return 'Get Started';
      case 'it':
        return 'Get Started';
      case 'es':
        return 'Get Started';
      default:
        return 'Get Started';
    }
  }

  String get reports {
    switch (locale.languageCode) {
      case 'tr':
        return 'Raporlar';
      case 'de':
        return 'Berichte';
      case 'fr':
        return 'Reports';
      case 'it':
        return 'Reports';
      case 'es':
        return 'Reports';
      default:
        return 'Reports';
    }
  }

  String get inventoryReport {
    switch (locale.languageCode) {
      case 'tr':
        return 'Envanter Raporu';
      case 'de':
        return 'Bestandsbericht';
      case 'fr':
        return 'Inventory Report';
      case 'it':
        return 'Inventory Report';
      case 'es':
        return 'Inventory Report';
      default:
        return 'Inventory Report';
    }
  }

  String get filterBy {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filtrele';
      case 'de':
        return 'Filtern nach';
      case 'fr':
        return 'Filter By';
      case 'it':
        return 'Filter By';
      case 'es':
        return 'Filter By';
      default:
        return 'Filter By';
    }
  }

  String get sortBy {
    switch (locale.languageCode) {
      case 'tr':
        return 'Sırala';
      case 'de':
        return 'Sortieren nach';
      case 'fr':
        return 'Sort By';
      case 'it':
        return 'Sort By';
      case 'es':
        return 'Sort By';
      default:
        return 'Sort By';
    }
  }

  String get showFinished {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bitenleri Göster';
      case 'de':
        return 'Fertige anzeigen';
      case 'fr':
        return 'Show Finished';
      case 'it':
        return 'Show Finished';
      case 'es':
        return 'Show Finished';
      default:
        return 'Show Finished';
    }
  }

  String get allStatuses {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tüm Durumlar';
      case 'de':
        return 'Alle Status';
      case 'fr':
        return 'All Statuses';
      case 'it':
        return 'All Statuses';
      case 'es':
        return 'All Statuses';
      default:
        return 'All Statuses';
    }
  }

  String get allBrands {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tüm Markalar';
      case 'de':
        return 'Alle Marken';
      case 'fr':
        return 'All Brands';
      case 'it':
        return 'All Brands';
      case 'es':
        return 'All Brands';
      default:
        return 'All Brands';
    }
  }

  String get allMaterials {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tüm Tipler';
      case 'de':
        return 'Alle Materialien';
      case 'fr':
        return 'All Materials';
      case 'it':
        return 'All Materials';
      case 'es':
        return 'All Materials';
      default:
        return 'All Materials';
    }
  }

  String get totalSpools {
    switch (locale.languageCode) {
      case 'tr':
        return 'Toplam Makara';
      case 'de':
        return 'Gesamtspulen';
      case 'fr':
        return 'Total Spools';
      case 'it':
        return 'Total Spools';
      case 'es':
        return 'Total Spools';
      default:
        return 'Total Spools';
    }
  }

  String get edit {
    switch (locale.languageCode) {
      case 'tr':
        return 'Düzenle';
      case 'de':
        return 'Bearbeiten';
      case 'fr':
        return 'Modifier';
      case 'it':
        return 'Modifica';
      case 'es':
        return 'Editar';
      default:
        return 'Edit';
    }
  }

  String get editSpool {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bobini Düzenle';
      case 'de':
        return 'Spule bearbeiten';
      case 'fr':
        return 'Modifier la bobine';
      case 'it':
        return 'Modifica bobina';
      case 'es':
        return 'Editar bobina';
      default:
        return 'Edit Spool';
    }
  }

  // Add these to your app_strings.dart file:

  String get fileSavedTo {
    switch (locale.languageCode) {
      case 'tr':
        return 'Dosya kaydedildi';
      case 'de':
        return 'Datei gespeichert unter';
      case 'fr':
        return 'Fichier enregistré dans';
      case 'it':
        return 'File salvato in';
      case 'es':
        return 'Archivo guardado en';
      default:
        return 'File saved to';
    }
  }

  String get exportedData {
    switch (locale.languageCode) {
      case 'tr':
        return 'Dışa aktarılan veri';
      case 'de':
        return 'Exportierte Daten';
      case 'fr':
        return 'Données exportées';
      case 'it':
        return 'Dati esportati';
      case 'es':
        return 'Datos exportados';
      default:
        return 'Exported data';
    }
  }

  String get importedData {
    switch (locale.languageCode) {
      case 'tr':
        return 'İçe aktarılan veri';
      case 'de':
        return 'Importierte Daten';
      case 'fr':
        return 'Données importées';
      case 'it':
        return 'Dati importati';
      case 'es':
        return 'Datos importados';
      default:
        return 'Imported data';
    }
  }

  String get backupAllData {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tüm verileri yedekle';
      case 'de':
        return 'Alle Daten sichern';
      case 'fr':
        return 'Sauvegarder toutes les données';
      case 'it':
        return 'Esegui backup di tutti i dati';
      case 'es':
        return 'Respaldar todos los datos';
      default:
        return 'Backup all data to JSON file';
    }
  }

  String get restoreFromBackup {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yedekten geri yükle';
      case 'de':
        return 'Aus Sicherung wiederherstellen';
      case 'fr':
        return 'Restaurer depuis la sauvegarde';
      case 'it':
        return 'Ripristina da backup';
      case 'es':
        return 'Restaurar desde respaldo';
      default:
        return 'Restore data from backup file';
    }
  }

  String get dataManagement {
    switch (locale.languageCode) {
      case 'tr':
        return 'Veri Yönetimi';
      case 'de':
        return 'Datenverwaltung';
      case 'fr':
        return 'Gestion des données';
      case 'it':
        return 'Gestione dati';
      case 'es':
        return 'Gestión de datos';
      default:
        return 'Data Management';
    }
  }

  String get allDataReplaced {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tüm veriler değiştirildi';
      case 'de':
        return 'Alle Daten wurden ersetzt';
      case 'fr':
        return 'Toutes les données ont été remplacées';
      case 'it':
        return 'Tutti i dati sono stati sostituiti';
      case 'es':
        return 'Todos los datos fueron reemplazados';
      default:
        return 'All existing data has been replaced';
    }
  }

  String get dataMerged {
    switch (locale.languageCode) {
      case 'tr':
        return 'Veriler birleştirildi';
      case 'de':
        return 'Daten wurden zusammengeführt';
      case 'fr':
        return 'Les données ont été fusionnées';
      case 'it':
        return 'I dati sono stati uniti';
      case 'es':
        return 'Los datos se fusionaron';
      default:
        return 'Data has been merged with existing data';
    }
  }

  String get share {
    switch (locale.languageCode) {
      case 'tr':
        return 'Paylaş';
      case 'de':
        return 'Teilen';
      case 'fr':
        return 'Partager';
      case 'it':
        return 'Condividi';
      case 'es':
        return 'Compartir';
      default:
        return 'Share';
    }
  }

  String get allColors {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tüm Renkler';
      case 'de':
        return 'Alle Farben';
      case 'fr':
        return 'Toutes les couleurs';
      case 'it':
        return 'Tutti i colori';
      case 'es':
        return 'Todos los colores';
      default:
        return 'All Colors';
    }
  }

  String get allLocations {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tüm Konumlar';
      case 'de':
        return 'Alle Standorte';
      case 'fr':
        return 'Tous les emplacements';
      case 'it':
        return 'Tutte le posizioni';
      case 'es':
        return 'Todas las ubicaciones';
      default:
        return 'All Locations';
    }
  }

  String get ascending {
    switch (locale.languageCode) {
      case 'tr':
        return 'Artan';
      case 'de':
        return 'Aufsteigend';
      case 'fr':
        return 'Croissant';
      case 'it':
        return 'Crescente';
      case 'es':
        return 'Ascendente';
      default:
        return 'Ascending';
    }
  }

  // Add these to app_strings.dart

  String get saveStatus {
    switch (locale.languageCode) {
      case 'tr':
        return 'Durum Kaydet';
      case 'de':
        return 'Status speichern';
      case 'fr':
        return 'Enregistrer le statut';
      case 'it':
        return 'Salva stato';
      case 'es':
        return 'Guardar estado';
      default:
        return 'Save Status';
    }
  }

  String get confirmFinished {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament Bitti mi?';
      case 'de':
        return 'Filament aufgebraucht?';
      case 'fr':
        return 'Filament terminé?';
      case 'it':
        return 'Filamento finito?';
      case 'es':
        return '¿Filamento terminado?';
      default:
        return 'Filament Finished?';
    }
  }

  String get confirmFinishedMessage {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bu işlem filamenti BİTMİŞ olarak işaretler ve arşivler. Emin misiniz?';
      case 'de':
        return 'Dies markiert das Filament als AUFGEBRAUCHT und archiviert es. Sind Sie sicher?';
      case 'fr':
        return 'Cela marquera le filament comme TERMINÉ et l\'archivera. Êtes-vous sûr?';
      case 'it':
        return 'Questo segnerà il filamento come FINITO e lo archivierà. Sei sicuro?';
      case 'es':
        return 'Esto marcará el filamento como TERMINADO y lo archivará. ¿Estás seguro?';
      default:
        return 'This will mark the filament as FINISHED and archive it. Are you sure?';
    }
  }

  String get markAsFinished {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bitmiş Olarak İşaretle';
      case 'de':
        return 'Als aufgebraucht markieren';
      case 'fr':
        return 'Marquer comme terminé';
      case 'it':
        return 'Segna come finito';
      case 'es':
        return 'Marcar como terminado';
      default:
        return 'Mark as Finished';
    }
  }

  String get currentStatus {
    switch (locale.languageCode) {
      case 'tr':
        return 'Mevcut Durum';
      case 'de':
        return 'Aktueller Status';
      case 'fr':
        return 'Statut actuel';
      case 'it':
        return 'Stato attuale';
      case 'es':
        return 'Estado actual';
      default:
        return 'Current Status';
    }
  }

  String get lastRecordedGram {
    switch (locale.languageCode) {
      case 'tr':
        return 'Son Kayıtlı Gram';
      case 'de':
        return 'Zuletzt erfasstes Gramm';
      case 'fr':
        return 'Dernier gramme enregistré';
      case 'it':
        return 'Ultimo grammo registrato';
      case 'es':
        return 'Último gramo registrado';
      default:
        return 'Last Recorded Gram';
    }
  }

  String get gram {
    switch (locale.languageCode) {
      case 'tr':
        return 'Gram';
      case 'de':
        return 'Gramm';
      case 'fr':
        return 'Gramme';
      case 'it':
        return 'Grammo';
      case 'es':
        return 'Gramo';
      default:
        return 'Gram';
    }
  }

  String get enterCurrentGram {
    switch (locale.languageCode) {
      case 'tr':
        return 'Mevcut gram ağırlığını girin';
      case 'de':
        return 'Aktuelles Gewicht in Gramm eingeben';
      case 'fr':
        return 'Entrez le poids actuel en grammes';
      case 'it':
        return 'Inserisci il peso attuale in grammi';
      case 'es':
        return 'Ingrese el peso actual en gramos';
      default:
        return 'Enter current gram weight';
    }
  }

  String get invalidGram {
    switch (locale.languageCode) {
      case 'tr':
        return 'Geçersiz gram değeri';
      case 'de':
        return 'Ungültiger Grammwert';
      case 'fr':
        return 'Valeur de gramme invalide';
      case 'it':
        return 'Valore grammo non valido';
      case 'es':
        return 'Valor de gramo inválido';
      default:
        return 'Invalid gram value';
    }
  }

  String get note {
    switch (locale.languageCode) {
      case 'tr':
        return 'Not';
      case 'de':
        return 'Notiz';
      case 'fr':
        return 'Note';
      case 'it':
        return 'Nota';
      case 'es':
        return 'Nota';
      default:
        return 'Note';
    }
  }

  String get optional {
    switch (locale.languageCode) {
      case 'tr':
        return 'Opsiyonel';
      case 'de':
        return 'Optional';
      case 'fr':
        return 'Optionnel';
      case 'it':
        return 'Opzionale';
      case 'es':
        return 'Opcional';
      default:
        return 'Optional';
    }
  }

  String get addNoteHint {
    switch (locale.languageCode) {
      case 'tr':
        return 'Not ekleyin (opsiyonel)';
      case 'de':
        return 'Notiz hinzufügen (optional)';
      case 'fr':
        return 'Ajouter une note (optionnel)';
      case 'it':
        return 'Aggiungi una nota (opzionale)';
      case 'es':
        return 'Agregar una nota (opcional)';
      default:
        return 'Add a note (optional)';
    }
  }
  // Add these to app_strings.dart

  String get takePhoto {
    switch (locale.languageCode) {
      case 'tr':
        return 'Fotoğraf Çek';
      case 'de':
        return 'Foto aufnehmen';
      case 'fr':
        return 'Prendre une photo';
      case 'it':
        return 'Scatta una foto';
      case 'es':
        return 'Tomar foto';
      default:
        return 'Take Photo';
    }
  }

  String get removePhoto {
    switch (locale.languageCode) {
      case 'tr':
        return 'Fotoğrafı Kaldır';
      case 'de':
        return 'Foto entfernen';
      case 'fr':
        return 'Supprimer la photo';
      case 'it':
        return 'Rimuovi foto';
      case 'es':
        return 'Eliminar foto';
      default:
        return 'Remove Photo';
    }
  }

  String get retakePhoto {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yeniden Çek';
      case 'de':
        return 'Foto erneut aufnehmen';
      case 'fr':
        return 'Reprendre la photo';
      case 'it':
        return 'Riscatta foto';
      case 'es':
        return 'Volver a tomar';
      default:
        return 'Retake Photo';
    }
  }
  // Add these to app_strings.dart

  String get history {
    switch (locale.languageCode) {
      case 'tr':
        return 'Geçmiş';
      case 'de':
        return 'Verlauf';
      case 'fr':
        return 'Historique';
      case 'it':
        return 'Cronologia';
      case 'es':
        return 'Historial';
      default:
        return 'History';
    }
  }

  String get noHistory {
    switch (locale.languageCode) {
      case 'tr':
        return 'Geçmiş kaydı yok';
      case 'de':
        return 'Kein Verlauf';
      case 'fr':
        return 'Aucun historique';
      case 'it':
        return 'Nessuna cronologia';
      case 'es':
        return 'Sin historial';
      default:
        return 'No history';
    }
  }

  String get initialRecord {
    switch (locale.languageCode) {
      case 'tr':
        return 'İlk Kayıt';
      case 'de':
        return 'Erster Eintrag';
      case 'fr':
        return 'Premier enregistrement';
      case 'it':
        return 'Primo record';
      case 'es':
        return 'Primer registro';
      default:
        return 'Initial Record';
    }
  }
  // Add this to app_strings.dart

  String get takeFilamentPhoto {
    switch (locale.languageCode) {
      case 'tr':
        return 'Filament Resmi Çek';
      case 'de':
        return 'Filament-Foto aufnehmen';
      case 'fr':
        return 'Prendre une photo du filament';
      case 'it':
        return 'Scatta foto filamento';
      case 'es':
        return 'Tomar foto del filamento';
      default:
        return 'Take Filament Photo';
    }
  }

  String get takePhotoInstruction {
    switch (locale.languageCode) {
      case 'tr':
        return 'Fotoğraf çekmek için butona basın';
      case 'de':
        return 'Drücken Sie die Taste, um ein Foto aufzunehmen';
      case 'fr':
        return 'Appuyez sur le bouton pour prendre une photo';
      case 'it':
        return 'Premi il pulsante per scattare una foto';
      case 'es':
        return 'Presione el botón para tomar una foto';
      default:
        return 'Tap the button to take a photo';
    }
  }
  // Add these to app_strings.dart

  String get confirmDelete {
    switch (locale.languageCode) {
      case 'tr':
        return 'Silmek istediğinize emin misiniz?';
      case 'de':
        return 'Möchten Sie wirklich löschen?';
      case 'fr':
        return 'Êtes-vous sûr de vouloir supprimer?';
      case 'it':
        return 'Sei sicuro di voler eliminare?';
      case 'es':
        return '¿Estás seguro de que quieres eliminar?';
      default:
        return 'Are you sure you want to delete?';
    }
  }

  String get deleted {
    switch (locale.languageCode) {
      case 'tr':
        return 'Silindi';
      case 'de':
        return 'Gelöscht';
      case 'fr':
        return 'Supprimé';
      case 'it':
        return 'Eliminato';
      case 'es':
        return 'Eliminado';
      default:
        return 'Deleted';
    }
  }
  // Add these to app_strings.dart

  String get noPrintersAvailable {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kullanılabilir printer yok';
      case 'de':
        return 'Keine Drucker verfügbar';
      case 'fr':
        return 'Aucune imprimante disponible';
      case 'it':
        return 'Nessuna stampante disponibile';
      case 'es':
        return 'No hay impresoras disponibles';
      default:
        return 'No printers available';
    }
  }

  String get selectPrinter {
    switch (locale.languageCode) {
      case 'tr':
        return 'Printer Seç';
      case 'de':
        return 'Drucker auswählen';
      case 'fr':
        return 'Sélectionner l\'imprimante';
      case 'it':
        return 'Seleziona stampante';
      case 'es':
        return 'Seleccionar impresora';
      default:
        return 'Select Printer';
    }
  }

  String get selectSlot {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot Seç';
      case 'de':
        return 'Slot auswählen';
      case 'fr':
        return 'Sélectionner le slot';
      case 'it':
        return 'Seleziona slot';
      case 'es':
        return 'Seleccionar ranura';
      default:
        return 'Select Slot';
    }
  }

  String get slots {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slotlar';
      case 'de':
        return 'Slots';
      case 'fr':
        return 'Emplacements';
      case 'it':
        return 'Slot';
      case 'es':
        return 'Ranuras';
      default:
        return 'Slots';
    }
  }

  String get assigned {
    switch (locale.languageCode) {
      case 'tr':
        return 'Atandı';
      case 'de':
        return 'Zugewiesen';
      case 'fr':
        return 'Assigné';
      case 'it':
        return 'Assegnato';
      case 'es':
        return 'Asignado';
      default:
        return 'Assigned';
    }
  }
  // Add these to app_strings.dart

  String get slotOccupied {
    switch (locale.languageCode) {
      case 'tr':
        return 'Slot Dolu';
      case 'de':
        return 'Slot belegt';
      case 'fr':
        return 'Emplacement occupé';
      case 'it':
        return 'Slot occupato';
      case 'es':
        return 'Ranura ocupada';
      default:
        return 'Slot Occupied';
    }
  }

  String get replace {
    switch (locale.languageCode) {
      case 'tr':
        return 'Değiştir';
      case 'de':
        return 'Ersetzen';
      case 'fr':
        return 'Remplacer';
      case 'it':
        return 'Sostituisci';
      case 'es':
        return 'Reemplazar';
      default:
        return 'Replace';
    }
  }

  String get onPrinters {
    switch (locale.languageCode) {
      case 'tr':
        return 'Printerlarda';
      case 'de':
        return 'Auf Druckern';
      case 'fr':
        return 'Sur les imprimantes';
      case 'it':
        return 'Sulle stampanti';
      case 'es':
        return 'En impresoras';
      default:
        return 'On Printers';
    }
  }

  String get onPrintersHint {
    switch (locale.languageCode) {
      case 'tr':
        return 'Sadece printerlara atanmış filamentleri göster';
      case 'de':
        return 'Nur Filamente anzeigen, die Druckern zugewiesen sind';
      case 'fr':
        return 'Afficher uniquement les filaments assignés aux imprimantes';
      case 'it':
        return 'Mostra solo i filamenti assegnati alle stampanti';
      case 'es':
        return 'Mostrar solo filamentos asignados a impresoras';
      default:
        return 'Show only filaments assigned to printers';
    }
  }

  String get occupied {
    switch (locale.languageCode) {
      case 'tr':
        return 'Dolu';
      case 'de':
        return 'Belegt';
      case 'fr':
        return 'Occupé';
      case 'it':
        return 'Occupato';
      case 'es':
        return 'Ocupado';
      default:
        return 'Occupied';
    }
  }

  String get available {
    switch (locale.languageCode) {
      case 'tr':
        return 'Boş';
      case 'de':
        return 'Verfügbar';
      case 'fr':
        return 'Disponible';
      case 'it':
        return 'Disponibile';
      case 'es':
        return 'Disponible';
      default:
        return 'Available';
    }
  }

  String get dashboard {
    switch (locale.languageCode) {
      case 'tr':
        return 'Ana Sayfa';
      case 'de':
        return 'Dashboard';
      case 'fr':
        return 'Tableau de bord';
      case 'it':
        return 'Dashboard';
      case 'es':
        return 'Panel';
      default:
        return 'Dashboard';
    }
  }

  String get totalFilaments {
    switch (locale.languageCode) {
      case 'tr':
        return 'Toplam Filament';
      case 'de':
        return 'Gesamt Filamente';
      case 'fr':
        return 'Total Filaments';
      case 'it':
        return 'Filamenti Totali';
      case 'es':
        return 'Filamentos Totales';
      default:
        return 'Total Filaments';
    }
  }

  String get totalGrams {
    switch (locale.languageCode) {
      case 'tr':
        return 'Toplam Gram';
      case 'de':
        return 'Gesamt Gramm';
      case 'fr':
        return 'Grammes Totaux';
      case 'it':
        return 'Grammi Totali';
      case 'es':
        return 'Gramos Totales';
      default:
        return 'Total Grams';
    }
  }

  String get statusDistribution {
    switch (locale.languageCode) {
      case 'tr':
        return 'Durum Dağılımı';
      case 'de':
        return 'Statusverteilung';
      case 'fr':
        return 'Distribution des statuts';
      case 'it':
        return 'Distribuzione dello stato';
      case 'es':
        return 'Distribución de estado';
      default:
        return 'Status Distribution';
    }
  }

  String get recentFilaments {
    switch (locale.languageCode) {
      case 'tr':
        return 'Son Eklenenler';
      case 'de':
        return 'Kürzlich hinzugefügt';
      case 'fr':
        return 'Récemment ajoutés';
      case 'it':
        return 'Aggiunti di recente';
      case 'es':
        return 'Añadidos recientemente';
      default:
        return 'Recently Added';
    }
  }

  String get lowStockAlert {
    switch (locale.languageCode) {
      case 'tr':
        return 'Düşük Stok Uyarısı';
      case 'de':
        return 'Niedriger Lagerbestand';
      case 'fr':
        return 'Alerte stock faible';
      case 'it':
        return 'Avviso scorte basse';
      case 'es':
        return 'Alerta de stock bajo';
      default:
        return 'Low Stock Alert';
    }
  }

  String get printerOccupancy {
    switch (locale.languageCode) {
      case 'tr':
        return 'Printer Doluluk';
      case 'de':
        return 'Druckerbelegung';
      case 'fr':
        return 'Occupation imprimante';
      case 'it':
        return 'Occupazione stampante';
      case 'es':
        return 'Ocupación de impresora';
      default:
        return 'Printer Occupancy';
    }
  }

  String get emptySlots {
    switch (locale.languageCode) {
      case 'tr':
        return 'Boş Slot';
      case 'de':
        return 'Leere Slots';
      case 'fr':
        return 'Emplacements vides';
      case 'it':
        return 'Slot vuoti';
      case 'es':
        return 'Ranuras vacías';
      default:
        return 'Empty Slots';
    }
  }

  String get occupiedSlots {
    switch (locale.languageCode) {
      case 'tr':
        return 'Dolu Slot';
      case 'de':
        return 'Belegte Slots';
      case 'fr':
        return 'Emplacements occupés';
      case 'it':
        return 'Slot occupati';
      case 'es':
        return 'Ranuras ocupadas';
      default:
        return 'Occupied Slots';
    }
  }

  String get overview {
    switch (locale.languageCode) {
      case 'tr':
        return 'Genel Bakış';
      case 'de':
        return 'Übersicht';
      case 'fr':
        return 'Aperçu';
      case 'it':
        return 'Panoramica';
      case 'es':
        return 'Resumen';
      default:
        return 'Overview';
    }
  }

  String get inventory {
    switch (locale.languageCode) {
      case 'tr':
        return 'Envanter';
      case 'de':
        return 'Inventar';
      case 'fr':
        return 'Inventory';
      case 'it':
        return 'Inventory';
      case 'es':
        return 'Inventory';
      default:
        return 'Inventory';
    }
  }

  String get help {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yardım';
      case 'de':
        return 'Hilfe';
      case 'fr':
        return 'Aide';
      case 'it':
        return 'Aiuto';
      case 'es':
        return 'Ayuda';
      default:
        return 'Help';
    }
  }

  String get betaTracking {
    switch (locale.languageCode) {
      case 'tr':
        return 'Beta İzleme';
      case 'de':
        return 'Beta-Tracking';
      case 'fr':
        return 'Suivi Bêta';
      case 'it':
        return 'Tracciamento Beta';
      case 'es':
        return 'Seguimiento Beta';
      default:
        return 'Beta Tracking';
    }
  }

  String get betaTestingInfo {
    switch (locale.languageCode) {
      case 'tr':
        return 'Bu beta sürümünde kullanım istatistikleriniz yerel olarak kaydedilir ve uygulamayı geliştirmemize yardımcı olur.';
      case 'de':
        return 'In dieser Beta-Version werden Ihre Nutzungsstatistiken lokal gespeichert und helfen uns, die App zu verbessern.';
      case 'fr':
        return 'Dans cette version bêta, vos statistiques d\'utilisation sont enregistrées localement et nous aident à améliorer l\'application.';
      case 'it':
        return 'In questa versione beta, le tue statistiche di utilizzo vengono salvate localmente e ci aiutano a migliorare l\'app.';
      case 'es':
        return 'En esta versión beta, tus estadísticas de uso se guardan localmente y nos ayudan a mejorar la aplicación.';
      default:
        return 'In this beta version, your usage statistics are saved locally and help us improve the app.';
    }
  }

  String get totalSessions {
    switch (locale.languageCode) {
      case 'tr':
        return 'Toplam Oturum';
      case 'de':
        return 'Gesamte Sitzungen';
      case 'fr':
        return 'Total des Sessions';
      case 'it':
        return 'Sessioni Totali';
      case 'es':
        return 'Sesiones Totales';
      default:
        return 'Total Sessions';
    }
  }

  String get totalActions {
    switch (locale.languageCode) {
      case 'tr':
        return 'Toplam İşlem';
      case 'de':
        return 'Gesamte Aktionen';
      case 'fr':
        return 'Total des Actions';
      case 'it':
        return 'Azioni Totali';
      case 'es':
        return 'Acciones Totales';
      default:
        return 'Total Actions';
    }
  }

  String get firstLaunch {
    switch (locale.languageCode) {
      case 'tr':
        return 'İlk Açılış';
      case 'de':
        return 'Erster Start';
      case 'fr':
        return 'Premier Lancement';
      case 'it':
        return 'Primo Avvio';
      case 'es':
        return 'Primer Inicio';
      default:
        return 'First Launch';
    }
  }

  String get lastLaunch {
    switch (locale.languageCode) {
      case 'tr':
        return 'Son Açılış';
      case 'de':
        return 'Letzter Start';
      case 'fr':
        return 'Dernier Lancement';
      case 'it':
        return 'Ultimo Avvio';
      case 'es':
        return 'Último Inicio';
      default:
        return 'Last Launch';
    }
  }

  String get betaDataNote {
    switch (locale.languageCode) {
      case 'tr':
        return 'Not: Bu veriler yalnızca cihazınızda saklanır ve export/import işlemlerine dahil edilir.';
      case 'de':
        return 'Hinweis: Diese Daten werden nur auf Ihrem Gerät gespeichert und in Export-/Importvorgänge einbezogen.';
      case 'fr':
        return 'Note : Ces données sont uniquement stockées sur votre appareil et incluses dans les opérations d\'export/import.';
      case 'it':
        return 'Nota: Questi dati sono archiviati solo sul tuo dispositivo e inclusi nelle operazioni di esportazione/importazione.';
      case 'es':
        return 'Nota: Estos datos solo se almacenan en tu dispositivo y se incluyen en las operaciones de exportación/importación.';
      default:
        return 'Note: This data is only stored on your device and included in export/import operations.';
    }
  }

  String get installVersion {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kurulum Sürümü';
      case 'de':
        return 'Installationsversion';
      case 'fr':
        return 'Version d\'Installation';
      case 'it':
        return 'Versione Installazione';
      case 'es':
        return 'Versión de Instalación';
      default:
        return 'Install Version';
    }
  }

  String get installDate {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kurulum Tarihi';
      case 'de':
        return 'Installationsdatum';
      case 'fr':
        return 'Date d\'Installation';
      case 'it':
        return 'Data di Installazione';
      case 'es':
        return 'Fecha de Instalación';
      default:
        return 'Install Date';
    }
  }

  String get betaTesterStatus {
    switch (locale.languageCode) {
      case 'tr':
        return 'Beta Tester Durumu';
      case 'de':
        return 'Beta-Tester-Status';
      case 'fr':
        return 'Statut Bêta Testeur';
      case 'it':
        return 'Stato Beta Tester';
      case 'es':
        return 'Estado Beta Tester';
      default:
        return 'Beta Tester Status';
    }
  }

  String get eligible {
    switch (locale.languageCode) {
      case 'tr':
        return 'Uygun ✓';
      case 'de':
        return 'Berechtigt ✓';
      case 'fr':
        return 'Éligible ✓';
      case 'it':
        return 'Idoneo ✓';
      case 'es':
        return 'Elegible ✓';
      default:
        return 'Eligible ✓';
    }
  }

  String get notEligible {
    switch (locale.languageCode) {
      case 'tr':
        return 'Uygun Değil';
      case 'de':
        return 'Nicht Berechtigt';
      case 'fr':
        return 'Non Éligible';
      case 'it':
        return 'Non Idoneo';
      case 'es':
        return 'No Elegible';
      default:
        return 'Not Eligible';
    }
  }

  String get verifiedBadge {
    switch (locale.languageCode) {
      case 'tr':
        return 'Onaylanmış Rozet';
      case 'de':
        return 'Verifiziertes Abzeichen';
      case 'fr':
        return 'Badge Vérifié';
      case 'it':
        return 'Badge Verificato';
      case 'es':
        return 'Insignia Verificada';
      default:
        return 'Verified Badge';
    }
  }

  String get granted {
    switch (locale.languageCode) {
      case 'tr':
        return 'Verildi 🏆';
      case 'de':
        return 'Erhalten 🏆';
      case 'fr':
        return 'Accordé 🏆';
      case 'it':
        return 'Concesso 🏆';
      case 'es':
        return 'Otorgado 🏆';
      default:
        return 'Granted 🏆';
    }
  }

  String get viewAll {
    switch (locale.languageCode) {
      case 'tr':
        return 'Tümünü Gör';
      case 'de':
        return 'Alle Anzeigen';
      case 'fr':
        return 'Voir Tout';
      case 'it':
        return 'Vedi Tutto';
      case 'es':
        return 'Ver Todo';
      default:
        return 'View All';
    }
  }

  String get viewReport {
    switch (locale.languageCode) {
      case 'tr':
        return 'Rapor Gör';
      case 'de':
        return 'Bericht Anzeigen';
      case 'fr':
        return 'Voir Rapport';
      case 'it':
        return 'Vedi Rapporto';
      case 'es':
        return 'Ver Informe';
      default:
        return 'View Report';
    }
  }

  String get manage {
    switch (locale.languageCode) {
      case 'tr':
        return 'Yönet';
      case 'de':
        return 'Verwalten';
      case 'fr':
        return 'Gérer';
      case 'it':
        return 'Gestisci';
      case 'es':
        return 'Gestionar';
      default:
        return 'Manage';
    }
  }

  String get detectedGram {
    switch (locale.languageCode) {
      case 'tr':
        return 'Algılanan Gram';
      case 'de':
        return 'Erkanntes Gramm';
      case 'fr':
        return 'Grammes Détectés';
      case 'it':
        return 'Grammi Rilevati';
      case 'es':
        return 'Gramos Detectados';
      default:
        return 'Detected Gram';
    }
  }

  String get gramNotDetected {
    switch (locale.languageCode) {
      case 'tr':
        return 'Gram Algılanamadı';
      case 'de':
        return 'Gramm Nicht Erkannt';
      case 'fr':
        return 'Grammes Non Détectés';
      case 'it':
        return 'Grammi Non Rilevati';
      case 'es':
        return 'Gramos No Detectados';
      default:
        return 'Gram Not Detected';
    }
  }

  String get selectLocationForOldFilament {
    switch (locale.languageCode) {
      case 'tr':
        return 'Eski Makara İçin Lokasyon Seçin';
      case 'de':
        return 'Standort für alte Spule wählen';
      case 'fr':
        return 'Sélectionner l\'emplacement pour l\'ancienne bobine';
      case 'it':
        return 'Seleziona posizione per la vecchia bobina';
      case 'es':
        return 'Seleccionar ubicación para el carrete antiguo';
      default:
        return 'Select Location for Old Filament';
    }
  }

  String get noLocationsAvailable {
    switch (locale.languageCode) {
      case 'tr':
        return 'Kullanılabilir Lokasyon Yok';
      case 'de':
        return 'Keine Standorte verfügbar';
      case 'fr':
        return 'Aucun emplacement disponible';
      case 'it':
        return 'Nessuna posizione disponibile';
      case 'es':
        return 'No hay ubicaciones disponibles';
      default:
        return 'No Locations Available';
    }
  }
}
