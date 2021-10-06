import 'package:app/constants.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  InputField({
    Key? key,
    required this.tag,
    required this.controller,
    this.errorKey,
    this.invalidValue = false,
  }) : super(key: key);

  final String tag;
  final TextEditingController controller;
  final bool invalidValue;
  final InputFieldErrorMessageKey? errorKey;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          _isFocused = true;
        } else {
          _isFocused = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: BrickSpacing.m, vertical: BrickSpacing.s1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: BrickSpacing.m),
                  margin: const EdgeInsets.only(bottom: BrickSpacing.s),
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.invalidValue
                          ? BrickColors.notRed
                          : _focusNode.hasFocus
                              ? BrickColors.vividVioletLight
                              : BrickColors.black20,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                if (widget.errorKey != null)
                  AnimatedContainer(
                    duration: animationDuration,
                    padding: const EdgeInsets.only(left: BrickSpacing.xs),
                    constraints: BoxConstraints(
                      maxHeight: widget.invalidValue ? BrickSpacing.l : 0,
                    ),
                    child: Text(
                      inputFieldErrorMessages[widget.errorKey],
                      style: BrickTheme.textTheme.bodyText2?.copyWith(
                        color: BrickColors.notRed,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: _isFocused || widget.controller.text.isNotEmpty
              ? 0
              : BrickSpacing.l1,
          left: BrickSpacing.l1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: BrickColors.white,
            child: Text(
              widget.tag,
              style: BrickTheme.textTheme.bodyText1?.copyWith(
                color: widget.invalidValue
                    ? BrickColors.notRed
                    : _focusNode.hasFocus
                        ? BrickColors.vividVioletLight
                        : BrickColors.black40,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BrickSpacing.xl,
            vertical: BrickSpacing.s,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
