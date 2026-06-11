import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeightCard extends StatelessWidget {
  final num heightCm;
  final String? status;

  const HeightCard({super.key, required this.heightCm, this.status});

  static const _normalGradient = [Color(0xFF1841D9), Color(0xFF0228B8)];
  static const _alertGradient = [Color(0xFFF64C4C), Color(0xFFFF3C3C)];
  static const _normalIcon = Color(0xFF1841D9);
  static const _alertIcon = Color(0xFFEC2D30);

  @override
  Widget build(BuildContext context) {
    final isNormal = status == 'NORMAL' || status == null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: isNormal ? 0.0 : 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, t, _) {
          final gradient = [Color.lerp(_normalGradient[0], _alertGradient[0], t)!, Color.lerp(_normalGradient[1], _alertGradient[1], t)!];
          final iconColor = Color.lerp(_normalIcon, _alertIcon, t)!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Tinggi Air',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF333333)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 32),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFEEEEEE)),
                    ),
                    child: Center(child: Image.asset('assets/images/symbol_water.png', width: 24, height: 24, color: iconColor)),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(bounds),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: _switchTransition,
                      child: Text(
                        heightCm.toStringAsFixed(0),
                        key: ValueKey(heightCm.toStringAsFixed(0)),
                        style: GoogleFonts.inter(fontSize: heightCm >= 100 ? 45 : 64, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'CM',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: iconColor),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _switchTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: Tween<double>(begin: 1.04, end: 1.0).animate(animation), child: child),
    );
  }
}
