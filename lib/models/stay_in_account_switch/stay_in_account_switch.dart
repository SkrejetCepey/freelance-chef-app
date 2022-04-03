import 'package:flutter/material.dart';

class StayInAccountSwitch extends StatefulWidget {

  // bool state;
  Map<String, dynamic> params;

  StayInAccountSwitch({Key? key, required this.params}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StayInAccountSwitch();

}

class _StayInAccountSwitch extends State<StayInAccountSwitch> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text("Оставаться в аккаунте"),
          Switch(value: widget.params['stateStayInAccountSwitch'], onChanged: (value) {
            setState(() {widget.params['stateStayInAccountSwitch'] = !widget.params['stateStayInAccountSwitch'];});
          },),
        ],
      ),
    );
  }

}