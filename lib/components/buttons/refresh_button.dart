import 'package:flutter/material.dart';
import 'package:servy_app/utils/servy_backend.dart';

class RefreshButton extends StatefulWidget {
  final Function() callback;
  const RefreshButton({super.key, required this.callback});

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  bool inRefresh = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: inRefresh ? const CircularProgressIndicator() : const Icon(Icons.refresh),
      onPressed: () async {
        setState(() {
          inRefresh = true;
        });
        await ServyBackend().rafraichir();
        setState(() {
          inRefresh = false;
        });
        widget.callback();
      },
    );
  }
}
