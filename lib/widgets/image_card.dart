import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;

  const ImageCard({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    color: Color(0xFF1841D9),
                    size: 42,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
