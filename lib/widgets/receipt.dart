import 'package:flutter/material.dart';

class ReceiptComponent extends StatelessWidget {
  const ReceiptComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'RECEIPT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          const Text('September 6, 2022 11:12:16'),
          const Divider(),
          const ReceiptItem('new Plus Icon', '0:01'),
          const ReceiptItem('new Check Icon', '0:01'),
          const ReceiptItem('Hey Test Someth...', '0:01'),
          const Divider(),
          const ReceiptItem('ITEM COUNT :', '3'),
          const ReceiptItem('TOTAL :', '0:03'),
          const Divider(),
          const Center(
            child: Text(
              'No "brand" is your friend.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 200,
              height: 50,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('https://www.daily-receipt.com'),
          ),
        ],
      ),
    );
  }
}

class ReceiptItem extends StatelessWidget {
  final String name;
  final String value;

  const ReceiptItem(this.name, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(value),
        ],
      ),
    );
  }
} 