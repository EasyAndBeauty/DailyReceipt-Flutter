import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ButtonType { basic, danger, disabled }

class TextButtonCustom extends StatelessWidget {
  final String text;
  final String? iconPath;
  final ButtonType type;
  final Color textColor;
  final bool isBold;
  final VoidCallback? onPressed;
  final bool isLogout;

  const TextButtonCustom({
    super.key,
    required this.text,
    this.iconPath,
    required this.type,
    required this.textColor,
    required this.isBold,
    required this.onPressed,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: type == ButtonType.disabled ? null : onPressed,
      child: isLogout
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (iconPath != null) ...[
                  SvgPicture.asset(
                    iconPath!,
                    color: textColor,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight:
                              isBold ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconPath != null) ...[
                  SvgPicture.asset(
                    iconPath!,
                    color: textColor,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight:
                            isBold ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ],
            ),
    );
  }
}

class StopButton extends StatelessWidget {
  const StopButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: 'Stop',
      iconPath: null,
      type: ButtonType.danger,
      textColor: Theme.of(context).colorScheme.error,
      isBold: false,
      onPressed: onPressed,
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: 'Play',
      iconPath: null,
      type: ButtonType.basic,
      textColor: Theme.of(context).colorScheme.onPrimary,
      isBold: false,
      onPressed: onPressed,
    );
  }
}

class CopyButton extends StatelessWidget {
  const CopyButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: 'COPY',
      iconPath: 'assets/icons/copy.svg',
      type: ButtonType.basic,
      textColor: Theme.of(context).colorScheme.secondary,
      isBold: false,
      onPressed: onPressed,
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: 'SAVE',
      iconPath: 'assets/icons/save.svg',
      type: ButtonType.basic,
      textColor: Theme.of(context).colorScheme.secondary,
      isBold: false,
      onPressed: onPressed,
    );
  }
}

class PinButton extends StatelessWidget {
  const PinButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: 'PIN',
      iconPath: 'assets/icons/pin.svg',
      type: ButtonType.basic,
      textColor: Theme.of(context).colorScheme.secondary,
      isBold: false,
      onPressed: onPressed,
    );
  }
}

class ChangeNickNameButton extends StatelessWidget {
  const ChangeNickNameButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Change My NickName',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.normal,
                ),
          ),
          SvgPicture.asset(
            'assets/icons/arrow.svg',
            color: Theme.of(context).colorScheme.onPrimary,
            height: 16,
            width: 16,
          ),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: 'Logout',
      iconPath: null,
      type: ButtonType.basic,
      textColor: Theme.of(context).colorScheme.secondary,
      isBold: false,
      onPressed: onPressed,
      isLogout: true,
    );
  }
}
