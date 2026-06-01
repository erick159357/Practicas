class ApiConstants {
  ApiConstants._();

  static const String accessKey = '2jGVJ6x6orh0ftaxc5gW1yQTM_FLhyOqN71ZV_cCXMc';

  static const String baseUrl = 'https://api.unsplash.com';

  static const int perPage = 20;

  static bool get isKeyConfigured => accessKey.length > 20;
}