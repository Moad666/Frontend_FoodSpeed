import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'log.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: ElevatedButton.icon(icon: Icon(Icons.arrow_back),label : Text('back'),onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => const log()));},),
      
      
      );
  }
}

