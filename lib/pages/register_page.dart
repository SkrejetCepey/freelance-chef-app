import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/register_form_service/register_form_service_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/custom/season_appbar.dart';
import 'package:freelance_chef_app/models/register_form/register_form_tile.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey();
    User _user = User();
    Map<String, dynamic> _userParameters = {};

    TextEditingController _usernameController = TextEditingController();
    TextEditingController _surnameController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneNumberController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _roleNameController = TextEditingController();
    return Scaffold(
      appBar: SeasonAppBar(
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.account_circle_sharp),
            Text("RegisterPage")
          ],
        )
      ).build(context),
      body: BlocProvider<RegisterFormServiceBloc>(
        create: (_) => RegisterFormServiceBloc(
            context.read<NetworkBloc>(),
            context.read<UserServiceBloc>(),
            context.read<ErrorServiceBloc>()),
        child: BlocBuilder<RegisterFormServiceBloc, RegisterFormServiceState>(
          builder: (context, state) {
            if (state is RegisterFormServiceIdle) {
              return SingleChildScrollView(
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
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
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is RegisterFormServiceWaitData) {
              return const Center(
                child: CircularProgressIndicator(),
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
      ),
    );
  }

}