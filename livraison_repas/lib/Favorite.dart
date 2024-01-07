import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:livraison_repas/dishes.dart';
import 'package:livraison_repas/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:livraison_repas/Dashboard.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class Ranking {
  final int rank;
  final User user;
  final dishes? plat; // Nullable type

  Ranking({
    required this.rank,
    required this.user,
    this.plat, // Nullable
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    final platJson = json['plat'];

    return Ranking(
      rank: json['rank'],
      user: User.fromJson(json['user']),
      plat: platJson is int
          ? null // Handle the case where 'plat' is an ID, and fetch details separately
          : platJson != null
              ? dishes.fromJson(platJson)
              : null,
    );
  }
}

class _FavoriteState extends State<Favorite> {

  List<Map<String, dynamic>> rankingList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/list_ranking_with_plat/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      setState(() {
        rankingList = List<Map<String, dynamic>>.from(decodedData);
      });
    } else {
      throw Exception('Failed to load data');
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
          'Favorite Food',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: rankingList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: rankingList.length,
                itemBuilder: (context, index) {
                  final plat = rankingList[index]['plat'];
                  return ListTile(
                    leading: Image.network(
                      plat['url'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(plat['name']),
                    subtitle: Text(plat['prix'].toString() + 'DH'),
                  );
                },
              ),
      ),
    ],
  ),
);
  }
}
