import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iot_drainage/widgets/height_card.dart';
import 'package:iot_drainage/widgets/image_card.dart';
import 'package:iot_drainage/widgets/power_indicator.dart';
import 'package:iot_drainage/widgets/status_card.dart';
import 'package:iot_drainage/widgets/weather_card.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE6ECFF), Color(0xFFFEFFF4)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 67, left: 19, right: 19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kondisi Terkini',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 36,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      children: const [
                        Expanded(child: StatusCard()),
                        SizedBox(width: 6),
                        PowerIndicator(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 198,
                      child: Row(
                        children: const [
                          Expanded(child: HeightCard(heightCm: 30)),
                          SizedBox(width: 6),
                          Expanded(child: WeatherCard()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 19, right: 19, bottom: 32),
              sliver: SliverList.builder(
                itemCount: 1,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 238,
                    child: ImageCard(
                      imagePath: "assets/images/sample_river.jpg",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
