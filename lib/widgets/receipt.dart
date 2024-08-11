import 'package:flutter/material.dart';

class ReceiptComponent extends StatelessWidget {
  const ReceiptComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Column(
        children: [
          CustomPaint(
            painter: ReceiptPainter(isTop: true),
            child: const SizedBox(height: 10, width: double.infinity),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'RECEIPT',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),
                const ReceiptText('September 6, 2022 11:12:16'),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: [
                      ReceiptItem('new Plus Icon', '0:01'),
                      ReceiptItem('new Check Icon', '0:01'),
                      ReceiptItem('Hey Test Someth...', '0:01'),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: [
                      ReceiptItem('ITEM COUNT :', '3'),
                      ReceiptItem('TOTAL :', '0:03'),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: ReceiptText(
                      'No "brand" is your friend.',
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          width: 200,
                          height: 50,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: ReceiptText('https://www.daily-receipt.com'),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          CustomPaint(
            painter: ReceiptPainter(isTop: false),
            child: const SizedBox(height: 10, width: double.infinity),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReceiptText(name),
        ReceiptText(value),
      ],
    );
  }
}

class ReceiptText extends StatelessWidget {
  final String text;

  const ReceiptText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

class ReceiptPainter extends CustomPainter {
  final bool isTop;

  ReceiptPainter({this.isTop = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    const wavelength = 12.0;
    const amplitude = 5.0;

    if (isTop) {
      path.moveTo(0, amplitude);

      for (var i = 0; i < size.width / wavelength; i++) {
        path.lineTo((i + 0.5) * wavelength, 0);
        path.lineTo((i + 1) * wavelength, amplitude);
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height - amplitude);
      for (var i = size.width / wavelength; i > 0; i--) {
        path.lineTo((i - 0.5) * wavelength, size.height);
        path.lineTo((i - 1) * wavelength, size.height - amplitude);
      }
      path.lineTo(0, size.height - amplitude);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
