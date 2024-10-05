import 'package:flutter/material.dart';
import 'dart:async';

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
          top: 0,
          right: 0,
          child: _buildCloseButton(context),
        ),
      ],
    );
  }

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

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      iconSize: 18,
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () {
        SnackBarManager.instance.hideSnackBar();
      },
    );
  }

  BoxDecoration _buildBoxDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
    );
  }

  static void show(
    BuildContext context,
    String title,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    SnackBarManager.instance.showSnackBar(
      context,
      CustomSnackBar(title: title, message: message),
      duration: duration,
    );
  }
}

class SnackBarManager {
  SnackBarManager._();
  static final SnackBarManager instance = SnackBarManager._();

  OverlayEntry? _currentEntry;
  Timer? _timer;

  void showSnackBar(
    BuildContext context,
    Widget snackBar, {
    Duration duration = const Duration(seconds: 4),
  }) {
    hideSnackBar(); // Hide any existing snackbar

    _currentEntry = OverlayEntry(
      builder: (BuildContext context) => _AnimatedSnackBar(
        duration: duration,
        onDismiss: hideSnackBar,
        child: snackBar,
      ),
    );

    Overlay.of(context).insert(_currentEntry!);

    _timer = Timer(duration, () {
      hideSnackBar();
    });
  }

  void hideSnackBar() {
    _timer?.cancel();
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _AnimatedSnackBar extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onDismiss;

  const _AnimatedSnackBar({
    Key? key,
    required this.child,
    required this.duration,
    required this.onDismiss,
  }) : super(key: key);

  @override
  _AnimatedSnackBarState createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();

    Future.delayed(widget.duration - const Duration(milliseconds: 300), () {
      if (!_isDisposed) {
        _startHideAnimation();
      }
    });
  }

  void _startHideAnimation() {
    _controller.reverse().then((_) {
      if (!_isDisposed) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05 * _animation.value,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
