import 'package:flutter/material.dart';

class StatusAwareHalo extends StatefulWidget {
  final Widget child;
  final double radius;
  final bool status;

  const StatusAwareHalo({super.key, required this.child, required this.status, this.radius = 65.0});

  @override
  State<StatusAwareHalo> createState() => _StatusAwareHaloState();
}

class _StatusAwareHaloState extends State<StatusAwareHalo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Durasi 2.5 detik untuk efek berdenyut yang natural
    _controller = AnimationController(duration: const Duration(milliseconds: 2500), vsync: this)
      ..repeat(reverse: true); // reverse: true membuat animasi bolak-balik (pulse)

    // Animasi untuk ukuran blur dan spread agar terasa seperti bernapas
    _glowAnimation = Tween<double>(begin: 10.0, end: 28.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fungsi untuk mendapatkan range warna berdasarkan status
  Color _getStatusColor(bool status, double animationValue) {
    if (status) {
      // Seputaran Hijau: sedikit variasi hue agar tetap ada efek dinamis/RGB halus
      final double hue = 110 + (animationValue * 20); // Range: 110 - 130
      return HSVColor.fromAHSV(1.0, hue, 0.8, 1.0).toColor();
    } else {
      // Seputaran Merah
      final double hue = 0 + (animationValue * 12); // Range: 0 - 12
      return HSVColor.fromAHSV(1.0, hue, 0.9, 1.0).toColor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final Color baseColor = _getStatusColor(widget.status, _controller.value);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Layer Glow Status
            Container(
              width: widget.radius,
              height: widget.radius,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: baseColor.withOpacity(0.45), // Soft opacity
                    blurRadius: _glowAnimation.value, // Blur yang membesar-mengecil
                    spreadRadius: _glowAnimation.value * 0.1, // Spread ikut berdenyut halus
                  ),
                ],
              ),
            ),
            // Layer Logo
            widget.child,
          ],
        );
      },
    );
  }
}
