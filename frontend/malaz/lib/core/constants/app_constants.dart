class AppConstants {
  static const baseurl = 'http://192.168.137.24:8000/api';
  static const baseurlForPusher = 'http://192.168.137.24:8000/broadcasting/auth';

  /// [SharedPreferences] Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  /// [Failure] Keys
  static const String networkFailureKey = 'NETWORK_FAILURE_KEY';
  static const String unknownFailureKey = 'UNKNOWN_FAILURE_KEY';
  static const String cancelledFailureKey = 'CANCELLED_FAILURE_KEY';

  /// [Authentication] Keys
  static const String tokenKey = 'CACHED_TOKEN';
  static const String userKey = 'CACHED_USER';
  static const String pendingKey = 'IS_PENDING';
  static const String phoneUserKey = 'USER_PHONE';
  static const String passwordUserKey = 'USER_PASSWORD';

  /// [Location] Key
  static const String locationKey = 'CACHED_LOCATION';

  /// [Requesting] keys
  static const numberOfApartmentsEachRequest = 2;
  static const numberOfReviewsEachRequest =  2;
  static const numberOfBookingEachRequest = 5;

  /// [Pusher] keys
  static const String apiKeyForPusher = 'c85e12264ff96015fc05';
  static const String clusterForPusher = 'ap2';

  /// [Logo] key
  static const String LogoPath = 'assets/icons/key_logo.png';

  static String userProfileImage(int userId) => "$baseurl/users/$userId/profile_image";
}