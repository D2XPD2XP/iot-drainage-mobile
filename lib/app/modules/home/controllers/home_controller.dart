import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/app_constants.dart';
import '../../../data/models/sensor_model.dart';
import '../../../data/providers/image_provider.dart';
import '../../../data/providers/sensor_provider.dart';
import '../../../services/websocket_service.dart';

class HomeController extends GetxController {
  final _imageProvider = Get.find<ImageProvider>();
  final _sensorProvider = Get.find<SensorProvider>();
  final _wsService = Get.find<WebSocketService>();

  final imageUrl = RxnString();
  final imageTimestamp = RxnString();
  final sensorStatus = RxnString();
  final sensorTimestamp = RxnString();
  final waterLevelCm = Rxn<num>();
  final rainDetected = RxnBool();
  final sensor = Rxn<SensorModel>();

  final isLoading = true.obs;

  StreamSubscription? _wsSub;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _wsSub = _wsService.stream.listen((_) {
      fetchSensor();
    });
  }

  /// Pemuatan data pertama saat layar dibuka. Menyalakan spinner hingga
  /// selesai (sukses maupun gagal), lalu mematikannya.
  Future<void> _loadInitialData() async {
    isLoading.value = true;
    try {
      await fetchSensor();
      await fetchImage();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _wsSub?.cancel();
    super.onClose();
  }

  Future<void> fetchSensor() async {
    try {
      final list = await _sensorProvider.getLatest(AppConstants.deviceId);
      if (list != null && list.isNotEmpty) {
        final latest = list.reduce(
          (a, b) =>
              DateTime.parse(a.timestamp!).isAfter(DateTime.parse(b.timestamp!))
              ? a
              : b,
        );
        sensor.value = latest;
        sensorStatus.value = latest.status;
        sensorTimestamp.value = _formatIsoTimestamp(latest.timestamp);
        waterLevelCm.value = latest.waterLevelCm;
        rainDetected.value = latest.rainDetected;
        await fetchImage();
      }
    } catch (e) {
      debugPrint('fetchSensor error: $e');
    }
  }

  Future<void> fetchImage() async {
    try {
      final image = await _imageProvider.getImage();
      imageUrl.value = image?.url;
      imageTimestamp.value = _formatTimestamp(image?.lastUpdated);
    } catch (e) {
      debugPrint('fetchImage error: $e');
    }
  }

  String? _formatIsoTimestamp(String? iso) {
    if (iso == null) return null;
    final dt = DateTime.parse(iso).toLocal();
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return 'Diperbarui ${dt.day} ${months[dt.month]} ${dt.year}, $hour.$minute';
  }

  String? _formatTimestamp(num? timestamp) {
    if (timestamp == null) return null;
    final ms = timestamp > 1e10 ? timestamp.toInt() : timestamp.toInt() * 1000;
    final dt = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return 'Diperbarui ${dt.day} ${months[dt.month]} ${dt.year}, $hour.$minute';
  }
}
