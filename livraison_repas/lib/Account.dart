import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late Future<Map<String, dynamic>> userData;
  late String token;

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('authToken') ?? '';

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/user_profile/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      // Handle errors gracefully
      print('Error fetching user data: $error');
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Use the user data to display information
            final user = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50, // Adjust the size as needed
                    backgroundImage: NetworkImage(
                        'https://i0.wp.com/www.repol.copl.ulaval.ca/wp-content/uploads/2019/01/default-user-icon.jpg?ssl=1'),
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'ID: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${user!['id']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Username: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${user!['username']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Email: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${user['email']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Date Joined: ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${user['date_joined']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
