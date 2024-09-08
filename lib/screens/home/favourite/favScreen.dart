import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';

class FavouritesScreen extends StatelessWidget {
  final HomeCubit cubit;

  FavouritesScreen({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    // Filter the products that are liked
    final likedItems =
        cubit.Pmodel.data?.data?.where((item) => item.inFavorites!).toList() ?? [];

    if (likedItems.isEmpty) {
      return Center(
        child: Text(
          'No favourites yet',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(15.0),
      itemCount: likedItems.length,
      itemBuilder: (context, index) {
        final item = likedItems[index];
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: height * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    item.image ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? '',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "\$${item.price ?? 0}",
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                        SizedBox(width: 8),
                        if (item.oldPrice != null &&
                            item.oldPrice! > item.price!)
                          Text(
                            "\$${item.oldPrice ?? 0}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Row(children: [
                          Container(
                            width: width * 0.6,
                            child: ElevButton(
                                child: Text("Add to Cart"),
                                is_Delete: false,
                                index: index),
                          ),
                          Spacer(),
                          ElevButton(
                              child: Icon(Icons.delete),
                              is_Delete: true,
                              index: index),
                        ]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ElevatedButton ElevButton(
      {required Widget child, required bool is_Delete, required int index}) {
    return ElevatedButton(
      onPressed: () {
        if (is_Delete) {
          cubit.deleteHeart(index);
        }
      },
      child: child,
      style: ElevatedButton.styleFrom(
        backgroundColor: is_Delete
            ? Colors.red[300]
            : Colors.green[300], // Use backgroundColor instead of primary
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

String formatNumber(double number) {
  if (number >= 1000 && number < 1000000) {
    return '${(number / 1000).toStringAsFixed(1)}k';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else {
    return number.toStringAsFixed(0);
  }
}
