import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:livraison_repas/HomeDish.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class dishesDetail extends StatefulWidget {
  final dishes dish;
  const dishesDetail({Key? key, required this.dish});

  @override
  State<dishesDetail> createState() => _dishesDetailState();
}

class _dishesDetailState extends State<dishesDetail> {
  TextEditingController commentController = TextEditingController();
  int itemCount = 1;
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
            Text(
              'Name: ${widget.dish.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFC79A99),
                  ),
                  onPressed: () {},
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
                  onPressed: () async {

                    final prefs = await SharedPreferences.getInstance();
                    final authToken = prefs.getString('authToken');

                    final disheId = widget.dish.id;

                    // Prepare the data for the comment
                    final Map<String, dynamic> commentData = {
                      'comment': commentController.text,
                      'dishe': disheId,
                      //'user': userId,
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

                    // Check the response status
                    if (response.statusCode == 201) {
                      // Comment created successfully
                      // You can handle success accordingly
                    } else {
                      // Comment creation failed
                      // You can handle errors accordingly
                    }
                  },
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
