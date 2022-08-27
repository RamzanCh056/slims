import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/models/login_model.dart';
import 'package:test_app/res/static_info.dart';
import '../Controler/LocationController.dart';
import '../screens/home_page.dart';

UserLocation controller = Get.put(UserLocation());

// ignore: camel_case_types
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// ignore: camel_case_types
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSwitched = false;
  bool status = false;
  bool _checkbox = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

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

      ),
      body: SafeArea(
          child: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 130,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@')) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: true,
                          autofocus: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            errorStyle: const TextStyle(
                                color: Colors.redAccent, fontSize: 15),
                            fillColor: Colors.white,
                            hintText: 'Password',
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.white,
                              ),
                              child: Checkbox(
                                focusColor: Colors.white,
                                checkColor: Colors.black,
                                activeColor: Colors.white,
                                value: _checkbox,
                                onChanged: (value) {
                                  setState(() {
                                    _checkbox = !_checkbox;
                                  });
                                },
                              ),
                            ),
                            const Text(
                              "Remember me?",
                              style: TextStyle(
                                color: Color(0xFF191970),
                                fontSize: 19.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        isLoading
                            ? const Center(
                                child: SizedBox(
                                    width: 80,
                                    child: LoadingIndicator(
                                        indicatorType: Indicator.ballBeat,
                                        colors: [
                                          Color.fromARGB(255, 1, 11, 66),
                                        ],
                                        strokeWidth: 2,
                                        pathBackgroundColor: Colors.blue)),
                              )
                            : MaterialButton(
                                color: const Color(0xFF191970),
                                minWidth: double.infinity,
                                height: 50,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    loginfun();
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xFF191970),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  loginfun() async {
    isLoading = true;
    setState(() {

    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = await http.post(
      Uri.parse(
        '${StaticInfo.baseUrl}/user/login',
      ),
      body: {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      },
    );

    var map = jsonDecode(response.body);

    if (response.statusCode == 200) {
      LoginModel loginModel = LoginModel.fromJson(map);
      StaticInfo.loginModel = loginModel;
      Get.snackbar(
        "Congratulations",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.green,
        messageText: const Text(
          "Login successfully",
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );

      await preferences.setBool('isLoggedIn', true);
      await preferences.setString('email', emailController.text.trim());
      await preferences.setString('password', passwordController.text.trim());

      Get.to(const HomePage());
     // controller.locationpermision();
      setState(() {
        isLoading = false;
      });
    } else {
      print(response.reasonPhrase);
      Get.snackbar(
        "${map['error']}",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.red,
        messageText: const Text(
          "Wrong credential",
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
