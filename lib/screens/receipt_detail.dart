import 'dart:io';
import 'dart:ui' as ui;

import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/buttons.dart';
import 'package:daily_receipt/widgets/custom_snackbar.dart';
import 'package:daily_receipt/widgets/receipt.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:daily_receipt/services/localization_service.dart';

class ReceiptDetailScreen extends StatefulWidget {
  final DateTime selectedDate;

  const ReceiptDetailScreen({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _ReceiptDetailScreenState createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  final GlobalKey receiptKey = GlobalKey();
  bool isCopyLoading = false;
  bool isShareLoading = false;

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

  Future<void> _copyReceiptToClipboard() async {
    if (isCopyLoading) return;
    setState(() => isCopyLoading = true);
    try {
      CustomSnackBar.show(
        context,
        tr.key7,
        tr.key8,
      );
      Uint8List imageBytes = await _captureReceiptImage();
      await Pasteboard.writeImage(imageBytes);

      CustomSnackBar.show(
        context,
        tr.key9,
        tr.key10,
      );
    } catch (e) {
      CustomSnackBar.show(
        context,
        tr.key11,
        "${tr.key12}: $e",
      );
    } finally {
      setState(() => isCopyLoading = false);
    }
  }

  Future<void> _shareReceipt() async {
    if (isShareLoading) return;
    setState(() => isShareLoading = true);
    try {
      CustomSnackBar.show(
        context,
        tr.key13,
        tr.key14,
      );
      Uint8List imageBytes = await _captureReceiptImage();

      if (kIsWeb) {
        // Web 환경에서의 공유 로직
        final result = await Share.shareXFiles([
          XFile.fromData(imageBytes, mimeType: 'image/png', name: 'receipt.png')
        ]);

        if (result.status == ShareResultStatus.dismissed) {
          CustomSnackBar.show(
            context,
            tr.key17,
            tr.key18,
          );
        } else {
          CustomSnackBar.show(
            context,
            tr.key15,
            tr.key16,
          );
        }
      } else {
        // 모바일 환경에서의 공유 로직
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        final result = await Share.shareXFiles([XFile(imagePath)]);

        if (result.status == ShareResultStatus.dismissed) {
          CustomSnackBar.show(
            context,
            tr.key17,
            tr.key18,
          );
        } else {
          CustomSnackBar.show(
            context,
            tr.key15,
            tr.key16,
          );
        }

        // 임시 파일 삭제
        await imageFile.delete();
      }
    } catch (e) {
      CustomSnackBar.show(
        context,
        tr.key11,
        "${tr.key19}: $e",
      );
    } finally {
      setState(() => isShareLoading = false);
    }
  }

  // void _pinReceipt() {
  //   final todosProvider = Provider.of<Todos>(context, listen: false);
  //   todosProvider.togglePin(widget.selectedDate);
  //
  //   String title =
  //       todosProvider.isPinned(widget.selectedDate) ? "Pin 추가" : "Pin 제거";
  //   String message = todosProvider.isPinned(widget.selectedDate)
  //       ? '영수증이 Pin되었습니다.'
  //       : 'Pin이 해제되었습니다.';
  //
  //   CustomSnackBar.show(context, title, message);
  // }

  @override
  Widget build(BuildContext context) {
    final todosProvider = Provider.of<Todos>(context);
    // bool isPinned = todosProvider.isPinned(widget.selectedDate);
    List<Todo> doneTodos = todosProvider
        .getTodosForDate(widget.selectedDate)
        .where((todo) => todo.isDone)
        .toList();

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
              child: SingleChildScrollView(
                child: Center(
                  child: RepaintBoundary(
                    key: receiptKey,
                    child: ReceiptComponent(
                      doneTodos,
                      widget.selectedDate,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButtonCustom(
                    text: tr.key6,
                    iconPath: 'assets/icons/copy.svg',
                    type: ButtonType.basic,
                    textColor: const Color(0xFF757575),
                    isBold: false,
                    onPressed: () =>
                        isCopyLoading ? null : _copyReceiptToClipboard(),
                  ),
                  TextButtonCustom(
                    text: tr.key43,
                    iconPath: 'assets/icons/save.svg',
                    type: ButtonType.basic,
                    textColor: const Color(0xFF757575),
                    isBold: false,
                    onPressed: () => isShareLoading ? null : _shareReceipt(),
                  ),
                  // TextButtonCustom(
                  //     text: 'Pin',
                  //     iconPath: isPinned
                  //         ? 'assets/icons/pin_active.svg'
                  //         : 'assets/icons/pin.svg',
                  //     type: ButtonType.basic,
                  //     textColor: const Color(0xFF757575),
                  //     isBold: false,
                  //     onPressed: () => _pinReceipt()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
