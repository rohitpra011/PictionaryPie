// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:slideshow/screens/payment.dart';
// import 'category_screen.dart';
// import 'login_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference _ref = FirebaseDatabase.instance.ref("Categories");
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home"),
//         elevation: 20,
//         backgroundColor: Colors.redAccent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             _logout(context);
//           },
//         ),
//         centerTitle: true,
//       ),
//       resizeToAvoidBottomInset: false,
//       body: StreamBuilder(
//         stream: _ref.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return Center(child: Text('No data available'));
//           }
//           //Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//           Map<String, dynamic>? data = (snapshot.data?.snapshot.value as Map<String, dynamic>?);
//         //  Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value);
//
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 8.0,
//               mainAxisSpacing: 8.0,
//             ),
//             itemCount: data?.length,
//             itemBuilder: (context , index) {
//
//               return Card(
//                 child: ListTile(
//                   onTap: () {
//                     _onTileTap(context, data, index);
//                   },
//                   title: Text(data!['title'].toString()),
//                   tileColor: data['status'].toString() == 'notPurchased'
//                       ? Colors.grey
//                       : Colors.greenAccent,
//                   trailing: data['status'].toString() == 'notPurchased'
//                       ? Icon(Icons.lock_open)
//                       : Icon(Icons.lock),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   void _onTileTap(BuildContext context, Map<String, dynamic>? data, int index) {
//     int _selectedIndex = index;
//     if (data?['status'].toString() == 'notPurchased') {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Category Not Purchased'),
//             content: Text('Make a payment to get access.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(index1: _selectedIndex + 1)));
//                 },
//                 child: Text('Pay'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: Text('Cancel'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => Category_screen(index1: _selectedIndex + 1)));
//     }
//   }
//
//   Future<void> _logout(BuildContext context) async {
//     await _auth.signOut();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
//   }
// }
//
//

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:slideshow/screens/payment.dart';
import '../model/user_model.dart';
import 'category_screen.dart';
import 'login_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("Categories");
  //final DatabaseReference _userRef = FirebaseDatabase.instance.ref("Users");
