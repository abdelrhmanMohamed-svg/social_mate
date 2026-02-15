import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_mate/core/models/route_observer.dart';
import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FcmServices {
  Future<String?> getFcmToken();
  Future<void> initialize();

  Future<void> startListeningForTokenChanges();
  Future<void> dispose();
  Future<String?> getSavedFcmToken(String userId);
  Future<bool> saveFcmTokenToDatabase(String token);
}

class FcmServicesImpl implements FcmServices {
  static final _instance = FcmServicesImpl._internal();
  factory FcmServicesImpl() => _instance;
  FcmServicesImpl._internal();
  static FcmServicesImpl get instance => _instance;

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _supabaseServices = SupabaseDatabaseServices.instance;
  final SupabaseClient _client = Supabase.instance.client;
  StreamSubscription<String?>? _tokenSubscription;
  late final FlutterLocalNotificationsPlugin _localNotifications;
  static GlobalKey<NavigatorState>? _navigatorKey;
  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  @override
  Future<String?> getFcmToken() async {
    try {
      final settings = await _firebaseMessaging.requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint(' Notifications not authorized');
        return null;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint('Waiting for APNS token...');
          await Future.delayed(const Duration(seconds: 2));
        }
      }
      final fcmToken = await _firebaseMessaging.getToken();
      return fcmToken;
    } catch (e) {
      rethrow;
    }
  }

  @override
  @override
  Future<bool> saveFcmTokenToDatabase(String token) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        debugPrint('No authenticated user');
        return false;
      }

      await _supabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        values: {AppConstants.fcmToken: token},
        column: AppConstants.primaryKey,
        value: user.id,
      );

      final verification = await _supabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        id: user.id,
        primaryKey: AppConstants.primaryKey,
        builder: (data, id) => UserModel.fromMap(data),
      );

      final savedToken = verification.fcmToken;

      if (savedToken == token) {
        debugPrint('✅ FCM token verified and saved');
        return true;
      } else {
        debugPrint('⚠️ Token saved but verification failed');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error saving FCM token: $e');
      return false;
    }
  }

  @override
  Future<String?> getSavedFcmToken(String userId) async {
    try {
      // 1. تأكد أن المستخدم لسه موجود
      final currentUser = _client.auth.currentUser;
      debugPrint('👤 Current user: ${currentUser?.id}');
      debugPrint(
        '🔑 Current session exists: ${_client.auth.currentSession != null}',
      );

      if (currentUser == null) {
        debugPrint('⚠️ No authenticated user!');
        return null;
      }

      // 2. لو userId مش مطابق للـ current user، ممكن يكون في مشكلة
      if (userId != currentUser.id) {
        debugPrint(
          '⚠️ Requested userId ($userId) != currentUser (${currentUser.id})',
        );
      }

      final user = await _supabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        id: userId,
        primaryKey: AppConstants.primaryKey,
        builder: (data, id) => UserModel.fromMap(data),
      );
      debugPrint('✅ User fetched successfully from DB');
      return user.fcmToken;
    } on PostgrestException catch (e) {
      debugPrint('❌ Postgrest Error: ${e.message}, Code: ${e.code}');
      if (e.code == 'PGRST301') {}
      rethrow;
    } catch (e) {
      debugPrint('❌ General Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> startListeningForTokenChanges() async {
    _tokenSubscription = _firebaseMessaging.onTokenRefresh.listen((newToken) {
      saveFcmTokenToDatabase(newToken);
    });
  }

  @override
  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
  }

  @override
  @override
  Future<void> initialize() async {
    try {
      // 1. Request permissions first
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('⚠️ Notifications permission denied');
        return;
      }

      // 2. Initialize local notifications
      _localNotifications = FlutterLocalNotificationsPlugin();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        onDidReceiveBackgroundNotificationResponse:
            _onBackgroundNotificationTap,
      );

      // 3. Create notification channel for Android 8+
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(
              const AndroidNotificationChannel(
                'chat_messages',
                'Chat Messages',
                description: 'Notifications for new chat messages',
                importance: Importance.high,
                playSound: true,
              ),
            );
      }

      // 4. Set up message handlers
      _setupMessageHandlers();

      debugPrint('✅ FCM Service initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing FCM: $e');
      rethrow;
    }
  }

  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/terminated message clicks
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

    // Get initial message (app opened from terminated state)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(message);
      }
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📩 Foreground message received: ${message.messageId}');

    final senderId = message.data[AppConstants.notificationKeySenderId];
    final receiverId = message.data[AppConstants.notificationKeyReceiverId];
    final currentUserId = _client.auth.currentUser?.id;

    // Get the other user ID from message (same logic as notification click)
    final messageOtherUserId =
        senderId == currentUserId ? receiverId : senderId;

    // Get current route and its arguments (which is otherUserId)
    final currentRoute = RouteObserverModel.currentRoute;
    final routeOtherUserId = RouteObserverModel.currentArguments;

    debugPrint('📍 Current route: $currentRoute');
    debugPrint('👥 Route otherUserId: $routeOtherUserId');
    debugPrint('👥 Message otherUserId: $messageOtherUserId');

    // Check if user is already in this chat with the same person
    if (currentRoute == AppRoutes.singleChatPageRoute &&
        routeOtherUserId == messageOtherUserId) {
      debugPrint('👤 User is already in chat with this person, skipping notification');
      return;
    }

    _showLocalNotification(message);
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('👉 _onNotificationTap called');

    if (response.payload == null) {
      debugPrint('❌ Payload is null');
      return;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(response.payload!);
      debugPrint('📱 Decoded payload: $data');

      final remoteMessage = RemoteMessage(
        senderId: '', // مش مهم للـ local notification
        messageId:
            data['messageId'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        data: data,
        sentTime: data['sentTime'] != null
            ? DateTime.tryParse(data['sentTime'])
            : DateTime.now(),
      );

      _handleNotificationClick(remoteMessage);
    } catch (e) {
      debugPrint('❌ Error in _onNotificationTap: $e');
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    try {
      // Use a unique ID per message to avoid overwriting
      final notificationId =
          message.data['messageId']?.hashCode ??
          DateTime.now().millisecondsSinceEpoch;
      final safeData = {
        AppConstants.notificationKeyChatId:
            message.data[AppConstants.notificationKeyChatId],
        AppConstants.notificationKeySenderId:
            message.data[AppConstants.notificationKeySenderId],
        AppConstants.notificationKeyReceiverId:
            message.data[AppConstants.notificationKeyReceiverId],
        AppConstants.notificationKeyMessageId:
            message.data[AppConstants.notificationKeyMessageId],
        AppConstants.content: message.data[AppConstants.content],
      };
      _localNotifications.show(
        id: notificationId,
        title: message.notification?.title ?? 'New Message',
        body:
            message.notification?.body ??
            message.data[AppConstants.content] ??
            '',
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'chat_messages',
            'Chat Messages',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            categoryIdentifier: 'chat_message',
          ),
        ),
        payload: jsonEncode(safeData),
      );

      debugPrint('✅ Local notification shown: $notificationId');
    } catch (e) {
      debugPrint('❌ Error showing local notification: $e');
    }
  }

  void _handleNotificationClick(RemoteMessage message) {
    debugPrint('👉 _handleNotificationClick called');
    debugPrint('🔑 navigatorKey assigned: $_navigatorKey != null');

    try {
      final chatId = message.data[AppConstants.notificationKeyChatId];
      final senderId = message.data[AppConstants.notificationKeySenderId];
      final receiverId = message.data[AppConstants.notificationKeyReceiverId];
      final currentUserId = _client.auth.currentUser?.id;

      if (chatId == null || currentUserId == null) {
        debugPrint('⚠️ Missing chatId or currentUserId');
        return;
      }

      final otherUserId = senderId == currentUserId ? receiverId : senderId;
      debugPrint(
        '👉 Will navigate to chat: $chatId, otherUserId: $otherUserId',
      );

      // Try immediate navigation
      if (_navigatorKey?.currentState?.mounted ?? false) {
        _navigatorKey?.currentState?.pushNamed(
          AppRoutes.singleChatPageRoute,
          arguments: otherUserId,
        );
        debugPrint('✅ Navigation successful');
        return;
      }

      // If currentState is null, wait for the frame to complete
      debugPrint('⚠️ Navigator not ready, scheduling navigation...');
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_navigatorKey?.currentState?.mounted ?? false) {
          _navigatorKey?.currentState?.pushNamed(
            AppRoutes.singleChatPageRoute,
            arguments: otherUserId,
          );
          debugPrint('✅ Delayed navigation successful');
        } else {
          debugPrint('❌ Navigator still not available after delay');
        }
      });
    } catch (e) {
      debugPrint('❌ Error in notification click handler: $e');
    }
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);

      debugPrint('📱 Background notification tapped: $data');
    }
  }
}
