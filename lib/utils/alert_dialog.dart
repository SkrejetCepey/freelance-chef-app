import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';

class Alert {
  // static Future<void> alert(BuildContext context, String message) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Alert!'),
  //         content: SingleChildScrollView(
  //             child: Text(message)
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Ok!'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  static Future<void> alertFromBloc(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert!'),
          content: SingleChildScrollView(
              child: Text(message)
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok!'),
              onPressed: () {
                context.read<ErrorServiceBloc>().add(ErrorServiceEventErrorProcessed());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}