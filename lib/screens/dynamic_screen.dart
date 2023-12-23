import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_1.dart';

class FolderListScreen extends StatefulWidget {
  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}
class _FolderListScreenState extends State<FolderListScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Categories");
  final userRef = FirebaseDatabase.instance.ref("Users");
  @override
  Widget build(BuildContext context) {
    int? selectedIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text('Folder List'),
      ),
      body: Column(
       children: [
         Expanded(
             child: Material(
               elevation: 10,
               child: Center(
                 child: FirebaseAnimatedList(
                   query: ref,
                   itemBuilder: (context,snapshot,animation,index){
                     return Card(
                       child: ListTile(
                         onTap: (){
                           if(snapshot.child('status').value.toString()=='paid')
                             {
                               ScaffoldMessenger.of(context).removeCurrentSnackBar();
                               var snackBar=  SnackBar(content: Text('This is a premium category'));
                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                             }
                           else{
                             selectedIndex=index;
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const Category_1(),
                                 settings: RouteSettings(
                                   arguments: selectedIndex,
                                 )
                             ));
                           }
                         },
                         title: Text(snapshot.child('title').value.toString()),
                         trailing: selectedIndex==index?Icon(Icons.lock_open) : null,
                       ),
                     );
                   },
                 ),
               ),
             ),
         ),
       ],
      )
    );
  }
}
