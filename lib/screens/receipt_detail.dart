import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/receipt.dart';
import 'package:daily_receipt/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:pasteboard/pasteboard.dart';
import 'dart:ui' as ui;

class ReceiptDetailScreen extends StatelessWidget {
  final DateTime selectedDate;
  final List<Todo> todos;
  final GlobalKey receiptKey = GlobalKey();

  ReceiptDetailScreen({
    Key? key,
    required this.selectedDate,
    required this.todos,
  }) : super(key: key);

  Future<Uint8List> _captureReceiptImage() async {
    try {
      RenderRepaintBoundary boundary = receiptKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print('Error capturing receipt image: $e');
      rethrow;
    }
  }

  Future<void> _copyReceiptToClipboard(BuildContext context) async {
    try {
      Uint8List imageBytes = await _captureReceiptImage();

      // pasteboard 패키지를 사용하여 이미지를 클립보드에 복사
      await Pasteboard.writeImage(imageBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('영수증 이미지가 클립보드에 복사되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('영수증 복사 중 오류가 발생했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF757575),
                    size: 24,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: receiptKey,
                  child: ReceiptComponent(
                    todos,
                    selectedDate,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(22),
              height: 100,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButtonCustom(
                      text: 'Copy',
                      iconPath: 'assets/icons/copy.svg',
                      type: ButtonType.basic,
                      textColor: const Color(0xFF757575),
                      isBold: false,
                      onPressed: () => _copyReceiptToClipboard(context),
                    ),
                    TextButtonCustom(
                      text: 'Share',
                      iconPath: 'assets/icons/pin.svg',
                      type: ButtonType.basic,
                      textColor: const Color(0xFF757575),
                      isBold: false,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('공유 기능은 아직 구현되지 않았습니다.')),
                        );
                      },
                    ),
                    TextButtonCustom(
                      text: 'Save',
                      iconPath: 'assets/icons/save.svg',
                      type: ButtonType.basic,
                      textColor: const Color(0xFF757575),
                      isBold: false,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('저장 기능은 아직 구현되지 않았습니다.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
