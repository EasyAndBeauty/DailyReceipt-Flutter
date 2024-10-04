import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String title;
  final String message;

  const CustomSnackBar({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _buildBoxDecoration(theme),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextContent(theme),
              ),
            ],
          ),
        ),
        Positioned(
          // 우상단에 X 버튼을 배치
          top: 0,
          right: 0,
          child: _buildCloseButton(context),
        ),
      ],
    );
  }

  // Helper method to build the title and message using theme
  Column _buildTextContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: theme.textTheme.titleSmall?.copyWith(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Helper method to build the close (X) button, 작게 만들기
  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      iconSize: 18, // X 버튼 크기를 작게 설정
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () {
        Navigator.of(context).pop(); // X 버튼을 누르면 항상 닫힘
      },
    );
  }

  // Helper method to build box decoration using theme
  BoxDecoration _buildBoxDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface, // Background color from theme
      borderRadius: BorderRadius.circular(8),
    );
  }

  // Static method to show snackbar with animation
  static void show(
    BuildContext context,
    String title,
    String message,
  ) {
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
            return _buildPositionedSnackBar(context, curvedAnimation, child!);
          },
          child: CustomSnackBar(
            title: title,
            message: message,
          ),
        );
      },
      duration: const Duration(seconds: 4),
    );
  }

  // Helper method to build positioned snackbar
  static Positioned _buildPositionedSnackBar(
      BuildContext context, Animation<double> curvedAnimation, Widget child) {
    return Positioned(
      bottom:
          (MediaQuery.of(context).size.height * 0.05) * curvedAnimation.value,
      left: MediaQuery.of(context).size.width * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      child: child,
    );
  }
}

// Method to show overlay with animation
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

// Animated overlay widget
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(context, widget.animation),
      ],
    );
  }
}
