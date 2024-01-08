import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:livraison_repas/dishes.dart';
import 'package:livraison_repas/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class Commande {
  final int id;
  final String status;
  final DateTime dateCommande;
  final User user;
  final dishes? plat; // Nullable type

  Commande({
    required this.id,
    required this.status,
    required this.dateCommande,
    required this.user,
    this.plat,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    final platJson = json['plat'];

    return Commande(
      id: json['id'],
      status: json['status'],
      dateCommande: json['dateCommande'],
      user: User.fromJson(json['user']),
      plat: platJson is int
          ? null
          : platJson != null
              ? dishes.fromJson(platJson)
              : null,
    );
  }
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> commandList = [];
  late Future<void> futureCommand;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// Fetch Data
  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/list_command_with_plat/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        commandList = List<Map<String, dynamic>>.from(decodedData);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


// Cancel Commande
// Delete favorite
  Future<void> deleteCommand(int commdnId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/delete_commande/${commdnId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      setState(() {
        futureCommand = fetchData();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Command cancled succeffully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Command not cancled !'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              'Your Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: commandList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: commandList.length,
                    itemBuilder: (context, index) {
                      final plat = commandList[index]['plat'];
                      final favoriteId = commandList[index]['id'];
                      final commandeStatus = commandList[index]['status'];
                      return ListTile(
                        leading: Image.network(
                          plat['url'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(plat['name']),
                        subtitle: Text(commandeStatus),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFC79A99), // backgroundColor
                          ),
                          onPressed: () {
                            deleteCommand(favoriteId);
                          },
                          child: Text('Cancel'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
