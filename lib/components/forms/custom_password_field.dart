import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servy_app/design/design_data.dart';

class CustomPasswordField extends StatefulWidget {
  final String name;
  final String labelTitle;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  const CustomPasswordField(
      {super.key,
      required this.labelTitle,
      required this.labelText,
      required this.name,
      required this.controller,
      required this.icon});

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool active = true;
  bool showLabel = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelTitle,
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Palette.cendre.withOpacity(.15)),
          child: FormBuilderTextField(
              onTap: () => setState(() {
                    showLabel = false;
                  }),
              onSubmitted: (event) {
                setState(() {
                  showLabel = widget.controller.text != "" ? false : true;
                });
              },
              controller: widget.controller,
              obscureText: active,
              name: widget.name,
              decoration: Design.inputDecoration.copyWith(
                  icon: Container(
                      margin: const EdgeInsets.only(left: 12, right: 0),
                      child: Icon(widget.icon)),
                  label: showLabel
                      ? Text(
                          widget.labelText,
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                      : null,
                  suffixIcon: GestureDetector(
                    child: Icon(active
                        ? Icons.remove_red_eye_outlined
                        : Icons.remove_red_eye),
                    onTap: () => setState(() {
                      active = !active;
                    }),
                  ))),
        )
      ],
    );
  }
}
