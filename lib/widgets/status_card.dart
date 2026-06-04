import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 19, left: 21, right: 41, bottom: 19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1841D9), Color(0xFF0228B8)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aman',
            style: GoogleFonts.inter(
              fontSize: 45,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tidak ada peningkatan air yang signifikan',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
