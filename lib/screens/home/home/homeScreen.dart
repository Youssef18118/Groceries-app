import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';
import 'package:groceries_app/screens/home/product/productDetail.dart';
import 'package:groceries_app/screens/home/products/products.dart';

class HomePage extends StatefulWidget {
  final HomeCubit cubit;
  final double width;
  final double height;

  const HomePage({required this.cubit, required this.width, required this.height, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool retrying = false; // Track whether retrying is in progress

  @override
  Widget build(BuildContext context) {
    final cubit = widget.cubit;
    final width = widget.width;
    final height = widget.height;

    if (!cubit.isSnackBarShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait for 10 seconds until we load the products'),
            duration: Duration(seconds: 15), // Show for 15 seconds
          ),
        );
      });
      cubit.isSnackBarShown = true; 
    }

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
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          // Automatically retry loading banners if the image fails
                          Future.delayed(const Duration(seconds: 5), () {
                            cubit.getBanners();
                            if(cubit.First_time) {
                              cubit.getProducts();
                              cubit.First_time = false;
                            }
                          });
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'load failed',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          );
                        },
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
                  onTap: () {
                    Get.to(() => const ShowAllScreen());
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          retrying
              ? const CircularProgressIndicator() // Show loading indicator while retrying
              : BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeProductLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HomeProductErrorState) {
                      // Show retry button on error
                      return Column(
                        children: [
                          const Text(
                            'Failed to load products. Please check your connection.',
                            style: TextStyle(color: Colors.red),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                retrying = true;
                              });
                              // Retry the product fetching after a delay
                              Future.delayed(const Duration(seconds: 10), () {
                                if (cubit.filteredProducts.isEmpty) {  // Check if products are still not loaded
                                  setState(() {
                                    retrying = true;  // Trigger retrying state
                                  });

                                  cubit.getProducts();  // Retry fetching products

                                  setState(() {
                                    retrying = false;  // Stop retrying after triggering getProducts
                                  });
                                }
                              });

                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      );
                    }
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
            // We're directly using index, since items is already a sublist of productData
            final item = items[index]; 

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              width: width * 0.4,
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  InkWell(
                    onTap: (){
                      Get.to(() => ProductDetailScreen(product: item));
                    },
                    child: Column(
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
                                  item.image ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    // Automatically retry loading products if the image fails
                                    Future.delayed(const Duration(seconds: 5), () {
                                      cubit.getProducts();  // Retry fetching products after delay
                                    });
                                    return const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'load failed',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    );
                                  },
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
                                item.name ?? 'Unknown Product',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("\$${item.price ?? 0}"),
                                  const SizedBox(width: 5),
                                  if (item.oldPrice != null && item.oldPrice! > item.price!)
                                    Text(
                                      "\$${item.oldPrice ?? 0}",
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
                  ),
                  Positioned(
                    bottom: 8,
                    right: 0,
                    child: FloatingActionButton(
                      onPressed: () {
                        cubit.addProductToCart(item.id ?? 0);  // Use item.id directly
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
                        cubit.changeLike(item.id ?? 0);
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
        ),
      );
    },
  );
}
