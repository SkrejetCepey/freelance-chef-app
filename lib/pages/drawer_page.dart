import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("HeaderDrawer"),
            ),
            ListTile(
              title: Text("Tile1")
            ),
            ListTile(
                title: Text("Tile2")
            ),
            ListTile(
                title: Text("Tile3")
            )
          ],
        ),
      ),
    );
  }
}