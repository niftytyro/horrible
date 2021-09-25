import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class ResizableArrow extends StatelessWidget {
  const ResizableArrow({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: BrickSpacing.s),
            height: 1,
            color: Colors.white,
          ),
        ),
        SizedBox(
            height: 15,
            child: Image.asset('assets/images/right-arrow-white.png')),
      ],
    );
  }
}
