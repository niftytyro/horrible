import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class Indicators extends StatefulWidget {
  const Indicators({
    Key? key,
    required this.firstDotWidth,
    required this.secondDotWidth,
    required this.thirdDotWidth,
  }) : super(key: key);
  final double firstDotWidth;
  final double secondDotWidth;
  final double thirdDotWidth;

  @override
  State<Indicators> createState() => _IndicatorsState();
}

class _IndicatorsState extends State<Indicators> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dot(width: widget.firstDotWidth),
        const SizedBox(width: 10),
        Dot(width: widget.secondDotWidth),
        const SizedBox(width: 10),
        Dot(width: widget.thirdDotWidth),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    Key? key,
    required this.width,
  }) : super(key: key);

  static const double minWidth = 10;
  static const double maxWidth = 30;

  final double width;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      width: width,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          100,
        ),
        color: BrickColors.periwinkle,
      ),
    );
  }
}
