import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';

class FavouritesScreen extends StatelessWidget {
  final HomeCubit cubit;

  const FavouritesScreen({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    // Filter the products that are liked
    final likedItems =
        cubit.Pmodel.data?.data?.where((item) => item.inFavorites!).toList() ?? [];

    if (likedItems.isEmpty) {
      return const Center(
        child: Text(
          'No favourites yet',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15.0),
      itemCount: likedItems.length,
      itemBuilder: (context, index) {
        final item = likedItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "\$${item.price ?? 0}",
                          style: const TextStyle(fontSize: 16, color: Colors.green),
                        ),
                        const SizedBox(width: 8),
                        if (item.oldPrice != null &&
                            item.oldPrice! > item.price!)
                          Text(
                            "\$${item.oldPrice ?? 0}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: ElevButton(
                                child: const Text("Add to Cart"),
                                is_Delete: false,
                                index: index,
                                likedItems: likedItems,
                              ),
                            ),
                            const SizedBox(width: 10),  
                            ElevatedButton(
                              onPressed: () {
                                cubit.deleteHeart(index);  
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[300],  
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        );
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

  ElevatedButton ElevButton({
    required Widget child,
    required bool is_Delete,  
    required int index,
    required var likedItems,
  }) {
    final isInCart = likedItems[index].inCart ?? false;  

    return ElevatedButton(
      onPressed: () {
        cubit.addProductToCart(likedItems[index].id ?? 0);  
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isInCart ? Colors.red[300] : Colors.green[300],  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: isInCart ? const Text('Remove from Cart') : child,
    );




  }
}

