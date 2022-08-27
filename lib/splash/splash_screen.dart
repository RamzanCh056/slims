import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/login.dart';
import '../models/login_model.dart';
import '../res/static_info.dart';
import '../screens/home_page.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool tokens = token;
  late SharedPreferences preferences;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) async {
      preferences = value;
      if (preferences.getBool('isLoggedIn') ?? false) {
        print("the value of isLoggedIn");
        await loginFun();
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false);
        });
      }
    }).catchError((e) {
      print(e);
    });

    // getValidationData().whenComplete(() async {
    //   Timer(const Duration(seconds: 2),
    //       () => Get.to(token == null ? const LoginScreen() : const select()));
    // });
    super.initState();
  }

  // Future getValidationData() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   var obtainedEmail = sharedPreferences.getString('token');
  //   setState(() {
  //     token = obtainedEmail;
  //   });
  //   print(token);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  HexColor("#002147"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 240.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Image(
                        image: AssetImage(
                          "images/logo.png",
                        ),
                        height: 145.0,
                        width: 250.0,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 200.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginFun() async {
    var response = await http.post(
      Uri.parse(
        'http://cslims.com/api/user/login',
      ),
      body: {
        'email': preferences.getString('email'),
        'password': preferences.getString('password'),
      },
    );

    var map = jsonDecode(response.body);

    if (response.statusCode == 200) {
      LoginModel loginModel = LoginModel.fromJson(map);
      StaticInfo.loginModel = loginModel;
      Get.to(const HomePage());
      await preferences.setBool('isLoggedIn', true);
     // controller.locationpermision();
    } else {
      Get.to(LoginScreen());
    }
  }
}
