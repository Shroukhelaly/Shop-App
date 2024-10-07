class FavoriteModel {
  bool? status;
  FavoriteDataModel? data;

  FavoriteModel({this.status, this.data});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ?FavoriteDataModel.fromJson(json['data']) : null;
  }

}

class FavoriteDataModel {
  int? currentPage;
  List<DataModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? path;
  int? perPage;
  int? to;
  int? total;


  FavoriteDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
      });
    }
  }
}

class DataModel {
  int? id;
  Product? product;

  DataModel({this.id, this.product});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }
}

class Product {
  int? id;
  int? price;
  int? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

}