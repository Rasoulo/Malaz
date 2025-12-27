class AppConstants {
  static const baseurl = 'http://192.168.1.103:8000/api';
  /// [SharedPreferences] Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String tokenKey = 'CACHED_TOKEN';

  /// [Failure] Keys
  static const String networkFailureKey = 'NETWORK_FAILURE_KEY';
  static const String unknownFailureKey = 'UNKNOWN_FAILURE_KEY';
  static const String cancelledFailureKey = 'CANCELLED_FAILURE_KEY';

  static const numberOfApartmentsEachRequest = 2;
}