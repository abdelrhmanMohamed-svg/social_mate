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
  static const String userIMagePLaceholder =
      "https://i.pinimg.com/1200x/6e/59/95/6e599501252c23bcf02658617b29c894.jpg";

  //table columns
  static const String primaryKey = "id";
  static const String authorIdColumn = "author_id";
  static const String postIdColumn = "post_id";
  static const String followWatingColumn = "follow_waiting";
  static const String followRequestsColumn = "follow_requests";
  static const String followersColumn = "followers";
  static const String followingColumn = "following";
  static const String createdAtColumn = "created_at";
  static const String userNameColumn = "name";
  static const String chatIdColumn = "chat_id";
  static const String userIdColumn = "user_id";
  static const String contentColumn = "content";
  static const String lastMessageContentColumn = "last_message";
  static const String lastMessageAtColumn = "last_message_at";
  static const String isReadColumn = "is_read";
  static const String senderIdColumn = "sender_id";


}
