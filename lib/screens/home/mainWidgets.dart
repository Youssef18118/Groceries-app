import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';

BottomNavyBar bottomBar(HomeCubit cubit) {
  return BottomNavyBar(
    selectedIndex: cubit.selectedIndex,
    showElevation: true,
    onItemSelected: (index) {
      cubit.BottomScreenChanged(index, true);
    },
    items: [
      BottomNavyBarItem(
        icon: const Icon(Icons.home),
        title: const Center(child: Text('Home')),
        activeColor: Colors.red,
      ),
      BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.heart),
          title: const Center(child: Text('Favourites')),
          activeColor: Colors.pink),
      BottomNavyBarItem(
          icon: const Icon(CupertinoIcons.cart),
          title: const Center(child: Text('Cart')),
          activeColor: Colors.blue),
      BottomNavyBarItem(
          icon: const Icon(Icons.people),
          title: const Center(child: Text('User')),
          activeColor: Colors.purpleAccent),
    ],
  );
}


AppBar appbar(double width, HomeCubit cubit) {
  return AppBar(
    title: Row(
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.green,
        ),
        SizedBox(
          width: width * 0.05,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Home",
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 30,
                )
              ],
            ),
            Text(
              "Down Town, Cairo",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )
          ],
        ),
      ],
    ),
    actions: [
      InkWell(
        onTap: () {
          cubit.BottomScreenChanged(2, true);  
        },
        child: const Icon(CupertinoIcons.cart_fill),
      ),
      SizedBox(
        width: width * 0.04,
      )
    ],
  );
}