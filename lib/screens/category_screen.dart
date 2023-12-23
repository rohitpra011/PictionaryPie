import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
class Category_screen extends StatefulWidget {
  final int index1;

  Category_screen({required this.index1});

  @override
  State<Category_screen> createState() => _Category_screenState();
}

class _Category_screenState extends State<Category_screen> {
  late int Ind;
  List<String> images = [];
  var storageRef;

  @override
  void initState() {
    super.initState();
    Ind=widget.index1;
    fetchImageUrls();
  }
  Future<void> fetchImageUrls() async {
    try {
      // Create a Reference to the storage folder
      String category="Category"+Ind.toString();
      storageRef = FirebaseStorage.instance.ref(category);

      // List all items in the storage folder
      var result = await storageRef.listAll();
      for (var imageRef in result.items) {
        String url = await imageRef.getDownloadURL();
        setState(() {
          images.add(url);
        });
      }
    } catch (error) {
      print("Error loading images: $error");
      // Handle the error as needed
    }
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        elevation: 20,
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  HomeScreen()));
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex =index%images.length;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Material(
                    elevation: 6,
                    child: SizedBox(
                      height: 500,
                      width: double.infinity,
                      child: Image.network(
                        images[index%images.length],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < images.length; i++) buildIndicator(currentIndex == i)
            ],
          ),
          ActionChip(
            label: const Text("Logout"),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        height: isSelected ? 12 : 8,
        width: isSelected ? 12 : 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
