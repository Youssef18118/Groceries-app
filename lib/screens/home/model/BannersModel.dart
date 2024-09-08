class BannerModel {
  bool? status;
  Null? message;
  List<BannerData>? data;

  BannerModel({this.status, this.message, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BannerData>[];
      json['data'].forEach((v) {
        data!.add(new BannerData.fromJson(v));
      });
    }
  }
}

class BannerData {
  int? id;
  String? image;
  Null? category;
  Null? product;

  BannerData({this.id, this.image, this.category, this.product});

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    category = json['category'];
    product = json['product'];
  }

}