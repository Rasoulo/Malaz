class AppConstants {
  static const baseurl = 'http://192.168.1.102:8000/api';
  /// [SharedPreferences] Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  /// [Failure] Keys
  static const String networkFailureKey = 'NETWORK_FAILURE_KEY';
  static const String unknownFailureKey = 'UNKNOWN_FAILURE_KEY';
  static const String cancelledFailureKey = 'CANCELLED_FAILURE_KEY';

  /// Authentication Keys
  static const String tokenKey = 'CACHED_TOKEN';
  static const String userKey = 'CACHED_USER';
  static const String pendingKey = 'IS_PENDING';

  /// Location Key
  static const String locationKey = 'CACHED_LOCATION';

  static const numberOfApartmentsEachRequest = 2;
  static const numberOfBookingEachRequest = 5;


  static String userProfileImage(int userId) => "$baseurl/users/$userId/profile_image";
}