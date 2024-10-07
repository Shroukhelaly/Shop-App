class HomeModel {
  bool? status;
  HomeDataModel? data;

  HomeModel.fromJSON(Map<String, dynamic> json) {
    status = json["status"];
    data = HomeDataModel.fromJSON(json["data"]);
  }
}

class HomeDataModel {
  List<BannersModel> banners = [];
  List<ProductsModel> products = [];

  HomeDataModel.fromJSON(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(BannersModel.fromJSON(element));
    });

    json['products'].forEach((element) {
      products.add(ProductsModel.fromJSON(element));
    });
  }
}

class BannersModel {
  int? id;
  String? image;

  BannersModel.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    image = json["image"];
  }
}

class ProductsModel {
  int? id;
  double? price;
  double? oldPrice;
  double? discount;
  String? image;
  String? name;
  bool? inFavorites;
  bool? inCart;

  ProductsModel.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    price = json["price"].toDouble();
    oldPrice = json["old_price"].toDouble();
    discount = json["discount"].toDouble();
    image = json["image"];
    name = json["name"];
    inFavorites = json["in_favorites"];
    inCart = json["in_cart"];
  }
}


