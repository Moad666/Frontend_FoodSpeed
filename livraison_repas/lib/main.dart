import 'package:flutter/material.dart';
import 'Home.dart';
import 'log.dart';
import 'signup.dart';

void main() {
  runApp(MaterialApp(
    home:signup(), // Assuming Log is your initial screen
    routes: {
      '/Home': (context) => Home(),
      '/login' : (context) => log(),
      '/signup' : (context) =>signup(),
      // Add other routes as needed
    },
    debugShowCheckedModeBanner: false,
  ));
}