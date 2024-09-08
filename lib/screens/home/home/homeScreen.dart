import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';
import 'package:groceries_app/screens/home/products/products.dart';

Widget Home(HomeCubit cubit, double width, double height) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextField(
              onChanged: (query) {
                cubit.searchProducts(query);  
              },
              decoration: const InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
          ),
        ),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final bannerData = cubit.model?.data;
            if (state is HomeBannerLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return CarouselSlider(
              items: List.generate(
                bannerData?.length ?? 0,
                (i) => Container(
                  height: 150,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      bannerData?[i].image ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              options: CarouselOptions(
                height: 150,
                aspectRatio: 16 / 9,
                viewportFraction: .9,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Best Deal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: (){
                  Get.to(const ShowAllScreen());
                },
                child: const Text(
                  "See All",style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              )
            ],
          ),
        ),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return SizedBox(
              height: height * 0.45, 
              child: Column(
                children: [
                  Expanded(
                    child: productCard(width, height, isFirstHalf: true),
                  ),
                  Expanded(
                    child: productCard(width, height, isFirstHalf: false),
                  ),
                ],
              ),
            );
          },
        )
      ],
    ),
  );
}

Widget productCard(double width, double height, {required bool isFirstHalf}) {
  return BlocBuilder<HomeCubit, HomeState>(
    builder: (context, state) {
      final cubit = context.read<HomeCubit>();
      final productData = cubit.filteredProducts;  // Use the filtered products list

      if (state is HomeProductLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }

      int midIndex = (productData.length / 2).ceil();
      final items = isFirstHalf ? productData.sublist(0, midIndex) : productData.sublist(midIndex);

      return Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 15),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final itemIndex = isFirstHalf ? index : index + midIndex;

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              width: width * 0.4,
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.2,
                              height: height * 0.104,
                              child: Image.network(
                                items[index].image ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index].name ?? 'Unknown Product',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\$${items[index].price ?? 0}"),
                                const SizedBox(width: 5),
                                if (items[index].oldPrice != null &&
                                    items[index].oldPrice! > items[index].price!)
                                  Text(
                                    "\$${items[index].oldPrice ?? 0}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
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
                        cubit.addProductToCart(items[index].id ?? 0);  
                      },
                      heroTag: null,
                      mini: true,
                      backgroundColor: Colors.green[300],
                      child: items[index].inCart ?? false
                        ? const Icon(Icons.delete, color: Colors.red)  // Show delete icon if inCart is true
                        : const Icon(Icons.add, color: Colors.white),  // Show add icon if inCart is false
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8),
                    child: InkWell(
                      onTap: () {
                        cubit.changeLike(itemIndex);  // Toggle like status
                      },
                      child: items[index].inFavorites ?? false
                        ? const Icon(CupertinoIcons.heart_fill, color: Colors.red)
                        : const Icon(CupertinoIcons.heart),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
