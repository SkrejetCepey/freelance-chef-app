import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/pages/drawer_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_service/user_service_bloc.dart';
import 'observer/simple_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkBloc>(create: (_) => NetworkBloc()),
        BlocProvider<UserServiceBloc>(create: (context) => UserServiceBloc(context.read<NetworkBloc>())),
        // TODO TEMPORARY DEPRECATED -> BlocProvider<GlobalServiceBloc>(create: (ctx) => GlobalServiceBloc(context.read<NetworkBloc>(), ctx)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "FreelanceChefApp",
        home: HomePage(),
        theme: ThemeData(
          primarySwatch: Colors.deepPurple
        ),
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

