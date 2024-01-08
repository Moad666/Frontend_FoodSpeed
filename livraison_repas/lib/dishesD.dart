import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:livraison_repas/HomeDish.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class dishesDetail extends StatefulWidget {
  final dishes dish;
  const dishesDetail({Key? key, required this.dish});

  @override
  State<dishesDetail> createState() => _dishesDetailState();
}

class _dishesDetailState extends State<dishesDetail> {
  TextEditingController commentController = TextEditingController();
  int itemCount = 1;

// Add Comment
  Future<void> addComment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      final disheId = widget.dish.id;

      // Fetch the authenticated user's data
      final userResponse = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/get_authenticated_user/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      // Check the response status for fetching user data
      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        final userId = userData['id'];

        // Prepare the data for the comment
        final Map<String, dynamic> commentData = {
          'comment': commentController.text,
          'plat': disheId,
          'user': userId.toString(),
        };

        // Send a POST request to create a comment
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/create_comment/'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(commentData),
        );

        // Check the response status for the comment creation
        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Opinion added successfully.'),
              actions: [
                TextButton(
                  onPressed: () {Navigator.pop(context); commentController.clear();},
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Fields Error'),
              content: Text('Something went wrong.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle error when fetching user data
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch user data.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Handle error appropriately, e.g., show an error dialog.
    }
  }


// Add Favorite
 Future<void> addFavorite() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final disheId = widget.dish.id;

    // Fetch the authenticated user's data
    final userResponse = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/get_authenticated_user/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    // Check the response status for fetching user data
    if (userResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      final userId = userData['id'];

      // Check if the user has already ranked the dish
      final checkFavoriteResponse = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/check_favorite/$userId/$disheId/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (checkFavoriteResponse.statusCode == 200) {
        // User has already ranked the dish, show an error message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('You have already ranked this dish.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // User has not ranked the dish, proceed to add favorite
        final Map<String, dynamic> commentData = {
          'rank': 5,
          'user': userId.toString(),
          'plat': disheId,
        };

        // Send a POST request to create a comment
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/create_favorite/'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(commentData),
        );

        // Check the response status for the comment creation
        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Favorite added successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    commentController.clear();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Fields Error'),
              content: Text('Something went wrong.'),
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
    } else {
      // Handle error when fetching user data
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch user data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    print('Error: $e');
    // Handle error appropriately, e.g., show an error dialog.
  }
}


// Add Commande
Future<void> addCommande() async{
  try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      final disheId = widget.dish.id;

      // Fetch the authenticated user's data
      final userResponse = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/get_authenticated_user/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      // Check the response status for fetching user data
      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        final userId = userData['id'];

        // Prepare the data for the comment
        final Map<String, dynamic> commentData = {
          'status': "Processing",
          'dateCommande' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'plat': disheId,
          'user': userId.toString(),
        };

        // Send a POST request to create a comment
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/create_commande/'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(commentData),
        );

        // Check the response status for the comment creation
        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text('Command added successfully.'),
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
              title: Text('Fields Error'),
              content: Text('Something went wrong.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle error when fetching user data
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch user data.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Handle error appropriately, e.g., show an error dialog.
    }
  }

  @override
  Widget build(BuildContext context) {
    int dishId = widget.dish.id;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dish Details'),
        backgroundColor: Color(0xFFC79A99),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.dish.url,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Name: ${widget.dish.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                onPressed: () {
                  addFavorite();
                  print('favorite button clicked');
                },
                icon: Icon(Icons.favorite),
                color: Color(0xFFC79A99),
              ),
              ],
            ),
            SizedBox(height: 20),
            Text('Description: ${widget.dish.description}'),
            //SizedBox(height: 10),
            //Text('Price: \DH${widget.dish.prix.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Text('Ingredients: ${widget.dish.ingredients}'),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: 'Your opinion',
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
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFC79A99), // backgroundColor
                  ),
                  onPressed: addComment,
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price: \DH${widget.dish.prix.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (itemCount > 1) {
                            itemCount--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      '$itemCount',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          itemCount++;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                  ),
                  onPressed: addCommande,
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
