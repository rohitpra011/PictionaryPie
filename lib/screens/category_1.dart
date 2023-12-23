import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
class Category_1 extends StatefulWidget {
  const Category_1({Key? key});
  @override
  State<Category_1> createState() => _Category_1State();
}

class _Category_1State extends State<Category_1> {
  List<String> images = [];
  List<String> imagePath = [
    "fold/200440-World-Cup-Cricket-2023_01-830.webp",
    "fold/200440-World-Cup-Cricket-2023_02-830.webp",
    "fold/200440-World-Cup-Cricket-2023_03-830.webp",
  ];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    for (int i = 0; i < imagePath.length; i++) {
      try {
        String url = await FirebaseStorage.instance.ref(imagePath[i]).getDownloadURL();
        setState(() {
          images.add(url);
        });
      } catch (error) {
        print("Error loading image at index $i: $error");
        // You may want to set a placeholder image or handle the error differently.
      }
    }
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category 1"),
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
          const SizedBox(
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
