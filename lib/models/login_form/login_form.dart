import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/login_form_service/login_form_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/register_form/register_form.dart';
import 'package:freelance_chef_app/utils/alert_dialog.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../user.dart';
import 'login_form_tile.dart';

class LoginForm {
  static User _mapParametersIntoUser(
      User user, Map<String, dynamic> parameters) {
    user.username = parameters["username"];
    user.phoneNumber = parameters["phoneNumber"];
    user.password = parameters["password"];
    return user;
  }

  static Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        GlobalKey<FormState> _formKey = GlobalKey();
        User _user = User();
        Map<String, dynamic> _userParameters = {};

        TextEditingController _usernameController = TextEditingController();
        TextEditingController _phoneNumberController = TextEditingController();
        TextEditingController _passwordController = TextEditingController();
        return BlocProvider<LoginFormServiceBloc>(
          create: (_) => LoginFormServiceBloc(
              context.read<NetworkBloc>(), context.read<UserServiceBloc>()),
          child: BlocBuilder<LoginFormServiceBloc, LoginFormServiceState>(
            builder: (context, state) {
              if (state is LoginFormServiceIdle) {
                if (state.haveUnhandledError()) {
                  Future.microtask(() =>
                      Alert.alert(context, state.getMessageAndHandleError()));
                }
                return AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  title: const Text('Login'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: ListBody(
                        children: [
                          LoginFormTile(
                              value: _userParameters,
                              valueName: "username",
                              titleValue: "Username",
                              controller: _usernameController),
                          LoginFormTile(
                              value: _userParameters,
                              valueName: "phoneNumber",
                              titleValue: "PhoneNumber",
                              controller: _phoneNumberController),
                          LoginFormTile(
                              value: _userParameters,
                              valueName: "password",
                              titleValue: "Password",
                              controller: _passwordController),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            try {
                              context.read<LoginFormServiceBloc>().add(
                                  LoginFormSendData(_mapParametersIntoUser(
                                      _user, _userParameters)));
                              // Navigator.of(context).pop();
                            } on DioError catch (e) {
                              await Alert.alert(
                                  context, e.response!.data.toString());
                            }
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Or you can"),
                        TextButton(
                          child: Text("register"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            RegisterForm.showMyDialog(context);
                          },
                        )
                      ],
                    )
                  ],
                );
              } else if (state is LoginFormServiceWaitData) {
                return AlertDialog(
                  content: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 50.0,
                      maxHeight: 50.0
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is LoginFormServiceSuccess) {
                Future.microtask(() => ScaffoldMessenger.of(context)
                    .showSnackBar(
                        SnackBar(content: Text(state.successMessage))));
                Navigator.of(context).pop();
                // TODO maybe a little dirty
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
