import 'receipt_top_clipper.dart';
import 'package:flutter/material.dart';

class ReceiptButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ReceiptButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100, // 버튼의 전체 높이
      child: ClipPath(
        clipper: ReceiptTopClipper(),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/paper_texture.webp',
                fit: BoxFit.cover,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                ),
                child: Center(
                    child: Padding(
                        padding:
                            const EdgeInsets.only(top: 15), // 텍스트를 10픽셀 아래로 이동
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )))),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
