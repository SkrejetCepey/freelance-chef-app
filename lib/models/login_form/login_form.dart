import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';
import 'package:freelance_chef_app/bloc/login_form_service/login_form_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/repository/repository_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/register_form/register_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_chef_app/models/stay_in_account_switch/stay_in_account_switch.dart';
import 'package:freelance_chef_app/pages/register_page.dart';

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

    Map<String, dynamic> params = {'stateStayInAccountSwitch':false};
    // bool stateStayInAccountSwitch = false;

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
              context.read<NetworkBloc>(),
              context.read<UserServiceBloc>(),
              context.read<RepositoryBloc>(),
              context.read<ErrorServiceBloc>()),
          child: BlocBuilder<LoginFormServiceBloc, LoginFormServiceState>(
            builder: (context, state) {
              if (state is LoginFormServiceIdle) {
                if (state is LoginFormServiceSuccess) {
                  Future.microtask(() => ScaffoldMessenger.of(context)
                      .showSnackBar(
                          SnackBar(content: Text(state.successMessage))));
                  Navigator.of(context).pop();
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
                          StayInAccountSwitch(params: params),
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
                            context.read<LoginFormServiceBloc>().add(
                                LoginFormSendData(_mapParametersIntoUser(
                                    _user, _userParameters), params['stateStayInAccountSwitch']));
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                            // RegisterForm.showMyDialog(context);
                          },
                        )
                      ],
                    )
                  ],
                );
              } else if (state is LoginFormServiceWaitData) {
                return AlertDialog(
                  content: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 50.0, maxHeight: 50.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
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
