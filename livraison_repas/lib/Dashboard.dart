import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livraison_repas/dishes.dart';
import 'package:livraison_repas/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class _DashboardState extends State<Dashboard> {
  TextEditingController nameController = TextEditingController();

  // Create Category
  Future<void> createCategorie() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/createCategorie/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': nameController.text,
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        futureCategories = listCategorie();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Categorie created succeffully.'),
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
          content: Text('Categorie was not created !'),
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

  late Future<List<Category>> futureCategories;

  Future<void> deleteCategorie(int categoryId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/deleteCategorie/${categoryId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      setState(() {
        futureCategories = listCategorie();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Categorie deleted succeffully.'),
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
          content: Text('Categorie not deleted !'),
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

  Future<void> updateCategorie(int categoryId) async {
    TextEditingController nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Category'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'New Category Name',
            labelStyle:
                        TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC79A99)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC79A99)),
                    ),),
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
                      'http://10.0.2.2:8000/api/updateCategorie/$categoryId/'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'name': nameController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  // Category updated successfully, you can handle success accordingly
                  // For example, refresh the data in your UI
                  setState(() {
                    futureCategories = listCategorie();
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

// Logout
Future<void> logoutUser() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/logout/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('Error logging out: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  @override
  void initState() {
    super.initState();
    futureCategories = listCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        centerTitle: true,
        backgroundColor: Color(0xFFC79A99),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logoutUser,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView( child : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text('Category Management'),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Categorie name",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 112, 111, 111)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC79A99)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC79A99)),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: createCategorie,
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Category> categories = snapshot.data!;
                return DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: categories
                      .map((category) => DataRow(cells: [
                            DataCell(Text(category.id.toString())),
                            DataCell(Text(category.name)),
                            DataCell(
                              Row(
                                children: [
                                  ElevatedButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      deleteCategorie(category.id);
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
                                      updateCategorie(category.id);
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
          )
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
            title: Text('Dishes'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to other screen 1
              // Replace UserScreen with the appropriate screen widget
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dishes()));
            },
          ),
        ],
      ),
    );
  }
}
