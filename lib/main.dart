import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:groceries_app/helpers/dio_helpers.dart';
import 'package:groceries_app/helpers/hiver_helpers.dart';
import 'package:groceries_app/screens/login/cubit/login_cubit.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';
import 'package:groceries_app/screens/register/cubit/register_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/splash/splash_screen.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox(HiveHelpers.TokenBox);
  DioHelpers.init();

  // Set the token before running the app
  final token = HiveHelpers.getToken();
  if (token != null && token.isNotEmpty) {
    DioHelpers.setToken(token);
  }

  runApp(
    const MyApp()
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit()..getBanners()..getProducts()..getProfile()..getCartData(),
        ),
      ],
      child: const GetMaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
