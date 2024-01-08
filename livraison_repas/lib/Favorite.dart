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
  final int id;
  final int rank;
  final User user;
  final dishes? plat; // Nullable type

  Ranking({
    required this.id,
    required this.rank,
    required this.user,
    this.plat, // Nullable
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    final platJson = json['plat'];

    return Ranking(
      id : json['id'],
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
  late Future<void> futureRanking;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Delete favorite
  Future<void> deleteFavorite(int favoriteId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/delete_favorite/${favoriteId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      setState(() {
        futureRanking = fetchData();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('favorite deleted succeffully.'),
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
          content: Text('Favorite not deleted !'),
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


  // List Data
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
                  final favoriteId = rankingList[index]['id'];
                  return ListTile(
                    leading: Image.network(
                      plat['url'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(plat['name']),
                    subtitle: Text(plat['prix'].toString() + 'DH'),
                    trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteFavorite(favoriteId);
                            
                          },
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
