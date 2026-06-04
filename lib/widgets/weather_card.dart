import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cuaca',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFDEF2FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/symbol_rain.png',
                    width: 24,
                    height: 24,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF3FA5EB), Color(0xFF0A8AE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'Hujan',
              style: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
