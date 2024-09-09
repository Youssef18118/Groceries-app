import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';
import 'package:groceries_app/screens/home/model/ProductModel.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductData product; // Model of the product

  const ProductDetailScreen({required this.product, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final cubit = BlocProvider.of<HomeCubit>(context); // Access the HomeCubit

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'Product Details'),
        actions: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  cubit.changeLike(product.id ?? 0); // Toggle like status
                },
                icon: product.inFavorites ?? false
                    ? const Icon(CupertinoIcons.heart_fill, color: Colors.red)
                    : const Icon(CupertinoIcons.heart),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: height * 0.4,
              child: Image.network(
                product.image ?? '',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name ?? 'Unknown Product',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "\$${product.price ?? 0}",
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                const SizedBox(width: 8),
                if (product.oldPrice != null &&
                    product.oldPrice! > product.price!)
                  Text(
                    "\$${product.oldPrice ?? 0}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          cubit.addProductToCart(product.id ?? 0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: product.inCart ?? false
                              ? Colors.red[300]
                              : Colors.green[300],
                        ),
                        child: Text(product.inCart ?? false
                            ? 'Remove from Cart'
                            : 'Add to Cart'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
