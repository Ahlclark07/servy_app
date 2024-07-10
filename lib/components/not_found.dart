import 'package:flutter/material.dart';
import 'package:servy_app/design/design_data.dart';

class NotFound extends StatelessWidget {
  final String text;
  const NotFound({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/404.jpg",
            width: 200,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                size: 30,
                color: Palette.blue,
                semanticLabel: text,
              ),
              SizedBox(
                  child: Text(
                text,
                textAlign: TextAlign.left,
              )),
            ],
          )
        ],
      ),
    );
  }
}
