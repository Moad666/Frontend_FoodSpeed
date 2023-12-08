import 'package:flutter/material.dart';
import 'Home.dart';
import 'log.dart';
import 'signup.dart';
import 'Dashboard.dart';

void main() {
  runApp(MaterialApp(
    home:Dashboard(), // Assuming Log is your initial screen
    routes: {
      '/Home': (context) => Home(),
      '/login' : (context) => log(),
      '/signup' : (context) =>signup(),
      '/Dashboard' : (context) => Dashboard(),
      // Add other routes as needed
    },
    debugShowCheckedModeBanner: false,
  ));
}