import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/receipt.dart';
import 'package:daily_receipt/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;

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

      await Pasteboard.writeImage(imageBytes);

      _showCustomDialog(context, '성공', '영수증 이미지가 클립보드에 복사되었습니다.');
    } catch (e) {
      _showCustomDialog(context, '오류', '영수증 복사 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> _shareReceipt(BuildContext context) async {
    try {
      Uint8List imageBytes = await _captureReceiptImage();

      if (kIsWeb) {
        // Web 환경에서의 공유 로직
        final result = await Share.shareXFiles([
          XFile.fromData(imageBytes, mimeType: 'image/png', name: 'receipt.png')
        ], text: '내 일일 영수증');

        if (result.status == ShareResultStatus.dismissed) {
          _showCustomDialog(context, '알림', '영수증 공유가 취소되었습니다. 다시 시도해보시겠습니까?');
        } else {
          _showCustomDialog(context, '성공', '영수증 이미지가 성공적으로 공유되었습니다.');
        }
      } else {
        // 모바일 환경에서의 공유 로직
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        final result =
            await Share.shareXFiles([XFile(imagePath)], text: '내 일일 영수증');

        if (result.status == ShareResultStatus.dismissed) {
          _showCustomDialog(context, '알림', '영수증 공유가 취소되었습니다. 다시 시도해보시겠습니까?');
        } else {
          _showCustomDialog(context, '성공', '영수증 이미지가 성공적으로 공유되었습니다.');
        }

        // 임시 파일 삭제
        await imageFile.delete();
      }
    } catch (e) {
      _showCustomDialog(context, '오류', '영수증 공유 중 오류가 발생했습니다: $e');
    }
  }

  void _showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 5,
        );
      },
    );
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
                      iconPath: 'assets/icons/save.svg',
                      type: ButtonType.basic,
                      textColor: const Color(0xFF757575),
                      isBold: false,
                      onPressed: () => _shareReceipt(context),
                    ),
                    TextButtonCustom(
                      text: 'Save',
                      iconPath: 'assets/icons/save.svg',
                      type: ButtonType.basic,
                      textColor: const Color(0xFF757575),
                      isBold: false,
                      onPressed: () {
                        _showCustomDialog(
                            context, '알림', '저장 기능은 아직 구현되지 않았습니다.');
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
