import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:groceries_app/screens/home/cart/cartScreen.dart';
import 'package:groceries_app/screens/home/home/homeScreen.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';
import 'package:groceries_app/screens/home/favourite/favScreen.dart';
import 'package:groceries_app/screens/home/mainWidgets.dart';
import 'package:groceries_app/screens/home/user/userScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final cubit = context.read<HomeCubit>();

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if(state is HomeCartClearedState){
          Get.snackbar("Success", "Pls Wait While we refresh Screen", backgroundColor: Colors.green, colorText: Colors.white);
          cubit.getProducts();
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Scaffold(
              appBar: appbar(width, cubit),
              body: PageView(
                controller: cubit.pageController,
                onPageChanged: (index) {
                  cubit.BottomScreenChanged(index, false);
                },
                children: [
                  Home(cubit, width, height),
                  FavouritesScreen(
                    cubit: cubit,
                  ),
                  const CartScreen(),
                  const UserScreen(),
                ],
              ),
              bottomNavigationBar: bottomBar(cubit),
            );
          },
        ),
      ),
    );
  }

  

}
