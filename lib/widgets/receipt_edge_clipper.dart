import 'package:flutter/material.dart';

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const wavelength = 10.0;
    const amplitude = 5.0;

    // 상단 톱니
    path.moveTo(0, amplitude);
    for (var i = 0; i < size.width / wavelength; i++) {
      path.lineTo((i + 0.5) * wavelength, 0);
      path.lineTo((i + 1) * wavelength, amplitude);
    }

    // 오른쪽 변
    path.lineTo(size.width, size.height - amplitude);

    // 하단 톱니
    for (var i = size.width / wavelength; i > 0; i--) {
      path.lineTo((i - 0.5) * wavelength, size.height);
      path.lineTo((i - 1) * wavelength, size.height - amplitude);
    }

    // 왼쪽 변
    path.lineTo(0, amplitude);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
