import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'log.dart';

class signup extends StatefulWidget {
  const signup({Key? key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordconfirmController = TextEditingController();


Future<void> SignUpUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/accounts/register/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'email' : emailController.text,
        'password': passwordController.text,
        'password_confirm' : passwordconfirmController.text,
        
      }),
      
    );


    if (response.statusCode == 201) {
      final token = jsonDecode(response.body)['access'];
      /*showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sigunp successfully'),
          content: Text('welcome.' + usernameController.text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );*/
      Navigator.pushReplacementNamed(context, '/login');
    } else if(passwordController.text != passwordconfirmController.text){
      // Authentication failed, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Password error'),
          content: Text('password and confirmation not match.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }else if(usernameController.text=='' || emailController.text == '' || passwordController.text == '' || 
    passwordconfirmController == ''){
      // Authentication failed, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Fields error'),
          content: Text('Enter all informations.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
    
    else {
       final responseData = jsonDecode(response.body);
       if(response.statusCode == 400 && responseData.containsKey('username')){
      // Authentication failed, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Username error'),
          content: Text('Username already exist.'),
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
                    'Sign Up',
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
       body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(    
              controller: usernameController,
              decoration: InputDecoration(
                border : OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
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
            SizedBox(height : 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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
            SizedBox(height : 10),
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
            SizedBox(height : 10),
            TextField(
              controller: passwordconfirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm password',
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
                    onPressed: () => SignUpUser(),
                    child: Text(
                      'Sign Up',
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
                      Text("Have already an account? "),
                      //Text(" create account" , style: TextStyle(color: Color(0xFFC79A99)),),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => log()),
                          );
                        },
                        child: Text(
                          " Login",
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
    );
  }
}