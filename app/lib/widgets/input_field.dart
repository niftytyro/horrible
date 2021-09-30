import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  InputField({
    Key? key,
    required this.tag,
  }) : super(key: key);
  final String tag;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool shouldFloat = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          shouldFloat = true;
        } else if (_controller.text == '') {
          shouldFloat = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: BrickSpacing.m),
            margin: const EdgeInsets.symmetric(
                horizontal: BrickSpacing.m, vertical: BrickSpacing.s),
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: BrickColors.black40),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: shouldFloat ? 0 : BrickSpacing.l1,
          left: BrickSpacing.l1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: BrickColors.white,
            child: Text(widget.tag),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BrickSpacing.xl,
            vertical: BrickSpacing.s,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
