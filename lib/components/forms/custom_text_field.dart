import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servy_app/design/design_data.dart';

class CustomTextField extends StatefulWidget {
  final String name;
  final String labelTitle;
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final bool isNumber;
  const CustomTextField(
      {super.key,
      required this.labelTitle,
      required this.labelText,
      required this.controller,
      required this.name,
      this.isNumber = false,
      required this.icon});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
              keyboardType:
                  widget.isNumber ? TextInputType.phone : TextInputType.text,
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
                      : null)),
        )
      ],
    );
  }
}
