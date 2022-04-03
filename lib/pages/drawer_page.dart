import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/pages/world_map.dart';
import 'package:freelance_chef_app/pages/world_map_yandex.dart';

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
                return DrawerHeader(
                  child: ListTile(
                    title: Text("UnathorisedUser"),
                  ),
                );
              }
            }),
            ListTile(
                title: Row(
                  children: [
                    Icon(Icons.shopping_cart),
                    Text("Marketplace"),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MarketplacePage()));
                }),
            ListTile(title: Text("Messenger *soon*")),
            ListTile(
              title: Text("WorldMap"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorldMap()));
              },
            ),
            ListTile(
              title: Text("WorldMapYandex"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorldMapYandex()));
              },
            ),
            // ListTile(
            //   title: Text("Test snow"),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => TestPage(child: Center(child: Text("Suka"),),)));
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
