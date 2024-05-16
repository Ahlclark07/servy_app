import 'package:flutter/material.dart';

class TabulationButton extends StatefulWidget {
  final void Function() onPressed;

  const TabulationButton({super.key, required this.onPressed});
  @override
  _TabulationButtonState createState() => _TabulationButtonState();
}

class _TabulationButtonState extends State<TabulationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _toggleRotation();
        widget.onPressed();
      },
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: _controller.value * 0.5 * 3.14, // Angle de rotation (90°)
            child: Icon(Icons.arrow_right),
          );
        },
      ),
    );
  }
}