import 'package:flutter/material.dart';
import 'package:freelance_chef_app/pages/drawer_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FreelanceChefApp",
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
    );
  }

}

class HomePage extends StatelessWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width/3,
      drawer: Drawer(
        child: DrawerPage(),
      ),
      appBar: AppBar(
          title: const Text("FreelanceChefApp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("FreelanceChefApp"),
          ),
          TextButton(
            child: const Text("Tap me"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are chef")));
            },
          )
        ],
      ),
    );
  }

}

