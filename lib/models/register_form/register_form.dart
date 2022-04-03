import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/register_form_service/register_form_service_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/register_form/register_form_tile.dart';
import 'package:freelance_chef_app/utils/alert_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../user.dart';

class RegisterForm {
  static User _mapParametersIntoUser(
      User user, Map<String, dynamic> parameters) {
    user.username = parameters["username"];
    user.surname = parameters["surname"];
    user.name = parameters["name"];
    user.phoneNumber = parameters["phoneNumber"];
    user.password = parameters["password"];
    user.roleName = parameters["roleName"];
    return user;
  }

  static Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        GlobalKey<FormState> _formKey = GlobalKey();
        User _user = User();
        Map<String, dynamic> _userParameters = {};

        TextEditingController _usernameController = TextEditingController();
        TextEditingController _surnameController = TextEditingController();
        TextEditingController _nameController = TextEditingController();
        TextEditingController _phoneNumberController = TextEditingController();
        TextEditingController _passwordController = TextEditingController();
        TextEditingController _roleNameController = TextEditingController();
        return BlocProvider<RegisterFormServiceBloc>(
          create: (_) => RegisterFormServiceBloc(
              context.read<NetworkBloc>(),
              context.read<UserServiceBloc>(),
              context.read<ErrorServiceBloc>()),
          child: BlocBuilder<RegisterFormServiceBloc, RegisterFormServiceState>(
            builder: (context, state) {
              if (state is RegisterFormServiceIdle) {
                // if (state.haveUnhandledError()) {
                //   Future.microtask(() =>
                //       Alert.alert(context, state.getMessageAndHandleError()));
                // }
                return AlertDialog(
                  title: const Text('Register'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: ListBody(
                        children: [
                          RegisterFormTile(
                              value: _userParameters,
                              valueName: "username",
                              titleValue: "Username",
                              controller: _usernameController),
                          RegisterFormTile(
                              value: _userParameters,
                              valueName: "surname",
                              titleValue: "Surname",
                              controller: _surnameController),
                          RegisterFormTile(
                              value: _userParameters,
                              valueName: "name",
                              titleValue: "Name",
                              controller: _nameController),
                          RegisterFormTile(
                              value: _userParameters,
                              valueName: "phoneNumber",
                              titleValue: "PhoneNumber",
                              controller: _phoneNumberController),
                          RegisterFormTile(
                              value: _userParameters,
                              valueName: "password",
                              titleValue: "Password",
                              controller: _passwordController),
                          RegisterFormTile(
                              value: _userParameters,
                              valueName: "roleName",
                              titleValue: "RoleName",
                              controller: _roleNameController),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Register'),
                      onPressed: () async {
                        print(_userParameters.length);
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<RegisterFormServiceBloc>().add(
                              RegisterFormSendData(_mapParametersIntoUser(
                                  _user, _userParameters)));
                        }
                      },
                    ),
                  ],
                );
              } else if (state is RegisterFormServiceWaitData) {
                return AlertDialog(
                  content: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 50.0, maxHeight: 50.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is RegisterFormServiceSuccess) {
                Future.microtask(() => ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                            content: Text("Registration and login success!"))))
                    .whenComplete(() {
                  Navigator.of(context).pop();
                });
                return Container();
              } else {
                return Center(
                  child: Text("Something going wrong!"),
                );
              }
            },
          ),
        );
      },
    );
  }
}
