import 'package:flutter/material.dart';
import 'dart:math' as math;

class LineChartWidget extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final bool isCurrency;

  const LineChartWidget({
    Key? key,
    required this.data,
    required this.labels,
    required this.color,
    this.isCurrency = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _LineChartPainter(
                data: data,
                labels: labels,
                color: color,
                isCurrency: isCurrency,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: labels.map((label) => Text(label)).toList(),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final bool isCurrency;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.isCurrency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double maxValue = data.reduce(math.max);
    final double minValue = data.reduce(math.min);

    // Draw axes
    final Paint axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(0, height),
      Offset(width, height),
      axisPaint,
    );

    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, height),
      axisPaint,
    );

    // Draw data points and lines
    final Paint linePaint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;

    final path = Path();
    final double xStep = width / (data.length - 1);

    // Calculate normalized Y values
    final double range = maxValue - minValue;
    final List<double> normalizedY = data.map((value) {
      if (range == 0) return height / 2; // Handle flat line
      return height - ((value - minValue) / range * height);
    }).toList();

    // Draw the line
    path.moveTo(0, normalizedY[0]);
    for (int i = 1; i < data.length; i++) {
      path.lineTo(i * xStep, normalizedY[i]);
    }
    canvas.drawPath(path, linePaint);

    // Draw points
    for (int i = 0; i < data.length; i++) {
      canvas.drawCircle(
        Offset(i * xStep, normalizedY[i]),
        5,
        pointPaint,
      );
    }

    // Draw value labels
    final textStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 12,
    );

    for (int i = 0; i < data.length; i++) {
      final textSpan = TextSpan(
        text: isCurrency
            ? '₹${data[i].toStringAsFixed(1)}L'
            : '${data[i].toStringAsFixed(1)}%',
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(i * xStep - textPainter.width / 2, normalizedY[i] - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BarChartWidget extends StatelessWidget {
  final List<dynamic> data;
  final List<String> labels;
  final Color color;
  final bool isPercentage;

  const BarChartWidget({
    Key? key,
    required this.data,
    required this.labels,
    required this.color,
    this.isPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        size: Size.infinite,
        painter: _BarChartPainter(
          data: data.map<double>((e) => e.toDouble()).toList(),
          labels: labels,
          color: color,
          isPercentage: isPercentage,
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final bool isPercentage;

  _BarChartPainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.isPercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height - 30; // Leave space for labels
    final double maxValue = data.reduce(math.max);

    // Draw axes
    final Paint axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(0, height),
      Offset(width, height),
      axisPaint,
    );

    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, height),
      axisPaint,
    );

    // Draw bars and labels
    final double barWidth = width / (data.length * 2);
    final double spacing = barWidth;

    for (int i = 0; i < data.length; i++) {
      final double barHeight = (data[i] / maxValue) * height;
      final double barX = (i * 2 + 1) * barWidth;

      // Draw bar
      final Paint barPaint = Paint()
        ..color = color.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final Rect barRect = Rect.fromLTWH(
        barX,
        height - barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRect(barRect, barPaint);

      // Draw value label
      final textSpan = TextSpan(
        text: isPercentage
            ? '${data[i].toStringAsFixed(1)}%'
            : data[i].toStringAsFixed(0),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(barX + barWidth / 2 - textPainter.width / 2,
            height - barHeight - 20),
      );

      // Draw x-axis label
      final labelSpan = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
        ),
      );

      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
      );

      labelPainter.layout();

      // Rotate the canvas to draw vertical text
      canvas.save();
      canvas.translate(barX + barWidth / 2, height + 5);
      canvas.rotate(math.pi / 4); // Rotate 45 degrees

      labelPainter.paint(
        canvas,
        const Offset(0, 0),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PieChartWidget extends StatelessWidget {
  final List<int> data;
  final List<String> labels;
  final List<Color> colors;

  const PieChartWidget({
    Key? key,
    required this.data,
    required this.labels,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomPaint(
            size: const Size(200, 200),
            painter: _PieChartPainter(
              data: data,
              colors: colors,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                data.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: colors[index],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          labels[index],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        '${data[index]} (${(data[index] / data.reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<int> data;
  final List<Color> colors;

  _PieChartPainter({
    required this.data,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final total = data.reduce((a, b) => a + b).toDouble();
    double startAngle = -math.pi / 2; // Start from the top

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 2 * math.pi;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center circle (optional, creates a donut chart)
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius * 0.5, // Inner radius
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
