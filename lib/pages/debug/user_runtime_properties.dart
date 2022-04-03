import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_chef_app/bloc/repository/repository_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/user.dart';

class UserRuntimeProperties extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userBloc = context.read<UserServiceBloc>();
    var userRepositoryBloc = context.read<RepositoryBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("DebugUserProperties"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text("Only for dev eyes:"),
          ),
          ListTile(
            title: Text(userBloc.getUserInfo().toString()),
          ),
          const Divider(),
          ListTile(
            title: Text("Users in DB:"),
          ),
          FutureBuilder<List<User>>(
            future: userRepositoryBloc.repository.userRepository!.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return ListTile(
                    title: Text("DB clear"),
                  );
                } else {
                  return ListView.builder(itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].toString()),
                    );
                  },shrinkWrap: true, itemCount: snapshot.data!.length,);
                }
              } else {
                return CircularProgressIndicator();
              }
            },
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