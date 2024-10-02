import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/receipt.dart';
import 'package:daily_receipt/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReceiptDetailScreen extends StatelessWidget {
  final DateTime selectedDate;

  final List<Todo> todos;

  const ReceiptDetailScreen(
      {Key? key, required this.selectedDate, required this.todos})
      : super(key: key);

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
            // 여기에 나머지 컨텐츠를 추가하세요
            Expanded(
              child: Center(
                child: ReceiptComponent(
                  todos,
                  selectedDate,
                ),
              ),
            ),
            Container(
              // color: Colors.green, // 배경색 추가 (선택 사항)
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
                      onPressed: () {
                        // TODO: 버튼을 눌렀을 때의 동작을 추가 필요
                      },
                    ),
                    TextButtonCustom(
                      text: 'Save',
                      iconPath: 'assets/icons/save.svg',
                      type: ButtonType.basic,
                      textColor: const Color(0xFF757575),
                      isBold: false,
                      onPressed: () {
                        // TODO: 버튼을 눌렀을 때의 동작을 추가 필요
                      },
                    ),
                    TextButtonCustom(
                      text: 'Pin',
                      iconPath: 'assets/icons/pin.svg',
                      type: ButtonType.basic,
                      textColor: const Color(0xFF757575),
                      isBold: false,
                      onPressed: () {
                        // TODO: 버튼을 눌렀을 때의 동작을 추가 필요
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
