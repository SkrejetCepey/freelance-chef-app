import 'package:flutter/material.dart';

class BuyerFormTile extends StatelessWidget {
  dynamic value;
  String valueName;
  String titleValue;
  TextInputType? keyboardType;
  TextEditingController? controller;

  BuyerFormTile(
      {Key? key,
      required this.value,
      required this.valueName,
      required this.titleValue,
        this.controller,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        onSaved: (newValue) {
          value[valueName] = newValue!;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $titleValue!';
          }
          return null;
        },
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: titleValue,
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );
  }
}
