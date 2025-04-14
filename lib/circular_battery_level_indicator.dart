import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircularBatteryLevelIndicator extends StatefulWidget {
  const CircularBatteryLevelIndicator({
    super.key,
    required this.level,
    required this.isCharging,
  });
  final int level;
  final bool isCharging;
  @override
  State<CircularBatteryLevelIndicator> createState() =>
      _CircularBatteryLevelIndicatorState();
}

class _CircularBatteryLevelIndicatorState
    extends State<CircularBatteryLevelIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Animation duration
      vsync: this,
    )..repeat(reverse: true); // Repeat animation, reversing direction

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.yellowAccent,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Apply an easing curve
      ),
    )..addListener(() {
      setState(() {});
    });
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircularBttLevelIndicatorPainter(
        isCharging: widget.isCharging,
        level: widget.level,
        context: context,
        chargingColor: _colorAnimation.value!,
      ),
      size: Size.infinite,
    );
  }
}

class CircularBttLevelIndicatorPainter extends CustomPainter {
  final bool isCharging;
  final int level;
  final BuildContext context;
  final Color chargingColor;
  CircularBttLevelIndicatorPainter({
    required this.isCharging,
    required this.level,
    required this.context,
    required this.chargingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const lineWidth = 4.0;
    final height = size.height;
    final width = size.width;
    const double inset = lineWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      width - 2 * inset,
      height - 2 * inset,
    );
    final dx = width / 2;
    final dy = height / 2;
    const chargingColor = Colors.amber;
    final batteryUsageTxt = "BATTERY";
    final bttChargingTxt = "BATTERY\nCHARGING";
    const lowBttLevelTxt = 'LOW BATTERY';
    const warningIcon = Icons.warning_amber;
    const boltIcon = Icons.bolt;
    final bttLevelTxt = '${level * 25}%';

    canvas.drawCircle(
      Offset(dx, dy),
      math.min(dy - 2, dy - 2),
      Paint()
        ..style = PaintingStyle.fill
        ..color = Color.fromRGBO(25, 25, 25, 1.0),
    );

    // Total sweep angle per arc (leaving a gap)
    const double totalSweep = (math.pi / 2) - 0.2; // 90° - small gap

    // Total sweep angle per arc (leaving a gap centered on cardinal points)
    const double gapAngle = 0.25; // Gap size in radians (~11.5 degrees)
    const double arcSweep =
        (math.pi / 2) - gapAngle; // Each arc sweeps slightly less than 90°

    // Start angles for arcs between cardinal directions
    //Q1 (25%)
    Paint arcPaint =
        Paint()
          ..color = getColorFor(
            segment: LevelSegments.q1,
            power: level,
            isCharging: isCharging,
          )
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth;
    canvas.drawArc(
      rect,
      (3 * math.pi / 2) + gapAngle / 2,
      arcSweep,
      false,
      arcPaint,
    );
    //Q2 (50%)
    arcPaint.color = getColorFor(
      segment: LevelSegments.q2,
      power: level,
      isCharging: isCharging,
    );
    canvas.drawArc(rect, gapAngle / 2, arcSweep, false, arcPaint);
    //Q3 (75%)
    arcPaint.color = getColorFor(
      segment: LevelSegments.q3,
      power: level,
      isCharging: isCharging,
    );
    canvas.drawArc(
      rect,
      (math.pi / 2) + gapAngle / 2,
      arcSweep,
      false,
      arcPaint,
    );
    //Q4 (100%)
    arcPaint.color = getColorFor(
      segment: LevelSegments.q4,
      power: level,
      isCharging: isCharging,
    );
    canvas.drawArc(rect, math.pi + gapAngle / 2, arcSweep, false, arcPaint);
    if (isCharging) {
      drawBoltIcon(boltIcon, canvas, dx, dy);
      drawBttStateText(canvas, bttChargingTxt, Offset(dx, dy));
    } else if (level == 1) {
      drawWarningIcon(warningIcon, Colors.red, canvas, dx, dy);
      drawBttStateText(canvas, lowBttLevelTxt, Offset(dx, dy));
    } else {
      drawBttStateText(canvas, batteryUsageTxt, Offset(dx, dy));
    }
    //draw btt level %
    drawBttLevelText(canvas, bttLevelTxt, Offset(dx, dy));
  }

