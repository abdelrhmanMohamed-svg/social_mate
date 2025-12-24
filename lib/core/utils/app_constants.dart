import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static const String appName = "social mate";

  static String get supabaseUrl => dotenv.env['supabaseUrl'] ?? "";
  static String get supabaseAnonKey => dotenv.env['supabaseAnonKey'] ?? "";
  static const String envFileName = ".env";

  // images paths
  static const String logoPath = "assets/images/Logo.png";
  static const String microsoftPath = "assets/images/microsoft_logo.png";
  static const String googlePath = "assets/images/google_logo.png";
}
