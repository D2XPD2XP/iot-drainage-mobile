import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/services/fcm_service.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, s) {
      debugPrint('Firebase init gagal: $e\n$s');
    }

    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "IoTDrainage",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );

    unawaited(
      Get.putAsync(() => FcmService().init())
          .timeout(const Duration(seconds: 15))
          .catchError((Object e) {
        debugPrint('FCM init gagal/lambat: $e');
        return Get.find<FcmService>();
      }),
    );
  }, (error, stack) {
    debugPrint('Uncaught zone error: $error\n$stack');
  });
}
