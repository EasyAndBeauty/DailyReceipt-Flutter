import 'package:flutter/material.dart';

class ReceiptTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 20); // 시작점에서 아래로 20 픽셀 이동

    // 상단 톱니 모양 생성
    double x = 0;
    double y = 10;
    double increment = size.width / 40;

    while (x < size.width) {
      x += increment;
      y = y == 15 ? 20 : 15; // 톱니의 높이를 5픽셀로 조정
      path.lineTo(x, y);
    }

    // 오른쪽 끝에서 아래로 직선을 그어 마무리
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
