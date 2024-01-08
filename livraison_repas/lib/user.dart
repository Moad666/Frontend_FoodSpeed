import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livraison_repas/Dashboard.dart';
import 'package:livraison_repas/dishes.dart';
import 'package:livraison_repas/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class user extends StatefulWidget {
  const user({Key? key});

  @override
  State<user> createState() => _userState();
}

class User {
  final int id;
  final String username;
  final String email;
  final String password;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password']);
  }
}

class _userState extends State<user> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

// Logout
Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');

    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => log(),
      ),
    );
  }


// Update User
  Future<void> updateUser(int userId) async {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update User'),
          content: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'New username',
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
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'New email',
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
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'New password',
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
                  Uri.parse('http://10.0.2.2:8000/api/update_user/$userId/'),
                  headers: <String, String>{
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode({
                    'username': usernameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  
                  setState(() {
                    futureUsers = listUser();
                  });
                  Navigator.pop(context);
                } else {
                  
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

// Delete User
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/delete_user/${userId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      setState(() {
        futureUsers = listUser();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('User deleted succeffully.'),
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
          content: Text('User not deleted !'),
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

// Create User
  Future<void> createUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/create_user/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text
      }),
    );
    print(jsonEncode(<String, String>{
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text
    }));
    if (response.statusCode == 201) {
      setState(() {
        futureUsers = listUser();
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('User created succeffully.'),
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
          content: Text('Something went wrong !'),
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

// List User
  Future<List<User>> listUser() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/list_user/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((ouruser) => User.fromJson(ouruser)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  late Future<List<User>> futureUsers;
  @override
  void initState() {
    super.initState();
    futureUsers = listUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        centerTitle: true,
        backgroundColor: Color(0xFFC79A99),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
      drawer: AppDrawer(), 
      body:
      SingleChildScrollView ( child : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text('User Management'),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
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
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
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
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
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
                  onPressed: createUser,
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          FutureBuilder<List<User>>(
            future: futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<User> users = snapshot.data!;
                return DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: users
                      .map((tuser) => DataRow(cells: [
                            DataCell(Text(tuser.id.toString())),
                            DataCell(Text(tuser.username)),
                            DataCell(
                              Row(
                                children: [
                                  ElevatedButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      deleteUser(tuser.id);
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
                                      updateUser(tuser.id);
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
    ))
    ;
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
            title: Text('Dishes'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to the home screen or any other screen
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dishes()));
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
