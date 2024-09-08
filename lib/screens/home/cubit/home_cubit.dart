import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:groceries_app/helpers/dio_helpers.dart';
import 'package:groceries_app/screens/home/model/BannersModel.dart';
import 'package:groceries_app/screens/home/model/CartModel.dart';
import 'package:groceries_app/screens/home/model/ProductModel.dart';
import 'package:groceries_app/screens/home/model/ProfileModel.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int selectedIndex = 0;
  final PageController pageController = PageController();  
  BannerModel model = BannerModel();
  ProductModel Pmodel = ProductModel();
  ProfileModel Profmodel = ProfileModel();
  CartModel cartModel = CartModel();
  bool isLiked = false;
  bool addedToCart = false;
  List filteredProducts = [];  


  void BottomScreenChanged(int index, bool isBottomBarClick) {
    selectedIndex = index;
    if (isBottomBarClick) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
    emit(HomeScreenChangedState(index)); 
  }

  void getBanners() async{
    emit(HomeBannerLoadingState());

    try{
      var reponse = await DioHelpers.getData(
        path: "banners"
      );

      model = BannerModel.fromJson(reponse.data);
      if(model.status?? false){
        emit(HomeBannerSuccessState());
      }else{
        emit(HomeBannerErrorState("Failed to get banners"));
      }


    }catch(e){

      emit(HomeBannerErrorState(e.toString()));
    }
  }

  void getProducts() async {
    emit(HomeProductLoadingState());

    try {
      var response = await DioHelpers.getData(
        path: "products",
      );

      Pmodel = ProductModel.fromJson(response.data);
      filteredProducts = Pmodel?.data?.data ?? [];  

      if (Pmodel?.status ?? false) {
        emit(HomeProductSuccessState());
      } else {
        emit(HomeProductErrorState("Failed to get products"));
      }
    } catch (e) {
      emit(HomeProductErrorState(e.toString()));
    }
  }


  void getProfile() async {
    emit(HomeProfileLoadingState());

    try {
      var response = await DioHelpers.getData(
        path: "profile",
      );

      Profmodel = ProfileModel.fromJson(response.data);

      if (Profmodel.status ?? false) {
        emit(HomeProfileSuccessState());
      } else {
        emit(HomeProfileErrorState("Failed to get Profile"));
      }
    } catch (e) {
      // print('Error: $e'); // Debugging line
      emit(HomeProfileErrorState(e.toString()));
    }
  }

  void resetNavigationIndex() {
    selectedIndex = 0;
    emit(HomeScreenChangedState(0)); 
  }

  void changeLike(int index) {
    final product = Pmodel.data?.data?[index];
    if (product != null) {
      product.inFavorites = !product.inFavorites!;  
      emit(HomeHeartChanged());
    }
  }


  void deleteHeart(int index) {
    final likedItems = Pmodel.data?.data?.where((item) => item.inFavorites!).toList();
    
    if (likedItems != null && likedItems.isNotEmpty) {
      final product = likedItems[index];
      product.inFavorites = false;  

      final originalProductIndex = Pmodel.data?.data?.indexWhere((item) => item.id == product.id);
      if (originalProductIndex != null && originalProductIndex >= 0) {
        Pmodel.data?.data?[originalProductIndex].inFavorites = false;
      }

      emit(HomeHeartChanged());
    }
  }


  void ChangeAddToCatIcon(int index) {
    final product = Pmodel.data?.data?[index];
    if (product != null) {
      product.inCart = !(product.inCart ?? false);  
      emit(HomeProductSuccessState());
    }
  }



 void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String image,
  }) async {
    emit(HomeProfileLoadingState());

    try {
      final response = await DioHelpers.putData(
        path: 'update-profile',
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'image': image,
        },
      );


      if (response.data['status']) {
        Profmodel.data?.update(response.data['data']);
        emit(HomeProfileSuccessState());
      } else {
        emit(HomeProfileErrorState(response.data['message']));
      }
    } catch (e) {
      emit(HomeProfileErrorState(e.toString()));
    }

  }


  void changePassword({
    required String current_password,
    required String new_password
  })async {
    emit(HomePasswordLoadingState());

    try {
      final response = await DioHelpers.postData(
        path: 'change-password',
        body: {
          'current_password': current_password,
          'new_password': new_password,
        },
      );


      if (response.data['status']) {
        emit(HomePasswordSuccessState());
      } else {
        emit(HomePasswordErrorState(response.data['message']));
      }
    } catch (e) {
      emit(HomePasswordErrorState(e.toString()));
    }
  }

  void getCartData() async {
    emit(HomeCartLoadingState());

    try {
      var response = await DioHelpers.getData(
        path: "carts",
      );

      cartModel = CartModel.fromJson(response.data);

      if (cartModel.status ?? false) {
        emit(HomeCartSuccessState());
      } else {
        emit(HomeCartErrorState(response.data['message']));
      }
    } catch (e) {
      // print('Error: $e'); // Debugging line
      emit(HomeCartErrorState(e.toString()));
    }
  }

  void addProductToCart(int id) async {
    if (id == 0) {
      emit(HomeProductErrorState("Invalid product id"));
      return;
    }

    try {
      final response = await DioHelpers.postData(
        path: 'carts',
        body: {
          'product_id': id,
        },
      );

      if (response.data['status']) {
        final productIndex = Pmodel.data?.data?.indexWhere((item) => item.id == id);
        if (productIndex != null && productIndex >= 0) {
          final product = Pmodel.data?.data?[productIndex];
          product?.inCart = !(product?.inCart ?? false);  
        }

        emit(HomeProductSuccessState());
        getCartData(); 
      } else {
        emit(HomeProductErrorState(response.data['message']));
      }
    } catch (e) {
      emit(HomeProductErrorState(e.toString()));
    }
  }

  void deleteCart(int cartId) async {
    emit(HomeCartLoadingState());

    try {
      var response = await DioHelpers.deleteData(
        path: "carts/$cartId",
      );

      if (response.data['status']) {
        emit(HomeCartSuccessState());  
        getCartData();  
      } else {
        emit(HomeCartErrorState(response.data['message']));
      }
    } catch (e) {
      // print('Error: $e'); // Debugging line
      emit(HomeCartErrorState(e.toString()));
    }
  }

  void clearCart() {
    emit(HomeProductLoadingState());

    cartModel?.data?.cartItems?.forEach((cartItem) {
      final productId = cartItem.product?.id;
      if (productId != null) {
        final productIndex = Pmodel.data?.data?.indexWhere((item) => item.id == productId);
        if (productIndex != null && productIndex >= 0) {
          Pmodel.data?.data?[productIndex].inCart = false;
        }
      }
    });

    cartModel?.data?.subTotal = 0.0;
    cartModel?.data?.total = 0.0;

    emit(HomeCartClearedState());
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = Pmodel?.data?.data ?? [];  
    } else {
      filteredProducts = Pmodel?.data?.data
          ?.where((product) =>
              product.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList() ?? [];
    }
    emit(HomeProductSuccessState());  
  }











}
