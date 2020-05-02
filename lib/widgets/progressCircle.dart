import 'package:flutter/cupertino.dart';
import 'dart:math' as Math;

import 'package:flutter/material.dart';

class CircularProgress extends StatefulWidget {
  final Duration animationDuration;
  final Color backgroundColor;
  final Color foregroundColor;
  double value;  //Progress in percent Maybe as a function of Pages more easy
  String text;
  CircularProgress({
    Key key,
    @required this.animationDuration,
    @required this.backgroundColor,
    @required this.foregroundColor,
    @required int currentPage,
    @required int pages
  }
  ): super(key: key){
    text="$currentPage/$pages";
    value= currentPage/pages;
  }

  @override
  CircularProgressState createState() {
    return CircularProgressState();
  }
}

class CircularProgressState extends State<CircularProgress>
    with SingleTickerProviderStateMixin {
  // Used in tweens where a backgroundColor isn't given.
  static const TRANSPARENT = Color(0x00000000);
  AnimationController _controller;

  Animation<double> curve;
  Tween<double> valueTween;
  Tween<Color> backgroundColorTween;
  Tween<Color> foregroundColorTween;
  //!Animation are initialized
  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      duration: this.widget.animationDuration ?? const Duration(seconds: 1),
      vsync: this,
    );

    this.curve = CurvedAnimation(
      parent: this._controller,
      curve: Curves.easeInOut,
    );

    // Build the initial required tweens.
    this.valueTween = Tween<double>(
      begin: 0,
      end: this.widget.value,
    );

    this._controller.forward();
  }

//! If widget updated, let animation start at last location
  @override
  void didUpdateWidget(CircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.value != oldWidget.value) {
      // Try to start with the previous tween's end value. This ensures that we
      // have a smooth transition from where the previous animation reached.
      double beginValue =
          this.valueTween?.evaluate(this.curve) ?? oldWidget?.value ?? 0;

      // Update the value tween.
      this.valueTween = Tween<double>(
        begin: beginValue,
        end: this.widget.value ?? 1,
      );

      // Clear cached color tweens when the color hasn't changed.
      if (oldWidget?.backgroundColor != this.widget.backgroundColor) {
        this.backgroundColorTween = ColorTween(
          begin: oldWidget?.backgroundColor ?? TRANSPARENT,
          end: this.widget.backgroundColor ?? TRANSPARENT,
        );
      } else {
        this.backgroundColorTween = null;
      }

      if (oldWidget.foregroundColor != this.widget.foregroundColor) {
        this.foregroundColorTween = ColorTween(
          begin: oldWidget?.foregroundColor,
          end: this.widget.foregroundColor,
        );
      } else {
        this.foregroundColorTween = null;
      }

      this._controller
        ..value = 0
        ..forward();
    }
  }

//!Dispose the animator to prevent memory loss
  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: this.curve,
        child: Container(),
        builder: (context, child) {
          final backgroundColor =
              this.backgroundColorTween?.evaluate(this.curve) ??
                  this.widget.backgroundColor;
          final foregroundColor =
              this.foregroundColorTween?.evaluate(this.curve) ??
                  this.widget.foregroundColor;
          final text = widget.text;
          return CustomPaint(
            child: child,
            foregroundPainter: CircleProgressBarPainter(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              percentage: this.valueTween.evaluate(this.curve),
              text: text,
            ),
          );
        },
      ),
    );
  }
}

// Draws the progress bar.
class CircleProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  CircleProgressBarPainter({
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.percentage,
    double strokeWidth,
    this.text,
  }) : this.strokeWidth = strokeWidth ?? 25;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Size constrainedSize =
        size - Offset(this.strokeWidth, this.strokeWidth);
    final shortestSide =
        Math.min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = this.foregroundColor
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    final radius = (shortestSide / 2);

    // Start at the top. 0 radians represents the right edge
    final double startAngle = -(2 * Math.pi * 0.25);
    final double sweepAngle = (2 * Math.pi * (this.percentage ?? 0));

    // Don't draw the background if we don't have a background color
    if (this.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = this.backgroundColor
        ..strokeWidth = this.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
    TextSpan span = TextSpan(
        style: new TextStyle(
            color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
        text: text);
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textOff =
        Offset(center.dx - tp.width / 2, center.dy - tp.height / 2);
    tp.paint(canvas, textOff);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as CircleProgressBarPainter);
    return oldPainter.percentage != this.percentage ||
        oldPainter.backgroundColor != this.backgroundColor ||
        oldPainter.foregroundColor != this.foregroundColor ||
        oldPainter.strokeWidth != this.strokeWidth;
  }
}
