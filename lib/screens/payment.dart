import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slideshow/screens/category_2.dart';
import '../model/user_model.dart';
import 'home_screen.dart';

class Payment extends StatefulWidget {
  final int index1;
  Payment({required this.index1});
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late int Ind;
  final _auth = FirebaseAuth.instance;
  DateTime dateToday = DateTime(DateTime
      .now()
      .year, DateTime
      .now()
      .month, DateTime
      .now()
      .day);
  String? startDate;
  DatabaseReference userRef = FirebaseDatabase.instance.ref('Users');
  List<dynamic> growableList = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    Ind = widget.index1;
    _fetchListFromFirebase();
  }
  Future<void> _fetchListFromFirebase() async {
    // Read data from Firebase
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    DatabaseReference userEvent = await userRef.child(user.uid).child("purchasedCategories");
    Stream<DatabaseEvent> stream =  userEvent.onValue;
    stream.listen((DatabaseEvent event) {
      //print('Event Type: ${event.type}'); // DatabaseEventType.value;
     // var lem=event.snapshot.value.toString();
      //[[cat2]cat3]
      //map={lem.length :'cat' + Ind.toString()};
      //print('Snapshot: ${event.snapshot.value.toString()}'); // DataSnapshot
    //  myStringList.add(event.snapshot.value.toString());
      //event.snapshot.value?.toList();
     // print(event.snapshot.value);
     // print(event.snapshot.value.toString());
      List< dynamic> values = event.snapshot.value as List<dynamic>;
      print(values);


      growableList=values.toList();
      growableList.add('cat'+Ind.toString());
      //growableList.add('hello');

      print(growableList);
    });


    // if (dataSnapshot.value != null) {

    //   values.forEach((key, value) {
    //     myStringList.add(value.toString());
    //   });
    // }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        elevation: 20,
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Material(
          elevation: 15,
          child: TextButton(
            onPressed: () {
              startDate = dateToday.toString();
              postDetailsToFirestore();
            },
            child: Text("Purchase Premium"),
          ),
        ),
      ),
    );
  }
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    int len=growableList.length;

   // Map<int, String> map={len:'cat' + Ind.toString()};
    //print(map.length);
    //print(map);
    // print(myStringList);
    //   myStringList.add('cat' + Ind.toString());
     //  print(myStringList);
    await userRef.child(user.uid).child("purchasedCategories").set(growableList);
       //await userRef.child(user.uid).update({"purchasedCategories": Ind.toString()});
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
    }
}

//1. gif {sd, hd ready, fhd}
//2. audio
//3. mp4
//4. web()video 3gp
//5. no of folders se categories ka button

//*. 
//6. remote config
//7. realtime time database
//8. GCB in app purchase
//9. rohit.pielabs

//28-11-2023
//button should redirect to one category
//user data should be stored in realtime database
//3 different types should be there

//06-12-2023
//list all
//category name and icon and attribute(Paid and free)
//user list of purchased categories and validity (yet to be done)


//13/12/2023
//category stringify with index number    (done)
//paid and free(icon and fade).... snackbar  (done)
//in app purchase(conditions should be displyed) (explored)
//FireBase app check (explored and implemented but giving depricated error )


//
// icon should be there for the category(done)
// list should be updated in the user data()
// free category should not contain the icon(easy)

//ashutosh deshpande10:54 AM
// https://medium.flutterdevs.com/parsing-complex-json-in-flutter-b7f991611d3e
// ashutosh deshpande11:08 AM
// https://pub.dev/packages/snapshot
// https://stackoverflow.com/questions/59910101/how-to-handle-snapshot-data-with-hasdata-haserror-and-connectionstate-in-flutt
// ashutosh deshpande11:09 AM
// https://api.flutter.dev/flutter/widgets/SnapshotWidget-class.html#:~:text=A%20snapshot%20is%20a%20frozen,cannot%20rely%20on%20raster%20caching.
// ashutosh deshpande11:12 AM
// https://pub.dev/packages/snapshot
// ashutosh deshpande11:21 AM
// Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//
// map.values.toList()[index]["pic"]