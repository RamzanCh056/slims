import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/screens/web_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Controler/LocationController.dart';
import '../authentication/login.dart';
import 'all_sms.dart';
import 'map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool status = false;

  getData() async {
    CollectionReference usersref =
        FirebaseFirestore.instance.collection("coordenates");
    QuerySnapshot querySnapshot = await usersref.get();
    List<QueryDocumentSnapshot> listdocs = querySnapshot.docs;
    listdocs.forEach((element) {
      print(element.data());
      print("=========");
    });
  }

  UserLocation controller = Get.put(UserLocation());
  SharedPreferences? preferences;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) async {
      preferences = value;
      status = preferences?.getBool('val') ?? false;
      setState(() {});
      if (preferences?.getBool('val') ?? false) {
        print("timer called");
        Timer.periodic(
          const Duration(seconds: 10),
          (Timer t) => controller.locationpermision(),
        );
      } else {
        print('location off');
      }
    }).catchError((e) {
      print(e);
    });

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: const Text(
          "SLIMS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 14,
                backgroundImage: AssetImage("images/logo.png")),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SizedBox(
              height: 60,
              width: 83,
              child: FlutterSwitch(
                activeText: "Online",
                inactiveText: "offline",
                width: 83,
                height: 30,
                showOnOff: true,
                activeColor: Colors.green,
                inactiveColor: HexColor("#fe0000"),
                activeTextColor: Colors.white,
                inactiveTextColor: Colors.white,
                toggleColor: Colors.white,
                value: status,
                onToggle: (val) async {
                  await preferences?.setBool('val', val);
                  setState(() {
                    status = val;
                    if (val == true) {
                      controller.locationpermision();
                    } else if (val == false) {
                      print("Location is off");
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Select one",
                style: TextStyle(
                    color: Color(0xFF191970),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Column(
                  children: [
                    MaterialButton(
                      color: const Color(0xFF191970),
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {
                        Get.to(const WebViewStack());
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xFF191970),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Website",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: Colors.white,
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {
                        // Get.to(MyApp());

                        Get.to(const AllSms());
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "SMS",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF191970),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: const Color(0xFF191970),
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {
                        //   Get.to(const  UserInformation());
                        Get.to(const MapScreen());
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xFF191970),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Track",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Lorem Ipsum is simply dummy\ntext of the printing and  typeset-\nting industry",
                      style: TextStyle(
                          color: Color(0xFF191970),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      color: Colors.white,
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.setBool('isLoggedIn', false);
                        // final SharedPreferences sharedPreferences =
                        //     await SharedPreferences.getInstance();
                        // sharedPreferences.remove('token');
                        Get.to(const LoginScreen());
                        Get.snackbar(
                          "Logout",
                          "",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black,
                          borderRadius: 20,
                          margin: const EdgeInsets.all(15),
                          colorText: Colors.red,
                          messageText: const Text(
                            "Logout successfully",
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(seconds: 4),
                          isDismissible: true,
                          forwardAnimationCurve: Curves.easeOutBack,
                        );
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF191970),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
