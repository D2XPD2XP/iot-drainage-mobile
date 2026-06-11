import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageCard extends StatelessWidget {
  final String? imageUrl;
  final String? timestamp;
  final VoidCallback? onTap;

  const ImageCard({super.key, this.imageUrl, this.timestamp, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) => Stack(fit: StackFit.expand, children: [...previousChildren, ?currentChild]),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: _buildImage(),
          ),
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  timestamp ?? '',
                  key: ValueKey(timestamp),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onTap ?? () => _openFullscreen(context),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(color: Colors.white60, shape: BoxShape.circle),
                  child: Center(child: Image.asset("assets/images/symbol_expand.png")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, _) => FadeTransition(
          opacity: animation,
          child: _FullscreenImageViewer(imageUrl: imageUrl!, timestamp: timestamp),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(key: const ValueKey('placeholder'), color: Colors.grey.shade300);
    }
    return Image.network(
      imageUrl!,
      key: ValueKey(imageUrl),
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return AnimatedOpacity(opacity: 1.0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut, child: child);
        }
        return AnimatedOpacity(opacity: frame == null ? 0.0 : 1.0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut, child: child);
      },
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(color: Colors.grey.shade300);
      },
      errorBuilder: (_, _, _) => Container(color: Colors.grey.shade400),
    );
  }
}

class _FullscreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? timestamp;

  const _FullscreenImageViewer({required this.imageUrl, this.timestamp});

  @override
  State<_FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<_FullscreenImageViewer> with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_controller.value != Matrix4.identity()) {
      // Reset to original size.
      _controller.value = Matrix4.identity();
    } else {
      // Zoom in towards the tapped position.
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      _controller.value = Matrix4.identity()
        ..translateByDouble(-position.dx * 1.5, -position.dy * 1.5, 0, 1)
        ..scaleByDouble(2.5, 2.5, 2.5, 1);
    }
    setState(() {}); // Trigger rebuild to update the UI based on the new transformation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) => _doubleTapDetails = details,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _controller,
              minScale: 1.0,
              maxScale: 5.0,
              child: Center(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  },
                  errorBuilder: (_, _, _) => const Center(child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64)),
                ),
              ),
            ),
          ),
          if (widget.timestamp != null && widget.timestamp!.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.timestamp!,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              style: IconButton.styleFrom(backgroundColor: Colors.white24),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 40,
            left: MediaQuery.of(context).size.width / 2 - 85,
            child: Text(
              'Tip: Pinch to zoom, double tap to ${_controller.value != Matrix4.identity() ? 'reset' : 'zoom in'}',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 8, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
