import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';

class UserRuntimeProperties extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userBloc = context.read<UserServiceBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("DebugUserProperties"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Only for dev eyes:"),
          ),
          ListTile(
            title: Text("${userBloc.getUserInfo().toString()}"),
          ),
          ListTile(
            title: ElevatedButton(
              child: Text("Forget user"),
              onPressed: () {
                context.read<UserServiceBloc>().add(UserServiceDeleteUser());
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}