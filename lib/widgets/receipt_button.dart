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
      height: MediaQuery.of(context).size.height * 0.1, // 화면 높이에 비례한 크기
      child: ClipPath(
        clipper: ReceiptTopClipper(),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildTextOverlay(context),
            _buildInkWellOverlay(),
          ],
        ),
      ),
    );
  }

  // Helper method to build the background image
  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        'assets/paper_texture.webp',
        fit: BoxFit.cover,
      ),
    );
  }

  // Helper method to build the text overlay
  Widget _buildTextOverlay(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 15), // 텍스트를 15픽셀 아래로 이동
        child: Text(text, style: theme.textTheme.titleMedium),
      ),
    );
  }

  // Helper method to build the InkWell overlay for tap detection
  Widget _buildInkWellOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
        ),
      ),
    );
  }
}
