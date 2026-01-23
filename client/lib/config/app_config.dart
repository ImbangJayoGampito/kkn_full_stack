class AppConfig {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String productsEndpoint = '$baseUrl/products';
  static const String loginEndpoint = '$baseUrl/login';
  static const String registerEndpoint = '$baseUrl/register';
  static const String sessionToken = 'token';
  static const String userRestoreEndpoint = '$baseUrl/user/restore';
}

class RouteConfig {
  static const String mainMenu = '/';
  static const String settings = '/settings';
  static const String tourism = '/tourism';
  static const String register = '/register';
  static const String products = '/products';
  static const String login = '/login';
}
