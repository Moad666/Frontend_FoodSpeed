import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livraison_repas/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class log extends StatefulWidget {
  const log({Key? key});

  @override
  State<log> createState() => _log();
}

class _log extends State<log> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/token/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['access'];

      /*final prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);*/
      /*final prefs = FlutterSecureStorage();
      await prefs.write(key: 'authToken', value: token);*/

      final superuserResponse = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/is_superuser/'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      if (superuserResponse.statusCode == 200) {
        final isSuperuser = jsonDecode(superuserResponse.body)['is_superuser'];
        if (isSuperuser) {
          Navigator.pushReplacementNamed(context, '/Dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/Home');
        }
    } else if (usernameController.text == '' || passwordController.text == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Fields Error'),
          content: Text('Enter username and password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Authentication failed, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Authentication Error'),
          content: Text('Invalid username or password.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xFFC79A99),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(200))),
      ),
      body: SingleChildScrollView( child : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                labelText: 'Username',
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
            SizedBox(height: 30),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
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
            SizedBox(height: 50),
            Column(
              children: [
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => loginUser(),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC79A99),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                  child: Row(
                    children: [
                      Text("Don\'t have an account? "),
                      //Text(" create account" , style: TextStyle(color: Color(0xFFC79A99)),),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signup()),
                          );
                        },
                        child: Text(
                          "create account",
                          style: TextStyle(
                              color: Color(0xFFC79A99),
                              fontSize:15),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    ));
  }
}
