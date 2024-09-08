import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Column boardingContent(double width, double height, List<String> list, int current, Function() OnNext) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: 
              Column(
                children: [
                  Image.asset("assets/images/boarding$current.png", height: height * 0.51,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/images/textboarding.png"),
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: Padding(
                          padding: const EdgeInsets.only(top:15.0),
                          child: Column(
                            children: [
                              const Icon(CupertinoIcons.ellipsis,color:  Color(0xFF5AC268)),
                              Text(list[current-1], style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color:Colors.black),textAlign: TextAlign.center,),
                              const SizedBox(height: 5,),    
                              const Text("It is a long established fact that a reader will be distracted by the readable.", style: TextStyle(color:Colors.black), textAlign:TextAlign.center,),
                              const SizedBox(height: 20,),
                               
                              GestureDetector(
                                onTap: OnNext,
                                child: const Icon(CupertinoIcons.arrow_right_circle_fill, size: 50,color: Color(0xFF5AC268),)
                              ),
                              const SizedBox(width: 20,child: Divider(thickness: 4,))
                            ]
                          ),
                        )
                      ),
                    ],
                  ),
                ]
              )
        )
      ],
    );
  }