import 'dart:ffi';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livraison_repas/Dashboard.dart';
import 'package:livraison_repas/user.dart';

class Dishes extends StatefulWidget {
  const Dishes({Key? key});

  @override
  State<Dishes> createState() => _DishesState();
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

class _DishesState extends State<Dishes> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController categorieController = TextEditingController();
  Category? selectedCategory;
// Delete Dishe
  Future<void> deleteDishes(int disheId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/delete_recipe/${disheId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      setState(() {
        futureDishes = listDishes();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Dishe deleted succeffully.'),
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
          content: Text('Dishe not deleted !'),
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

// Create Diches
  Future<void> createDishes() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/create_dishe/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': nameController.text,
        'description': descriptionController.text,
        'prix': prixController.text,
        'ingredients': ingredientsController.text,
        'url': urlController.text,
        'categorie': selectedCategory!.id.toString(),
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        futureDishes = listDishes();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Dishe created succeffully.'),
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
          content: Text('Dishe was not created !'),
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

// List Category
  Future<List<Category>> listCategorie() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/listCategorie/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => Category.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

// Update Dishe
  Future<void> updateDishe(int disheId) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController prixController = TextEditingController();
    TextEditingController ingredientsController = TextEditingController();
    TextEditingController urlController = TextEditingController();
    TextEditingController categorieController = TextEditingController();
    Category? selectedCategory;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Dishe'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'New Dishe Name',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                ),
              ),
               SizedBox(height: 16,),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'New Dishe description',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              TextField(
                controller: prixController,
                decoration: InputDecoration(
                  labelText: 'New Dishe price',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              TextField(
                controller: ingredientsController,
                decoration: InputDecoration(
                  labelText: 'New Dishe ingredients',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'New Dishe url',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFC79A99)),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              FutureBuilder<List<Category>>(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return DropdownButtonFormField<Category>(
                            value: selectedCategory,
                            onChanged: (Category? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                            items: snapshot.data!.map((Category category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.name),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: "Categorie",
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 112, 111, 111)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFC79A99)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFC79A99)),
                              ),
                            ),
                          );
                        }
                      },
                    ),
          ],
          ),
          
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Make the API call to update the category with the new name
                final response = await http.put(
                  Uri.parse(
                      'http://10.0.2.2:8000/api/update_dishe/$disheId/'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'name': nameController.text,
                    'description' : descriptionController.text,
                    'prix' : prixController.text,
                    'ingredients' : ingredientsController.text,
                    'url' : urlController.text,
                    'categorie' : selectedCategory!.id.toString(),
                  }),
                );

                if (response.statusCode == 200) {
                  // Category updated successfully, you can handle success accordingly
                  // For example, refresh the data in your UI
                  setState(() {
                    futureDishes = listDishes();
                  });
                  // Close the dialog
                  Navigator.pop(context);
                } else {
                  // Handle error, show an error message or take appropriate action
                  // Close the dialog
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Update',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  late Future<List<dishes>> futureDishes;
  late Future<List<Category>> futureCategories;
  @override
  void initState() {
    super.initState();
    futureDishes = listDishes();
    futureCategories = listCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dishes'),
          centerTitle: true,
          backgroundColor: Color(0xFFC79A99),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Dishes Management'),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 112, 111, 111)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 112, 111, 111)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: prixController,
                      decoration: InputDecoration(
                        labelText: "Price",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 112, 111, 111)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: ingredientsController,
                      decoration: InputDecoration(
                        labelText: "Ingredients",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 112, 111, 111)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: urlController,
                      decoration: InputDecoration(
                        labelText: "Url image",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 112, 111, 111)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC79A99)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    FutureBuilder<List<Category>>(
                      future: futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return DropdownButtonFormField<Category>(
                            value: selectedCategory,
                            onChanged: (Category? newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            },
                            items: snapshot.data!.map((Category category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.name),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: "Categorie",
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 112, 111, 111)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFC79A99)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFC79A99)),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: createDishes,
                      child: Text("Add"),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<dishes>>(
                future: futureDishes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<dishes> dishe = snapshot.data!;
                    return DataTable(
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: dishe
                          .map((tdishes) => DataRow(cells: [
                                DataCell(Text(tdishes.name)),
                                DataCell(Text(tdishes.prix.toString())),
                                DataCell(
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          deleteDishes(tdishes.id);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        child: Text('Update'),
                                        onPressed: () {
                                          updateDishe(tdishes.id);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.orange),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFC79A99),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('User'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to the home screen or any other screen
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => user()));
            },
          ),
          ListTile(
            title: Text('Category'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to other screen 1
              // Replace UserScreen with the appropriate screen widget
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
        ],
      ),
    );
  }
}
