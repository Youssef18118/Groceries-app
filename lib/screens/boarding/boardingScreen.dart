import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get_core/src/get_main.dart";
import "package:get/get_navigation/get_navigation.dart";
import "package:groceries_app/const.dart";
import "package:groceries_app/screens/boarding/boardingWidgets.dart";
import "package:groceries_app/screens/login/Login.dart";

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding>{
  int current = 1;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF9F0),
        actions: [

          if(current < 3)...[
            const Text("Skip", style: TextStyle(color: Color(0xFF5ac268), fontSize: 20),), 
            const SizedBox(width:7),
            GestureDetector(
              onTap:(){
                Get.offAll(() => const Login());
              },
              child: const Icon(CupertinoIcons.arrow_right_circle_fill, size: 30,color: Color(0xFF5AC268),)
            ),
            const SizedBox(width:7),
        ],],
      ),
      body: boardingContent(width, height,list, current, (){
          if(current < 3){
            current++;
          }else{
            Get.offAll(() => const Login());
          }
          setState(() {});
        },),
    );
  }

  
}