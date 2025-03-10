import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final String svgPath;
  final VoidCallback? onPressed;

  const IconTextButton({
    super.key,
    required this.text,
    required this.svgPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            // TODO: theme.dart에 있는 색으로 지정하기
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