// Local list to store purchased categories
  DatabaseReference userRef = FirebaseDatabase.instance.ref('Users');
  List<dynamic> growableList = List.empty(growable: true);
  List<dynamic> helperList = List.empty(growable: true);
  late bool status;
  void initState() {
    super.initState();
    status=false;
    //Ind = widget.index1;
    _fetchListFromFirebase();
    fetchStatus();
  }
  Future<void> fetchStatus() async {

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
      List< dynamic> values = event.snapshot.value as List<dynamic>;
      print(values);
      growableList=values.toList();
    });
    setState(() {});
  }
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
            child: Material(
              elevation: 10,
              child: Center(
                child: FirebaseAnimatedList(
                  query: _ref,
                  itemBuilder: (context, snapshot, animation, index) {
                    // bool status;
                    status=false;
                   growableList.forEach((item){
                     if(item=='cat'+(index+1).toString())
                       {
                           status=true;
                       }
                   });

                   //  for(int i=0;i<growableList.length;i++){
                   //    if(growableList[i]=='cat'+(index+1).toString())
                   //      {
                   //        status=true;
                   //      }
                   //  }
                   // helperList=['cat'+index.toString()];
                    return  Column(
                      children: [
                        Material(
                            elevation: 5,
                                //Text(snapshot.child('title').value.toString());
                                //child: Image.network(snapshot.child('url').value.toString())),
                                  child: SizedBox(
                                    width: 300,
                                    child: Column(
                                      children: [
                                        Image.network(height:300,width:500,snapshot.child('url').value.toString()),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(10.0),
                                          title: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(snapshot.child('title').value.toString())),
                                          //tileColor: snapshot.child('status').value.toString() == 'notPurchased'?Colors.grey:Colors.greenAccent,
                                          //trailing: status?Icon(Icons.lock_open):Icon(Icons.lock),
                                          // onTap: () {
                                          //
                                          //   //_onTileTap(context, snapshot, index, false);
                                          // },
                                          trailing: status?IconButton(onPressed:() {_onTileTap(context, snapshot, index, true);}, icon: Icon(Icons.lock_open)):IconButton(onPressed:(){_onTileTap(context, snapshot, index, false);}, icon: Icon(Icons.lock),),
                                        ),
                                      ],
                                    ),
                                  ),

                        ),
                        SizedBox(height: 16,)
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTileTap(BuildContext context, DataSnapshot snapshot, int index,bool status1) {
    int _selectedIndex = index;
    if (!status1) {
      // var snackBar = SnackBar(content: Text('You have not purchased this category, kindly make payment and get access'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Category Not Purchased'),
            content: Text('Make a payment to get access.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(index1: _selectedIndex+1)));
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => Category_screen(index1: _selectedIndex+1)));
    }
  }
  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

//before faded
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'category_1.dart';
// import 'category_2.dart';
// import 'category_screen.dart';
// import 'login_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//
//   final auth = FirebaseAuth.instance;
//   final ref = FirebaseDatabase.instance.ref("Categories");
//   final userRef = FirebaseDatabase.instance.ref("Users");
//
//   @override
//   Widget build(BuildContext context) {
//     int selectedIndex;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Home"),
//           elevation: 20,
//           backgroundColor: Colors.redAccent,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () {
//               logout(context);
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
//             },
//           ),
//           centerTitle: true,
//         ),
//         resizeToAvoidBottomInset: false,
//         body: Column(
//           children: [
//             Expanded(
//               child: Material(
//                 elevation: 10,
//                 child: Center(
//                   child: FirebaseAnimatedList(
//                     query: ref,
//                     itemBuilder: (context,snapshot,animation,index){
//                       Widget trailingIcon;
//                       if (snapshot.child('status').value.toString()=='notPurchased') {
//                         trailingIcon = Icon(Icons.lock);
//                       } else {
//                         trailingIcon = Icon(Icons.lock_open);
//                       }
//                       return Card(
//                         child: ListTile(
//                           onTap: (){
//                             selectedIndex=index;
//                             if(snapshot.child('status').value.toString()=='notPurchased')
//                               {
//                                 var snackBar=  SnackBar(content: Text('You have not purchased this category, kindly make payment and get access'));
//                                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                               }
//                             else
//                               {
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => Category_screen(index1: selectedIndex+1),));
//                               }
//                           },
//                           title: Text(snapshot.child('title').value.toString()),
//                           trailing: trailingIcon,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )
//     );
//   }
//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
//   }
// }











//dynamic bnane se pehle ka code


// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:slideshow/model/user_model.dart';
// import 'package:slideshow/screens/category_1.dart';
// import 'package:slideshow/screens/payment.dart';
// import 'category_2.dart';
// import 'category_3.dart';
// import 'dynamic_screen.dart';
// import 'login_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   User? user= FirebaseAuth.instance.currentUser;
//   UserModel loggedInUser = UserModel();
//   @override
//   void initState(){
//     super.initState();
//     FirebaseFirestore.instance
//     .collection("users")
//     .doc(user!.uid)
//     .get()
//     .then((value){
//       this.loggedInUser =UserModel.fromMap(value.data());
//       setState(() {});
//     });
//   }
//
//   String statusgetter(){
//     return "${loggedInUser.premiumStatus}";
//   }
//
//  //data downloading
//   final Dio dio = Dio();
//   bool loading = false;
//   double progress = 0;
//
//   Future<bool> saveFile(String url, String fileName) async {
//     Directory? directory;
//     try {
//       if (Platform.isAndroid) {
//         if (await _requestPermission(Permission.manageExternalStorage)) {
//           directory = await getExternalStorageDirectory();
//           String newPath = "";
//           print(directory);
//           List<String>? paths = directory?.path.split("/");
//           for (int x = 1; x < paths!.length; x++) {
//             String? folder = paths?[x];
//             if (folder != "Android") {
//               newPath += "/" + folder!;
//             } else {
//               break;
//             }
//           }
//           newPath = newPath + "/PictionaryPie";
//           directory = Directory(newPath);
//         } else {
//           return false;
//         }
//       } else {
//         if (await _requestPermission(Permission.photos)) {
//           directory = await getTemporaryDirectory();
//         } else {
//           return false;
//         }
//       }
//       File saveFile = File(directory.path + "/$fileName");
//       if (!await directory.exists()) {
//         await directory.create(recursive: true);
//       }
//       if (await directory.exists()) {
//         await dio.download(url, saveFile.path,
//             onReceiveProgress: (value1, value2) {
//               setState(() {
//                 progress = value1 / value2;
//               });
//             });
//         if (Platform.isIOS) {
//           await ImageGallerySaver.saveFile(saveFile.path,
//               isReturnPathOfIOS: true);
//         }
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print(e);
//       return false;
//     }
//   }
//
//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   downloadFile() async {
//     setState(() {
//       loading = true;
//       progress = 0;
//     });
//     //Navigator.push(context, MaterialPageRoute(builder: (context) => const Category_2()));
//     bool downloaded =await saveFile("https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_01-830.webp?alt=media&token=7e51d4ba-16e9-44eb-ba0f-d6eda3e5e79e", "image.jpg");
//     // bool downloaded = await saveFile(
//     //     "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4", "video.mp4");
//     if (downloaded) {
//       print("File Downloaded");
//       //Navigator.push(context, MaterialPageRoute(builder: (context) => const Category_2()));
//     } else {
//       print("Problem Downloading File");
//     }
//     setState(() {
//       loading = false;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     //category 1 button
//     final category1= Material(
//       elevation: 5,
//       color: Colors.redAccent,
//       borderRadius: BorderRadius.circular(30),
//       child: MaterialButton(
//         padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         minWidth: MediaQuery.of(context).size.width,
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => FolderListScreen()));
//         },
//         child: const Text(
//           "Category 1",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//
//     //category 2 button
//     final category2= Material(
//       elevation: 5,
//       color: Colors.redAccent,
//       borderRadius: BorderRadius.circular(30),
//       child: MaterialButton(
//         padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         minWidth: MediaQuery.of(context).size.width,
//         onPressed:(){
//           print("${loggedInUser.premiumStatus}");
//           if("${loggedInUser.premiumStatus}"=="True")
//           {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const Category_2()));
//           }
//           else{
//                var snackBar=  SnackBar(content: Text('You are not a premium user, please buy premium to see this category'));
//                ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                //ScaffoldMessenger.of(context).showMaterialBanner(materialBanner)
//           }
//         },
//
//          // _showDialog(context);
//             //downloadFile,
//         child: const Text(
//           "Category 2",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home"),
//         elevation: 20,
//         backgroundColor: Colors.redAccent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             logout(context);
//            // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
//           },
//         ),
//         centerTitle: true,
//       ),
//       resizeToAvoidBottomInset: false,
//       body:Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Material(
//               elevation: 15,
//               child: TextButton(
//                 onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment()));
//                 },
//                 child: Text("Buy Premium"),
//               ),
//             ),
//             category1,
//             SizedBox(height: 25,),
//             category2,
//             SizedBox(height: 25,),
//           ],
//         ),
//       ),
//     );
//   }
//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
//   }
// }

