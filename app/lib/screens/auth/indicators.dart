import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class Indicators extends StatefulWidget {
  const Indicators({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  State<Indicators> createState() => _IndicatorsState();
}

class _IndicatorsState extends State<Indicators> {
  double firstDotWidth = 25;
  double secondDotWidth = 10;
  double thirdDotWidth = 10;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        final screenWidth = MediaQuery.of(context).size.width;
        firstDotWidth = 10 +
            (widget.pageController.offset < screenWidth
                ? 20 - 20 * widget.pageController.offset / screenWidth
                : 0);
        secondDotWidth = 10 +
            (widget.pageController.offset < screenWidth * 2
                ? 20 * widget.pageController.offset / screenWidth
                : 0);
        thirdDotWidth = 10 +
            (widget.pageController.offset > screenWidth * 2
                ? 20 * widget.pageController.offset / screenWidth * 3
                : 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dot(width: firstDotWidth),
        const SizedBox(width: 10),
        Dot(width: secondDotWidth),
        const SizedBox(width: 10),
        Dot(width: thirdDotWidth),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          100,
        ),
        color: BrickColors.lightPeriwinkle,
      ),
    );
  }
}
