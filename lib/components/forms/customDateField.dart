import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:servy_app/design/design_data.dart';

class CustomDateField extends StatefulWidget {
  final String name;
  final String labelTitle;
  final IconData icon;
  final TextEditingController controller;

  const CustomDateField(
      {super.key,
      required this.labelTitle,
      required this.controller,
      required this.name,
      required this.icon});

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
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
          child: FormBuilderDateTimePicker(
              locale: const Locale("fr"),
              format: DateFormat.yMd(),
              inputType: InputType.date,
              controller: widget.controller,
              name: widget.name,
              fieldLabelText: "Jour/Mois/Année",
              firstDate: DateTime(DateTime.now().year - 18),
              decoration: Design.inputDecoration.copyWith(
                icon: Container(
                    margin: const EdgeInsets.only(left: 12, right: 0),
                    child: Icon(widget.icon)),
              )),
        )
      ],
    );
  }
}
