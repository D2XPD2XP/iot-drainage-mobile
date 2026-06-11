import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/status_aware_halo.dart';

class StatusCard extends StatelessWidget {
  final String? status;
  final String? timestamp;

  const StatusCard({super.key, this.status, this.timestamp});

  bool get _isNormal => status == null || status == 'NORMAL';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 19, left: 21, right: 21, bottom: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.white70, Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isNormal ? 'Kondisi Aman' : 'Perlu Perhatian',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: _isNormal ? const Color(0xFF0C9D61) : const Color(0xFFEC2D30),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timestamp ?? '-',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF8E8E8E)),
                    ),
                  ],
                ),
              ),
              StatusAwareHalo(status: _isNormal, child: Image.asset('assets/images/logo_pondokdiaz.png')),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _isNormal
                ? 'Ketinggian air masih dalam batas normal dan belum menunjukkan potensi risiko'
                : 'Ketinggian air meningkat, harap pantau kondisi di sekitar secara berkala',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
