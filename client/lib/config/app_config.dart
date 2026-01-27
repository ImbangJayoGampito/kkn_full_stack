class AppConfig {
  // Base URL of your API
  static const String baseUrl = 'http://localhost:5094/api';

  // API endpoints
  static const String productsEndpoint = '$baseUrl/product/';
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String userRestoreEndpoint = '$baseUrl/auth/restore';
  static const String adminDashboardEndpoint = '$baseUrl/admin/dashboard';

  // Session token key for local storage
  static const String sessionToken = 'token';

  // Timeout configuration for network requests
  static const Duration timeout = Duration(seconds: 10);
}

class RouteConfig {
  static const String mainMenu = '/';
  static const String settings = '/settings';
  static const String tourism = '/tourism';
  static const String register = '/register';
  static const String products = '/products';
  static const String login = '/login';
}
