
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceries_app/helpers/hiver_helpers.dart';
import 'package:groceries_app/screens/boarding/boardingScreen.dart';
import 'package:groceries_app/screens/home/mainScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


    
@override
void initState() {
  super.initState();
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;

    if (HiveHelpers.getToken() != null) {
      Get.offAll(() => const HomeScreen());
      return;
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Get.offAll(() => const onBoarding());
    });
  });
}



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: (width * 0.4),
              top: (height * 0.35)
            ),
            child: Image.asset('assets/images/logo.png'),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children : [
              Image.asset('assets/images/splash.png')
            ] 
          )
        ],
      ),
    );
  }
}
