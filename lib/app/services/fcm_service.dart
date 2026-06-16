import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_constants.dart';
import '../data/providers/fcm_token_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
}

/// Channel notifikasi heads-up (suara + getar) untuk pesan foreground.
const _androidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'Notifikasi Penting',
  description: 'Notifikasi pemantauan drainase IoT',
  importance: Importance.high,
);

class FcmService extends GetxService {
  final _messaging = FirebaseMessaging.instance;
  final _provider = FcmTokenProvider();
  final _localNotifications = FlutterLocalNotificationsPlugin();

  /// ID unik perangkat HP pemantau (persisted, dibuat sekali per instalasi).
  static const _kAppInstanceId = 'fcm_app_instance_id';

  /// FCM token terakhir yang berhasil diregistrasi ke backend.
  static const _kRegisteredToken = 'fcm_registered_token';

  late final SharedPreferences _prefs;

  Future<FcmService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _provider.onInit();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _initLocalNotifications();
    _listenForeground();

    // Token bisa berubah; daftarkan ulang otomatis saat itu terjadi.
    _messaging.onTokenRefresh.listen(_registerIfNeeded);

    // Ambil & daftarkan token. init() ini sudah dipanggil non-blocking dari
    // main(), jadi tidak ada lagi risiko menahan splash; pakai retry supaya
    // device tetap teregistrasi walau pengambilan token pertama lambat/gagal
    // (penting di APK release pada instalasi pertama).
    await _fetchAndRegisterToken();

    return this;
  }

  /// Ambil FCM token lalu daftarkan ke backend. Jika gagal/null, coba ulang
  /// beberapa kali dengan jeda — getToken() pada instalasi baru bisa butuh
  /// waktu untuk registrasi awal ke server FCM.
  Future<void> _fetchAndRegisterToken({int attempt = 0}) async {
    String? token;
    try {
      token = await _messaging
          .getToken()
          .timeout(const Duration(seconds: 20), onTimeout: () => null);
    } catch (e) {
      debugPrint('FCM: getToken error: $e');
    }

    debugPrint('FCM token (attempt ${attempt + 1}): $token');

    if (token != null) {
      await _registerIfNeeded(token);
      return;
    }

    // Belum dapat token; coba lagi (maksimal 5x, jeda 10 detik).
    if (attempt < 4) {
      await Future.delayed(const Duration(seconds: 10));
      await _fetchAndRegisterToken(attempt: attempt + 1);
    } else {
      debugPrint('FCM: gagal mendapatkan token setelah beberapa percobaan');
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _localNotifications.initialize(initSettings);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  /// Hanya hit backend bila token belum pernah diregistrasi atau berubah,
  /// supaya perangkat yang sudah teregistrasi tidak registrasi ulang.
  Future<void> _registerIfNeeded(String token) async {
    if (_prefs.getString(_kRegisteredToken) == token) {
      debugPrint('FCM: token already registered, skipping');
      return;
    }

    try {
      final ok = await _provider.registerToken(
        deviceId: AppConstants.deviceId,
        appInstanceId: _appInstanceId(),
        fcmToken: token,
      );
      if (ok) {
        await _prefs.setString(_kRegisteredToken, token);
        debugPrint('FCM: token registered successfully');
      } else {
        debugPrint('FCM: token registration failed');
      }
    } catch (e) {
      debugPrint('FCM: register token error: $e');
    }
  }

  /// Ambil app_instance_id yang tersimpan, atau buat sekali lalu simpan.
  String _appInstanceId() {
    var id = _prefs.getString(_kAppInstanceId);
    if (id == null || id.isEmpty) {
      id = _generateUuidV4();
      _prefs.setString(_kAppInstanceId, id);
    }
    return id;
  }

  String _generateUuidV4() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });
  }
}
