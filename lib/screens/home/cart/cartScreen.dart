import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';
import 'package:groceries_app/screens/home/model/CartModel.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final List<CartItems> items = cubit.cartModel?.data?.cartItems ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cart Details',
              style: TextStyle(color: Colors.green),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  if (items.isNotEmpty) {
                    for (var item in items) {
                      cubit.deleteCart(item.id!);
                    }
                    cubit.clearCart();
                    cubit.getCartData();
                  }
                },
              ),
            ],
          ),
          body: items.isEmpty
              ? const Center(
                  child: Text(
                    "Cart is Empty",
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            cartItem(items[index], cubit),
                      ),
                    ),
                    const Divider(thickness: 2),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: summarySection(cubit),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget cartItem(CartItems item, HomeCubit cubit) {
    final Product? product = item.product;

    if (product == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network(
              product.image ?? '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Unknown Product',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text('Quantity: ${item.quantity}'),
                  const SizedBox(height: 5),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  cubit.addProductToCart(product.id ?? 0);
                  cubit.getCartData();
                },
                child: const Icon(Icons.delete, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget summarySection(HomeCubit cubit) {
    final subTotal = cubit.cartModel?.data?.subTotal ?? 0.0;
    final deliveryFee = subTotal * 0.10;
    final total = subTotal + deliveryFee;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subtotal',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '\$${subTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Delivery Fee',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '\$${deliveryFee.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
            child: Text(
              'Checkout',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}