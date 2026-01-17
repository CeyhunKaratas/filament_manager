import 'package:shared_preferences/shared_preferences.dart';

class BetaTrackerService {
  static const String _installVersionKey = 'first_install_version';
  static const String _installTimestampKey = 'first_install_timestamp';
  static const String _verifiedBadgeKey = 'verified_beta_tester';

  /// Record first installation (v0.5.0-beta)
  static Future<void> recordInstallation(String version) async {
    final prefs = await SharedPreferences.getInstance();

    // Only record FIRST installation
    if (!prefs.containsKey(_installVersionKey)) {
      await prefs.setString(_installVersionKey, version);
      await prefs.setString(
        _installTimestampKey,
        DateTime.now().toIso8601String(),
      );
    }
  }

  /// Get installation info
  static Future<Map<String, String>?> getInstallationInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getString(_installVersionKey);
    final timestamp = prefs.getString(_installTimestampKey);

    if (version != null && timestamp != null) {
      return {'version': version, 'installed_at': timestamp};
    }
    return null;
  }

  /// Check if user is eligible for beta tester benefits
  static Future<bool> isEligibleBetaTester() async {
    final info = await getInstallationInfo();
    if (info == null) return false;

    final version = info['version']!;
    final timestamp = DateTime.parse(info['installed_at']!);
    final deadline = DateTime(2026, 3, 1);

    // Must be v0.5.x and installed before deadline
    return version.startsWith('0.5.') && timestamp.isBefore(deadline);
  }

  /// Verify and grant lifetime badge (v1.0+ will call this)
  static Future<bool> verifyAndGrantLifetimeBadge() async {
    if (await isEligibleBetaTester()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_verifiedBadgeKey, true);
      return true;
    }
    return false;
  }

  /// Check if user has verified beta tester badge
  static Future<bool> hasVerifiedBadge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_verifiedBadgeKey) ?? false;
  }
}
