class BackupData {
  final String version;
  final String appVersion;
  final String exportDate;
  final int databaseVersion;
  final Map<String, dynamic> data;

  BackupData({
    required this.version,
    required this.appVersion,
    required this.exportDate,
    required this.databaseVersion,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'app_version': appVersion,
      'export_date': exportDate,
      'database_version': databaseVersion,
      'data': data,
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      version: json['version'] as String,
      appVersion: json['app_version'] as String,
      exportDate: json['export_date'] as String,
      databaseVersion: json['database_version'] as int,
      data: json['data'] as Map<String, dynamic>,
    );
  }
}
