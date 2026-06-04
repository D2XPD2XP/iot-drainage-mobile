import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PowerIndicator extends StatelessWidget {
  const PowerIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/symbol_sensor.png',
                width: 28,
                height: 28,
                color: const Color(0xFF16A34A),
              ),
            ),
          ),
          const SizedBox(height: 34),
          Text(
            'ON',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }
}
