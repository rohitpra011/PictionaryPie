import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex=0;
  List<String> images=[
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/ll.webp?alt=media&token=c178a48c-0017-48be-8fc6-cb9a4bb18ea4&_gl=1*2wmgni*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczODQ5NC4yOS4xLjE2OTc3Mzg1NzcuMzguMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_01-830.webp?alt=media&token=7e51d4ba-16e9-44eb-ba0f-d6eda3e5e79e&_gl=1*yyhv63*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzIwNzkuNTAuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_02-830.webp?alt=media&token=13de46a4-6d9a-4dd0-a3c4-373a5033208a&_gl=1*1xomi4m*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzI4MTIuNTkuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_03-830.webp?alt=media&token=5724933d-cd60-4d77-a2cf-6b9d254963a0&_gl=1*tlp85f*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzI5ODMuNTguMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_04-830.webp?alt=media&token=97c4ab90-1a64-4410-a21a-a60be4a7b392&_gl=1*vqm2mq*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwMDEuNDAuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_05-830.webp?alt=media&token=64615114-8e7c-4706-8337-98059c86101a&_gl=1*1ex36ld*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwMjEuMjAuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_06-830.webp?alt=media&token=53cb302a-5038-491b-aa6f-b5d49672c64c&_gl=1*tez806*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwNDcuNTcuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_07-830.webp?alt=media&token=5743c4a8-22ae-40d2-8fb8-795b6d65cac5&_gl=1*2tnmej*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwNjkuMzUuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_08-830.webp?alt=media&token=d43a224f-f286-4336-800b-35925909ea1e&_gl=1*kzskgi*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMwOTIuMTIuMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_09-830.webp?alt=media&token=1434c4dc-a342-4e29-abf4-84f095590b1f&_gl=1*x0lhdw*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMxMzUuNTguMC4w",
    "https://firebasestorage.googleapis.com/v0/b/slideshow-fd4a8.appspot.com/o/200440-World-Cup-Cricket-2023_10-830.webp?alt=media&token=a46a7f64-f396-4711-85ba-90f9af5add79&_gl=1*1ij2jwn*_ga*MTAzOTgyMDExOC4xNjk2NTM4NzA0*_ga_CW55HF8NVT*MTY5NzczMDU3OC4yNy4xLjE2OTc3MzMxNTUuMzguMC4w",
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
          appBar: AppBar(
            title: const Text("PictionaryPie"),
            elevation: 20,
            backgroundColor: Colors.redAccent,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // passing this to our login Screen
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
          ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Material(
          //   elevation: 5,
          //   child: Container(
          //     child: Text("ICC Cricket World Cup 2023"),
          //   ),
          // ), this widget was creating *pixel overflow* like things
          SizedBox(
            height: 400,
            width: double.infinity,
            child: PageView.builder(
                onPageChanged: (index){
                  setState(() {
                    currentIndex=index%images.length;//edit
                  });
                },
                //itemCount: images.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Material(
                      elevation: 6,
                      child: SizedBox(
                        height: 500,
                        width: double.infinity,
                        child: Image.network(
                          images[index%images.length],//edit
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
          SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              for(var i=0;i<images.length;i++) buildIndicator(currentIndex==i)

            ],),
          ActionChip(
              label: Text("Logout"),
              onPressed: () {
                logout(context);
              }),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
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






  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Welcome"),
  //       centerTitle: true,
  //     ),
  //     body: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             SizedBox(
  //               height: 150,
  //               child: Image.asset("assets/logo.png", fit: BoxFit.contain),
  //             ),
  //             const Text(
  //               "Welcome Back",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             const Text("Name",
  //                 style: TextStyle(
  //                   color: Colors.black54,
  //                   fontWeight: FontWeight.w500,
  //                 )),
  //             const Text("Email",
  //                 style: TextStyle(
  //                   color: Colors.black54,
  //                   fontWeight: FontWeight.w500,
  //                 )),
  //             const SizedBox(
  //               height: 15,
  //             ),
  //             ActionChip(
  //                 label: const Text("Logout"),
  //                 onPressed: () {}),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
