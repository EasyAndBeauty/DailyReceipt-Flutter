import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:daily_receipt/services/localization_service.dart';

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

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;

  const CancelButton({Key? key, required this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: tr.key45,
      iconPath: null,
      type: ButtonType.basic,
      textColor: color ?? Theme.of(context).colorScheme.secondary, // color 사용
      isBold: false,
      onPressed: onPressed,
    );
  }
}

class StopButton extends StatelessWidget {
  const StopButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: tr.key31,
      iconPath: null,
      type: ButtonType.danger,
      textColor: Theme.of(context).colorScheme.error,
      isBold: false,
      onPressed: onPressed,
    );
  }
}

class PauseButton extends StatelessWidget {
  const PauseButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: tr.key46,
      iconPath: null,
      type: ButtonType.basic,
      textColor: Theme.of(context).colorScheme.secondary,
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
      text: tr.key32,
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
      text: tr.key33,
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
      text: tr.key34,
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
      text: tr.key35,
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
            tr.key36,
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
      text: tr.key37,
      iconPath: null,
      type: ButtonType.basic,
      textColor: Theme.of(context).colorScheme.secondary,
      isBold: false,
      onPressed: onPressed,
      isLogout: true,
    );
  }
}

// Path: lib/widgets/todo_action_bottom_sheet.dart

class EditButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;

  const EditButton({Key? key, required this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: tr.key47,
      iconPath: null, // 아이콘 경로 추가
      type: ButtonType.basic,
      textColor: color ?? Theme.of(context).colorScheme.primary,
      isBold: true, // Edit 버튼을 강조
      onPressed: onPressed,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? color;

  const DeleteButton({Key? key, required this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      text: tr.key38,
      iconPath: null,
      type: ButtonType.danger, // Delete 버튼의 타입을 위험 표시로 변경
      textColor: color ?? Theme.of(context).colorScheme.error, // 기본 색상은 error
      isBold: true,
      onPressed: onPressed,
    );
  }
}
