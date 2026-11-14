import 'package:flutter/material.dart';

/// Darkens the camera everywhere except the scan [frame] and draws its four
/// corner brackets. The corners turn green once a barcode is found.
/// The barcode frame keeps the defaults; the carton QR frame is bigger.
class ScannerOverlay extends StatelessWidget {
  final Rect frame;
  final Color cornerColor;
  final double radius;
  final double cornerLength;
  final double cornerStroke;

  const ScannerOverlay({
    super.key,
    required this.frame,
    required this.cornerColor,
    this.radius = 16,
    this.cornerLength = 36,
    this.cornerStroke = 4,
  });

  @override
  Widget build(BuildContext context) {
    // IgnorePointer: the overlay is only a drawing, taps go through it.
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ScannerOverlayPainter(
          frame: frame,
          cornerColor: cornerColor,
          radius: radius,
          cornerLength: cornerLength,
          cornerStroke: cornerStroke,
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final Rect frame;
  final Color cornerColor;
  final double radius;
  final double cornerLength;
  final double cornerStroke;

  _ScannerOverlayPainter({
    required this.frame,
    required this.cornerColor,
    required this.radius,
    required this.cornerLength,
    required this.cornerStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // The whole screen plus the frame as one path. With evenOdd, the area
    // covered twice (the frame) is left empty, so it becomes a clear window.
    final dim = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(frame, Radius.circular(radius)));
    canvas.drawPath(dim, Paint()..color = Colors.black.withValues(alpha: 0.58));

    final cornerPaint = Paint()
      ..color = cornerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerStroke
      ..strokeCap = StrokeCap.round;

    final r = radius;
    final l = cornerLength;
    final arc = Radius.circular(radius);
    final left = frame.left;
    final top = frame.top;
    final right = frame.right;
    final bottom = frame.bottom;

    final corners = Path()
      // top left
      ..moveTo(left, top + l)
      ..lineTo(left, top + r)
      ..arcToPoint(Offset(left + r, top), radius: arc)
      ..lineTo(left + l, top)
      // top right
      ..moveTo(right - l, top)
      ..lineTo(right - r, top)
      ..arcToPoint(Offset(right, top + r), radius: arc)
      ..lineTo(right, top + l)
      // bottom right
      ..moveTo(right, bottom - l)
      ..lineTo(right, bottom - r)
      ..arcToPoint(Offset(right - r, bottom), radius: arc)
      ..lineTo(right - l, bottom)
      // bottom left
      ..moveTo(left + l, bottom)
      ..lineTo(left + r, bottom)
      ..arcToPoint(Offset(left, bottom - r), radius: arc)
      ..lineTo(left, bottom - l);

    canvas.drawPath(corners, cornerPaint);
  }

  @override
  bool shouldRepaint(_ScannerOverlayPainter oldDelegate) =>
      oldDelegate.frame != frame ||
      oldDelegate.cornerColor != cornerColor ||
      oldDelegate.radius != radius ||
      oldDelegate.cornerLength != cornerLength ||
      oldDelegate.cornerStroke != cornerStroke;
}
