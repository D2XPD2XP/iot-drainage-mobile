import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeightCard extends StatelessWidget {
  final double heightCm;

  const HeightCard({super.key, required this.heightCm});

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
              Expanded(
                child: Text(
                  'Tinggi Air',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 32),
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFD2E1FF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/symbol_water.png',
                    width: 24,
                    height: 24,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF1841D9), Color(0xFF0228B8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  heightCm.toStringAsFixed(0),
                  style: GoogleFonts.inter(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'CM',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1841D9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
