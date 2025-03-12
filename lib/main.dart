import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tradepal/screens/graph.dart';
import 'services/auth.dart';
import 'models/FirebaseUser.dart';
import 'screens/wrapper.dart';
import 'package:tradepal/screens/companiesList.dart';
import 'package:tradepal/screens/home.dart';
import 'screens/buy.dart';
import 'screens/sell.dart';
import 'screens/profile.dart';
import 'screens/mostPromising.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        routes: {
          "/companiesList": (context) => CompaniesList(),
          "/home": (context) => Home(),
          "/graph": (context) => const Graph(),
          "/buy": (context) =>  Buy(),
          "/sell": (context) => const Sell(),
          "/profile": (context) => const Profile(),
          "/mostPromising": (context) => const MostPromising(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //brightness: Brightness.dark,
          primaryColor: Colors.blue[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.black,
            textTheme: ButtonTextTheme.accent,
            hoverColor: Colors.red,
            colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
          ),
          fontFamily: 'Hind',
          textTheme: const TextTheme(
            headline6: TextStyle(
              fontSize: 26, // Adjust the font size as desired
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: Wrapper(),
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) {
              switch (settings.name) {
                case "/companiesList":
                  return  CompaniesList();
                case "/home":
                  return  Home();
                case "/graph":
                  return const Graph();
                case "/buy":
                  return const Buy();
                case "/sell":
                  return const Sell();
                  case "/profile":
                  return const Profile();
                  case "/mostPormising":
                  return const MostPromising();
                default:
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found'),
                    ),
                  );
              }
            },
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
