import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static const String appName = "social mate";
  static String get supabaseUrl => dotenv.env['supabaseUrl'] ?? "";
  static String get supabaseAnonKey => dotenv.env['supabaseAnonKey'] ?? "";
  static const String envFileName = ".env";
}
