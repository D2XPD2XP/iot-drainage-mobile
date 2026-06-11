import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iot_drainage/widgets/height_card.dart';
import 'package:iot_drainage/widgets/image_card.dart';
import 'package:iot_drainage/widgets/status_card.dart';
import 'package:iot_drainage/widgets/weather_card.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isNormal = controller.sensorStatus.value == 'NORMAL' || controller.sensorStatus.value == null;
        final targetColor = isNormal ? const Color(0xFF47B881) : const Color(0xFFF64C4C);

        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: targetColor),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 67, left: 19, right: 19),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => StatusCard(status: controller.sensorStatus.value, timestamp: controller.sensorTimestamp.value)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 198,
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() => HeightCard(heightCm: controller.waterLevelCm.value ?? 0, status: controller.sensorStatus.value)),
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: Obx(() => WeatherCard(rainDetected: controller.rainDetected.value ?? false))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 348,
                        child: Obx(() => ImageCard(imageUrl: controller.imageUrl.value, timestamp: controller.imageTimestamp.value)),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          builder: (context, color, child) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -1),
                      radius: 1.1,
                      colors: [color ?? targetColor, const Color(0xFFFBFEFC)],
                      stops: const [0.1, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    layoutBuilder: (currentChild, previousChildren) =>
                        Stack(fit: StackFit.passthrough, children: [...previousChildren, ?currentChild]),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: Tween<double>(begin: 1.04, end: 1.0).animate(animation), child: child),
                    ),
                    child: Image.asset(
                      isNormal ? 'assets/images/health_green.png' : 'assets/images/health_red.png',
                      key: ValueKey(isNormal),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
        );
      }),
    );
  }
}
