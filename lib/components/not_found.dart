import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  final String text;
  const NotFound({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset(
            "assets/images/404.jpg",
            width: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning),
              Text(text),
            ],
          )
        ],
      ),
    );
  }
}
