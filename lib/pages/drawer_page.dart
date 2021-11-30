import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/user.dart';

import 'debug/user_runtime_properties.dart';
import 'marketplace.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            BlocBuilder<UserServiceBloc, UserServiceState>(
                builder: (BuildContext context, state) {
              if (state is UserServiceUserInitialised) {
                User _user = context.read<UserServiceBloc>().getUserInfo();
                String _username = _user.username!;
                return DrawerHeader(
                  child: ListTile(
                    title: Text("Hello, $_username"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserRuntimeProperties()));
                    },
                  ),
                );
              } else {
                return const DrawerHeader(
                  child: Text("UnathorisedUser"),
                );
              }
            }),
            ListTile(
                title: Text("Marketplace"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MarketplacePage()));
                }),
            ListTile(title: Text("Messenger *soon*")),
          ],
        ),
      ),
    );
  }
}
