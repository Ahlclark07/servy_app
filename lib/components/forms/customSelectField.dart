import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servy_app/design/design_data.dart';

class CustomSelectField extends StatefulWidget {
  final String name;
  final String labelTitle;
  final String labelText;
  final List<String> list;
  final List<String> values;
  final IconData icon;
  final void Function(String value) controller;

  const CustomSelectField(
      {super.key,
      required this.labelTitle,
      required this.labelText,
      required this.list,
      required this.controller,
      required this.name,
      required this.values,
      required this.icon});

  @override
  State<CustomSelectField> createState() => _CustomSelectFieldState();
}

class _CustomSelectFieldState extends State<CustomSelectField> {
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
          child: FormBuilderDropdown(
              onTap: () => setState(() {
                    showLabel = false;
                  }),
              onChanged: (value) => widget.controller(value!),
              items: List<DropdownMenuItem>.generate(
                widget.list.length,
                (index) {
                  final value = widget.values[index];

                  return DropdownMenuItem(
                    value: value,
                    child: Text(widget.list[
                        index]), // Utilisez list[index] comme texte du DropdownMenuItem
                  );
                },
              ),
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
