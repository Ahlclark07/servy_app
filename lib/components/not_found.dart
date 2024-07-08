import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:servy_app/design/design_data.dart';

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
              Icon(Icons.warning),
              Text(text),
            ],
          )
        ],
      ),
    );
  }
}
