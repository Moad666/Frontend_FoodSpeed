import 'package:flutter/material.dart';
import 'Home.dart';
import 'log.dart';
import 'signup.dart';
import 'Dashboard.dart';
import 'user.dart';

void main() {
  runApp(MaterialApp(
    home:user(),
    routes: {
      '/Home': (context) => Home(),
      '/login' : (context) => log(),
      '/signup' : (context) =>signup(),
      '/Dashboard' : (context) => Dashboard(),
      '/User' : (context) => user(),
    },
    debugShowCheckedModeBanner: false,
  ));
}