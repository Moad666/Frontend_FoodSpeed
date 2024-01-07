import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livraison_repas/Dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:livraison_repas/dishes.dart';
import 'package:livraison_repas/dishesD.dart';
import 'user.dart';

class HomeDish extends StatefulWidget {
  const HomeDish({super.key});

  @override
  State<HomeDish> createState() => _HomeDishState();
}

class dishes {
  final int id;
  final String name;
  final String description;
  final double prix;
  final String ingredients;
  final String url;
  final Category categorie;
  final int categorieId;

  dishes(
      {required this.id,
      required this.name,
      required this.description,
      required this.prix,
      required this.ingredients,
      required this.url,
      required this.categorie,
      required this.categorieId});

  factory dishes.fromJson(Map<String, dynamic> json) {
    return dishes(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      prix: json['prix'].toDouble(),
      ingredients: json['ingredients'],
      url: json['url'],
      categorie: Category(id: json['id'], name: json['name']),
      categorieId: json['categorie'],
    );
  }
}

class _HomeDishState extends State<HomeDish> {
  TextEditingController searchController = TextEditingController();

  void searchDishes() {
    setState(() {
      futureDishes = listDishesByNameOrCategorie(searchController.text);
    });
  }

  // Search
 Future<List<dishes>> listDishesByNameOrCategorie(String query) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/api/search/?name=$query'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((dish) => dishes.fromJson(dish)).toList();
  } else {
    throw Exception('Failed to load dishes');
  }
}


  // List Dishes
  Future<List<dishes>> listDishes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/list_dishes/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((dish) => dishes.fromJson(dish)).toList();
    } else {
      throw Exception('Failed to load dishes');
    }
  }

  late Future<List<dishes>> futureDishes;

  @override
  void initState() {
    super.initState();
    futureDishes = listDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: 'Search',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 112, 111, 111),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFC79A99)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFC79A99)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    searchDishes();
                  },
                  icon: Icon(Icons.search),
                  color: Color(0xFFC79A99),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<dishes>>(
              future: futureDishes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var dish = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the DishesDetail screen with the selected dish
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => dishesDetail(dish: dish),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Image.network(
                                dish.url,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              ListTile(
                                title: Text(dish.name),
                                subtitle: Text(dish.description),
                                trailing:
                                    Text('\DH${dish.prix.toStringAsFixed(2)}'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}