import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:slideshow/screens/payment.dart';
import 'category_screen.dart';
import 'login_screen.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("Categories");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        elevation: 20,
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _logout(context);
          },
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No data available'));
                }
                //Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
               // Map<String, dynamic>? data = (snapshot.data?.snapshot.value as Map<String, dynamic>?);
              //  Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value);
               else{
                  Map<dynamic, dynamic> map=snapshot.data!.snapshot.value as dynamic;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),

                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context , index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            //_onTileTap(context,, index);
                          },
                          title: Text(map['title']),
                          tileColor: map['status'] == 'notPurchased'
                              ? Colors.grey
                              : Colors.greenAccent,
                          trailing: map['status'].toString() == 'notPurchased'
                              ? Icon(Icons.lock_open)
                              : Icon(Icons.lock),
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

  void _onTileTap(BuildContext context, Map<String, dynamic>? data, int index) {
    int _selectedIndex = index;
    if (data?['status'].toString() == 'notPurchased') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Category Not Purchased'),
            content: Text('Make a payment to get access.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(index1: _selectedIndex + 1)));
                },
                child: Text('Pay'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Category_screen(index1: _selectedIndex + 1)));
    }
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

