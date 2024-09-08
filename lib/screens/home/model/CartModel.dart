class CartModel {
  bool? status;
  String? message;
  CartData? data;

  CartModel({this.status, this.message, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CartData.fromJson(json['data']) : null;
  }
}

class CartData {
  List<CartItems>? cartItems;
  double? subTotal;
  double? total;

  CartData({this.cartItems, this.subTotal, this.total});

  CartData.fromJson(Map<String, dynamic> json) {
    if (json['cart_items'] != null) {
      cartItems = <CartItems>[];
      json['cart_items'].forEach((v) {
        cartItems!.add(CartItems.fromJson(v));
      });
    }

    // Safely handle int to double conversion for subTotal and total
    subTotal = (json['sub_total'] is int) ? json['sub_total'].toDouble() : json['sub_total'];
    total = (json['total'] is int) ? json['total'].toDouble() : json['total'];
  }
}

class CartItems {
  int? id;
  int? quantity;
  Product? product;

  CartItems({this.id, this.quantity, this.product});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
}

class Product {
  int? id;
  double? price;
  double? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;

  Product(
      {this.id,
      this.price,
      this.oldPrice,
      this.discount,
      this.image,
      this.name,
      this.description,
      this.images,
      this.inFavorites,
      this.inCart});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    // Safely handle int to double conversion for price and oldPrice
    price = (json['price'] is int) ? json['price'].toDouble() : json['price'];
    oldPrice = (json['old_price'] is int) ? json['old_price'].toDouble() : json['old_price'];

    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
