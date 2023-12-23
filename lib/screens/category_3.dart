import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'home_screen.dart';
import 'login_screen.dart';
class Category_3 extends StatefulWidget {
  const Category_3({Key? key});
  @override
  State<Category_3> createState() => _Category_3State();
}

class _Category_3State extends State<Category_3> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  List<String> images = [];
  List<String> imagePath = [
    "fold/giphy (2).gif",
    "fold/giphy (1).gif",
    "fold/giphy.gif",
  ];


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
        title: const Text("Category 3"),
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
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                          : Container(),

                      // Image.network(
                      //   images[index%images.length],
                      //   fit: BoxFit.contain,
                      // )
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
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
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
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

















// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// class Category_2 extends StatefulWidget {
//   const Category_2({super.key});
//
//   @override
//   State<Category_2> createState() => _Category_2State();
// }
//
// class _Category_2State extends State<Category_2> {
//   var file;
//   localfile() {
//      file= File('WhatsApp/Media/WhatsApp Images');
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Material(
//           elevation: 10,
//           child: SizedBox(
//             height: 20,
//             child: Image.file(file)
//           ),
//         ),
//       )
//     );
//   }
// }
//











//
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class Category_2 extends StatefulWidget {
//   const Category_2({super.key});
//
//   @override
//   State<Category_2> createState() => _Category_2State();
// }
//
// class _Category_2State extends State<Category_2> {
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
//           newPath = newPath + "/RPSApp";
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
//     bool downloaded = await saveFile(
//         "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//         "video.mp4");
//     if (downloaded) {
//       print("File Downloaded");
//     } else {
//       print("Problem Downloading File");
//     }
//     setState(() {
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: loading
//             ? Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: LinearProgressIndicator(
//             minHeight: 10,
//             value: progress,
//           ),
//         )
//             : ElevatedButton.icon(
//             icon: Icon(
//               Icons.download_rounded,
//               color: Colors.white,
//             ),
//           //  color: Colors.blue,
//             onPressed: downloadFile,
//           //  padding: const EdgeInsets.all(10),
//             label: Text(
//               "Download File",
//               style: TextStyle(color: Colors.white, fontSize: 25),
//             )),
//       ),
//     );
//   }
// }


