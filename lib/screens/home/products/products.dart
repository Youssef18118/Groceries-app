import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';

class ShowAllScreen extends StatelessWidget {
  const ShowAllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Products",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          final productData = cubit.Pmodel.data?.data ?? [];

          if (state is HomeProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productData.isEmpty) {
            return const Center(
              child: Text(
                "No Products Available",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75, 
            ),
            itemCount: productData.length,
            itemBuilder: (context, index) {
              final item = productData[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            item.image ?? '',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? 'Unknown Product',
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                              Text("\$${item.price ?? 0}"),
                              const SizedBox(width: 5),
                              if (item.oldPrice != null &&
                                  item.oldPrice! > item.price!)
                                Text(
                                  "\$${item.oldPrice ?? 0}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 8,
                      right: 0,
                      child: FloatingActionButton(
                        onPressed: () {
                          cubit.addProductToCart(item.id ?? 0);  
                        },
                        heroTag: null,
                        mini: true,
                        backgroundColor: Colors.green[300],
                        child: item.inCart ?? false
                          ? const Icon(Icons.delete, color: Colors.red)
                          : const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8),
                      child: InkWell(
                        onTap: () {
                          cubit.changeLike(index);
                        },
                        child: item.inFavorites ?? false
                          ? const Icon(CupertinoIcons.heart_fill, color: Colors.red)
                          : const Icon(CupertinoIcons.heart),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
