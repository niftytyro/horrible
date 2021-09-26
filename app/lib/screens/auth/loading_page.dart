import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({
    Key? key,
    required this.slideToProfilePage,
  }) : super(key: key);
  final Function()? slideToProfilePage;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), slideToProfilePage);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/loading.gif'),
          const Text(
            'See you on the other side then!',
          ),
        ],
      ),
    );
  }
}
