
/// Represents errors that occur during data fetching or processing.
class ServerException implements Exception {}

/// Represents errors that occur when there is no internet connection.
class NetworkException implements Exception {}

/// Represents errors that occur when there is no cached data available.
class CacheException implements Exception {}

/// Can be used for other general exceptions.
class GeneralException implements Exception {}
