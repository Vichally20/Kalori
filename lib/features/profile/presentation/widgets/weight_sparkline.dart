import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kalori/core/theme/app_theme.dart';

/// Small line chart of weights (oldest → newest) with a dot on the latest value.
class WeightSparkline extends StatelessWidget {
  final List<double> values;
  final double width;
  final double height;

  const WeightSparkline({super.key, required this.values, this.width = 110.0, this.height = 56.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _SparklinePainter(values)),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;

  const _SparklinePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }
    final lo = values.reduce(math.min);
    final hi = values.reduce(math.max);
    final range = (hi - lo).abs() < 0.001 ? 1.0 : hi - lo;
    const pad = 6.0;
    final h = size.height - 10.0;
    Offset at(int i) {
      final x = pad + (size.width - pad * 2) * (values.length == 1 ? 1 : i / (values.length - 1));
      final y = pad + (h - pad) * (1 - (values[i] - lo) / range);
      return Offset(x, y);
    }

    canvas.drawLine(
      Offset(0, size.height - 2),
      Offset(size.width, size.height - 2),
      Paint()
        ..color = KaloriColors.borderSlate
        ..strokeWidth = 1,
    );
    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(at(i).dx, at(i).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = KaloriColors.successGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(at(values.length - 1), 4.0, Paint()..color = KaloriColors.successGreen);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) => old.values != values;
}
