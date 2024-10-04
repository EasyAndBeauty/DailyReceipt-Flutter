import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const CustomSnackBar({
    Key? key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (buttonText != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton(
                onPressed: onButtonPressed,
                child: Text(
                  buttonText!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static void show(BuildContext context, String title, String message,
      {String? buttonText, VoidCallback? onButtonPressed}) {
    showAnimatedOverlay(
      context: context,
      builder: (BuildContext context, Animation<double> animation) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return AnimatedBuilder(
          animation: curvedAnimation,
          builder: (context, child) {
            return Positioned(
              bottom: (MediaQuery.of(context).size.height * 0.05) *
                  curvedAnimation.value,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              child: child!,
            );
          },
          child: CustomSnackBar(
            title: title,
            message: message,
            buttonText: buttonText,
            onButtonPressed: () {
              onButtonPressed?.call();
              Navigator.of(context).pop();
            },
          ),
        );
      },
      duration: const Duration(seconds: 4),
    );
  }
}

void showAnimatedOverlay({
  required BuildContext context,
  required Widget Function(BuildContext, Animation<double>) builder,
  required Duration duration,
}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _AnimatedOverlay(
          builder: builder,
          duration: duration,
          animation: animation,
        );
      },
    ),
  );
}

class _AnimatedOverlay extends StatefulWidget {
  final Widget Function(BuildContext, Animation<double>) builder;
  final Duration duration;
  final Animation<double> animation;

  const _AnimatedOverlay({
    Key? key,
    required this.builder,
    required this.duration,
    required this.animation,
  }) : super(key: key);

  @override
  _AnimatedOverlayState createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<_AnimatedOverlay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(context, widget.animation),
      ],
    );
  }
}
