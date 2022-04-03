import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DeadlineListTile extends StatefulWidget {
  final dynamic value;

  DeadlineListTile({Key? key, this.value}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DeadlineListTileState();
  }
}

class _DeadlineListTileState extends State<DeadlineListTile> {
  @override
  Widget build(BuildContext context) {
    bool isDeadlineEmpty = widget.value["deadline"] == null;
    return ListTile(
      title: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: (isDeadlineEmpty)
              ? MaterialStateProperty.all(Colors.redAccent)
              : MaterialStateProperty.all(Colors.greenAccent),
        ),
        child: (isDeadlineEmpty)
            ? Text("Pick deadline!")
            : Text("Deadline picked!"),
        onPressed: () {
          DatePicker.showDateTimePicker(context, locale: LocaleType.ru,
              onConfirm: (time) {
            widget.value["deadline"] = time.toIso8601String();
            if (mounted){
              setState(() {});
            }
          }, onCancel: () {
              widget.value["deadline"] = null;
              if (mounted){
                setState(() {});
              }
          },);
        },
      ),
    );
  }
}
