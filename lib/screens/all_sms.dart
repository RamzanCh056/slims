import 'dart:convert';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_app/res/static_info.dart';
import '../models/smslist_model.dart';

class AllSms extends StatefulWidget {
  const AllSms({Key? key}) : super(key: key);

  @override
  State<AllSms> createState() => _AllSmsState();
}

class _AllSmsState extends State<AllSms> {
  List<MessagesModel> list = [];
  MessagesModel? select;


  bool isLoading = true;


  getList() async {
    print("token is ${StaticInfo.loginModel!.accessToken}");

    var headers = {
      'Authorization': 'Bearer ${StaticInfo.loginModel!.accessToken}',
    };

    var request = await http.post(
        Uri.parse('${StaticInfo.baseUrl}/sms/get-list'),
        headers: headers);

    var data = jsonDecode(request.body.toString());

    if (request.statusCode == 200) {
      List tempList = data['messages'];
      for (int i = 0; i < tempList.length; i++) {
        MessagesModel getList = MessagesModel.fromJson(tempList[i]);
        list.add(getList);
      }
      setState(() {
        isLoading = false;
      });
    } else {}
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  bool visibilityStatus() {
    for (int i = 0; i < list.length; i++) {
      if (list[i].isSelected!) {
        return true;
      }
    }
    return false;
  }
    selectAllStatus() {
      for (int i = 0; i < list.length; i++) {
        return list[i].isSelected! == true;
      }
      setState(() {

      });

    }


  _getPermission() async => await [
        Permission.sms,
      ].request();

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    if (result == SmsStatus.sent) {
      print("Message Sent");
      Get.snackbar(
        "Message Sent",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.green,
        messageText: const Text(
          "Message Sent successfully",
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } else {
      Get.snackbar(
        "Failed",
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        colorText: Colors.green,
        messageText: const Text(
          "Message Sending Failed",
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      print("Failed");
    }
  }

  Future<bool?> get _supportCustomSim async =>
      await BackgroundSms.isSupportCustomSim;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
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
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 30,
                color: Colors.white,
              )),
        ),
        body: SafeArea(
            child: isLoading
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
                : Column(
                    children: [

                      Container(
                        color: const Color(0xFF16385b),
                        child: TabBar(
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),

                            unselectedLabelColor: Colors.white,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color:  const Color(0xFF191970),),
                            tabs: const [
                              Tab(
                                text: 'Pending',
                              ),
                              Tab(
                                text: 'Failed',
                              ),
                              Tab(
                                text: 'sent',
                              ),
                            ]),
                      ),


                      Container(
                        height: 60,
                        color: Color(0xFF191970),
                        width: double.infinity,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "Select",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "Phone",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "SMS",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              // const Expanded(
                              //   child: Text(
                              //     "Delete",
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 18.0,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                            ],
                          ),
                        )),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Theme(
                                                  data:
                                                      Theme.of(context).copyWith(
                                                    unselectedWidgetColor:
                                                        const Color(0xFFFFC000),
                                                    disabledColor:
                                                        const Color(0xFFFFC000),
                                                  ),
                                                  child: Checkbox(
                                                    focusColor:
                                                        const Color(0xFFFFC000),
                                                    checkColor: Colors.black,
                                                    activeColor:
                                                        const Color(0xFFFFC000),
                                                    value:
                                                        list[index].isSelected!,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        list[index].isSelected =
                                                            !list[index]
                                                                .isSelected!;

                                                        setState(() {});
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  list[index].phone.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xFF191970),
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),

                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  list[index].msg.toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xFF191970),
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   width: 10,
                                              // ),
                                              // const Expanded(
                                              //   child: Icon(
                                              //     Icons.delete,
                                              //     color: Colors.red,
                                              //     size: 25,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Divider(
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 151, 151, 190),
                                          ),
                                        ],
                                      )),
                                ],
                              );
                            }),
                      ),
                      Visibility(
                          visible: visibilityStatus(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: MaterialButton(
                              color: const Color(0xFF191970),
                              minWidth: double.infinity,
                              height: 50,
                              onPressed: () async {
                                if (await _isPermissionGranted()) {
                                  if ((await _supportCustomSim)!) {

                                    // _sendMessage("09xxxxxxxxx", "Hello", simSlot: 1);
                                    for (int i = 0; i < list.length; i++) {
                                      if (list[i].isSelected!) {
                                        _sendMessage(list[i].phone!, list[i].msg!,
                                            simSlot: 1);
                                      }
                                    }
                                  } else {
                                    for (int i = 0; i < list.length; i++) {
                                      if (list[i].isSelected!) {
                                        _sendMessage(
                                            list[i].phone!, list[i].msg!);
                                      }
                                    }
                                  }
                                } else {
                                  _getPermission();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xFF191970),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Send",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                      Container(
                        height: 60,
                        color: Color(0xFF191970),
                        width: double.infinity,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: ListView.builder(itemBuilder: checkBox,
                            itemCount: 1,
                          )
                          // Row(
                          //   children: [
                          //     const Text(
                          //       "Select All",
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 18.0,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //
                          //   ],
                          // ),
                        )),
                      ),
                    ],
                  )),
      ),
    );
  }
  Widget checkBox(BuildContext context, int index) {

      return   Row(children: [
        Text("Select All",style: TextStyle(color: Colors.white),),
    Theme(
    data:
    Theme.of(context).copyWith(
    unselectedWidgetColor:
    const Color(0xFFFFC000),
    disabledColor:
    const Color(0xFFFFC000),
    ),
    child: Checkbox(
    focusColor:
    const Color(0xFFFFC000),
    checkColor: Colors.black,
    activeColor:
    const Color(0xFFFFC000),
    value: selectAllStatus(),
    onChanged: (value) {

    setState(() {
      list[index].isSelected =list[index].isSelected!;


    setState(() {});
    });
    },
    ),
    ),
      ],);

  }
}