//dynamic bnane se pehle ka code upr vala










// class HomeScreen extends StatelessWidget {
//    HomeScreen({super.key});
//
//
//
//
//
//    // data downloading
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home"),
//         elevation: 20,
//         backgroundColor: Colors.redAccent,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             // passing this to our root
//             //Navigator.pop(context);
//             //Navigator.of(context).pop();
//             Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) =>  const LoginScreen()));
//           },
//         ),
//         centerTitle: true,
//       ),
//       resizeToAvoidBottomInset: false,
//       body:Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //category1
//             Material(
//               elevation: 5,
//               color: Colors.redAccent,
//               borderRadius: BorderRadius.circular(30),
//               child: MaterialButton(
//                 padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//                 onPressed: () {
//                   if (FirebaseAuth.instance.currentUser != null) {
//                     Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) => const Category_1()));
//                     //Navigator.pop(context);
//                   } else {
//                     //Fluttertoast.showToast(msg: "User not authenticated");
//                   }
//                 },
//                 child: const Text(
//                   "Category 1",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(height: 25,),
//
//             //category2
//             Material(
//               elevation: 5,
//               color: Colors.redAccent,
//               borderRadius: BorderRadius.circular(30),
//               child: MaterialButton(
//                 padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//                 onPressed: () {
//                   showDialog(context: context, builder: (context) {
//                    return Center(
//                      child: Container(
//                        child: AlertDialog(
//                          title: Text("Request Access?"),
//                          actions: [
//                            TextButton(onPressed: (){
//
//
//
//
//                              if (FirebaseAuth.instance.currentUser != null) {
//                                Navigator.of(context).pushReplacement(
//                                    MaterialPageRoute(builder: (context) => const Category_2()));
//                                //Navigator.pop(context);
//                              } else {
//                                const snackBar = SnackBar(
//                                    content: Text('Yay! A SnackBar!'),
//                                );
//                                //Fluttertoast.showToast(msg: "User not authenticated");
//                              }
//                            }, child: Text("Okay")),
//                            TextButton(
//                                child: Text("Cancel"),
//                                onPressed: (){
//                                   Navigator.pop(context);
//                            },)
//                          ],
//                        ),
//                      ),
//                    );
//                   });
//                 },
//                 child: const Text(
//                   "Category 2",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             SizedBox(height: 25,),
//           ],
//         ),
//       ),
//     );
//   }
// }























// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
// //code-spaces
// class _HomeScreenState extends State<HomeScreen> {
//   List<String> images=[];
//   List<String> imagePath=["fold/200440-World-Cup-Cricket-2023_01-830.webp",
//    "fold/200440-World-Cup-Cricket-2023_02-830.webp",
//     "fold/200440-World-Cup-Cricket-2023_03-830.webp"
//   ];
//
// _HomeScreenState() {
//   int max=imagePath.length;
//   for(int i=0;i<max;i++){
//     FirebaseStorage.instance
//         .ref(imagePath[i])
//         .getDownloadURL()
//         .then((url) {
//     print("Here is the URL of Image $url");
//     images.add(url);
//     }).catchError((onError) {
//     print("Got Error hello hello $onError");
//     });
//     }
//   }
//   int currentIndex=0;
//   // List<String> images=[
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/ll.webp?alt=media&token=c178a48c-0017-48be-8fc6-cb9a4bb18ea4&_gl=1*2wmgni*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczODQ5NC4yOS4xLjE2OTc3Mzg1NzcuMzguMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_01-830.webp?alt=media&token=7e51d4ba-16e9-44eb-ba0f-d6eda3e5e79e&_gl=1*yyhv63*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzIwNzkuNTAuMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_02-830.webp?alt=media&token=13de46a4-6d9a-4dd0-a3c4-373a5033208a&_gl=1*1xomi4m*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzI4MTIuNTkuMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_03-830.webp?alt=media&token=5724933d-cd60-4d77-a2cf-6b9d254963a0&_gl=1*tlp85f*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzI5ODMuNTguMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_04-830.webp?alt=media&token=97c4ab90-1a64-4410-a21a-a60be4a7b392&_gl=1*vqm2mq*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwMDEuNDAuMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_05-830.webp?alt=media&token=64615114-8e7c-4706-8337-98059c86101a&_gl=1*1ex36ld*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwMjEuMjAuMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_06-830.webp?alt=media&token=53cb302a-5038-491b-aa6f-b5d49672c64c&_gl=1*tez806*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwNDcuNTcuMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_07-830.webp?alt=media&token=5743c4a8-22ae-40d2-8fb8-795b6d65cac5&_gl=1*2tnmej*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwNjkuMzUuMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_08-830.webp?alt=media&token=d43a224f-f286-4336-800b-35925909ea1e&_gl=1*kzskgi*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwOTIuMTIuMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_09-830.webp?alt=media&token=1434c4dc-a342-4e29-abf4-84f095590b1f&_gl=1*x0lhdw*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMxMzUuNTguMC4w",
//   //   "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_10-830.webp?alt=media&token=a46a7f64-f396-4711-85ba-90f9af5add79&_gl=1*1ij2jwn*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMxNTUuMzguMC4w",
//   // ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           appBar: AppBar(
//             title: const Text("PictionaryPie"),
//             elevation: 20,
//             backgroundColor: Colors.redAccent,
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () {
//                 // passing this to our login Screen
//                 Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => const LoginScreen()));
//               },
//             ),
//           ),
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Material(
//           //   elevation: 5,
//           //   child: Container(
//           //     child: Text("ICC Cricket World Cup 2023"),
//           //   ),
//           // ), this widget was creating *pixel overflow* like things
//           SizedBox(
//             height: 400,
//             width: double.infinity,
//             child: PageView.builder(
//                 onPageChanged: (index){
//                   setState(() {
//                     currentIndex=index%images.length;//edit
//                   });
//                 },
//                 //itemCount: images.length,
//                 itemBuilder: (context,index){
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//                     child: Material(
//                       elevation: 6,
//                       child: SizedBox(
//                         height: 500,
//                         width: double.infinity,
//                         child: Image.network(
//                           images[index%images.length],//edit
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//
//             children: [
//               for(var i=0;i<images.length;i++) buildIndicator(currentIndex==i)
//
//             ],),
//           ActionChip(
//               label: const Text("Logout"),
//               onPressed: () {
//                 logout(context);
//               }),
//         ],
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   Widget buildIndicator(bool isSelected) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 2),
//       child: Container(
//         height: isSelected ? 12 : 8,
//         width: isSelected ? 12 : 8,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isSelected ? Colors.black : Colors.grey,
//         ),
//
//       ),
//     );
//   }
//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const LoginScreen()));
//   }
// }
