import 'package:flutter/material.dart';

class RecordWave extends CustomPainter {
  final List<int> amplitudes;
  final double strokeWidth;
  final Color color;

  RecordWave({
    required this.amplitudes,
    this.strokeWidth = 1.0,
    this.color = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < amplitudes.length; i++) {
      final double normX = i / amplitudes.length * size.width;
      final double normY = amplitudes[i] / 32768 * size.height / 2;

      if (i == 0) {
        path.moveTo(normX, normY);
      } else {
        path.lineTo(normX, normY);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RecordWave oldDelegate) {
    return oldDelegate.amplitudes != amplitudes;
  }
}
