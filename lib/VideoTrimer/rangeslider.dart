import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomRangeThumbShape extends SliderComponentShape {
  final ui.Image image;

  CustomRangeThumbShape(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value}) {
    final canvas = context.canvas;
    final imageWidth = image?.width ?? 10;
    final imageHeight = image?.height ?? 10;

    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    if (image != null) {
      canvas.drawImage(image, imageOffset, paint);
    }
  }
}

Path _rangePointer(double size, Offset thumbCenter) {
  final Path thumbPath = Path();
  thumbPath
      .addRect(Rect.fromCenter(center: thumbCenter, width: 15.0, height: 30.0));
  thumbPath.close();
  return thumbPath;
}