  void drawWarningIcon(
    IconData warningIcon,
    Color lowChargeColor,
    Canvas canvas,
    double dx,
    double dy,
  ) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    final String warningGlyph = String.fromCharCode(warningIcon.codePoint);
    textPainter.text = TextSpan(
      text: warningGlyph,
      style: TextStyle(
        fontSize: 24,
        fontFamily: warningIcon.fontFamily,
        color: lowChargeColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(dx - textPainter.width / 2, dy / 2.5 - textPainter.height / 2),
    );
  }

  void drawBoltIcon(IconData boltIcon, Canvas canvas, double dx, double dy) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    final String warningGlyph = String.fromCharCode(boltIcon.codePoint);
    textPainter.text = TextSpan(
      text: warningGlyph,
      style: TextStyle(
        fontSize: 24,
        fontFamily: boltIcon.fontFamily,
        color: Colors.yellowAccent,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(dx - textPainter.width / 2, dy / 2.5 - textPainter.height / 2),
    );
  }

  void drawBttStateText(Canvas canvas, String bttLevelTxt, Offset offSet) {
    final levelTextSpan = TextSpan(
      text: bttLevelTxt,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'GothicA1',
        color: Colors.white70,
        fontStyle: FontStyle.normal,
        fontSize: 9.9,
      ),
    );
    final levelTextPainter = TextPainter(
      text: levelTextSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    levelTextPainter.layout();
    final textOffset = Offset(
      offSet.dx - levelTextPainter.width / 2,
      offSet.dy + (offSet.dy / 2.5) + 4 - levelTextPainter.height / 2,
    );
    levelTextPainter.paint(canvas, textOffset);
  }

  void drawBttLevelText(Canvas canvas, String bttLevelTxt, Offset offSet) {
    final levelTextSpan = TextSpan(
      text: bttLevelTxt,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontFamily: 'GothicA1',
        fontSize: 35,
        fontStyle: FontStyle.normal,
      ),
    );
    final levelTextPainter = TextPainter(
      text: levelTextSpan,
      textDirection: TextDirection.ltr,
    );
    levelTextPainter.layout();
    final textOffset = Offset(
      offSet.dx - levelTextPainter.width / 2,
      offSet.dy - levelTextPainter.height / 2,
    );
    levelTextPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Color getColorFor({
    required LevelSegments segment,
    required int power,
    required bool isCharging,
  }) {
    if (isCharging) {
      return getChargingColorFor(segment: segment, power: power);
    } else {
      return getInUseColorFor(segment: segment, power: power);
    }
  }

  Color getChargingColorFor({
    required LevelSegments segment,
    required int power,
  }) {
    // full / empty / charging
    if (segment.value < power) {
      return Colors.yellowAccent;
    } else if (segment.value == power) {
      return chargingColor;
    } else {
      return Color.fromRGBO(102, 102, 102, 1.0);
    }
  }

  Color getInUseColorFor({required LevelSegments segment, required int power}) {
    // full / empty / low power
    if (segment == LevelSegments.q1 && power == segment.value) {
      return Colors.red;
    } else if (segment.value > power) {
      return Color.fromRGBO(102, 102, 102, 1.0);
    } else {
      // return chargingColor;
      return Color.fromRGBO(27, 166, 56, 1.0);
    }
  }
}

enum LevelSegments {
  q1(1),
  q2(2),
  q3(3),
  q4(4);

  final int value;
  const LevelSegments(this.value);
}
