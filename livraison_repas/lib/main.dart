import 'package:flutter/material.dart';
import 'Home.dart';
import 'log.dart';
import 'signup.dart';
import 'Dashboard.dart';
import 'user.dart';
import 'Dishes.dart';
import 'dishesD.dart';

void main() {
  runApp(MaterialApp(
    home:log(),
    routes: {
      '/Home': (context) => Home(),
      '/login' : (context) => log(),
      '/signup' : (context) =>signup(),
      '/Dashboard' : (context) => Dashboard(),
      '/User' : (context) => user(),
      '/Dishes' : (context) => Dishes(),
    },
    debugShowCheckedModeBanner: false,
  ));
}