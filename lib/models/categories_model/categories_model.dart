class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;

  CategoriesModel.fromJSON(Map<String, dynamic> json) {
    status = json["status"];
    data = CategoriesDataModel.fromJSON(json["data"]);
  }
}

class CategoriesDataModel {
  int? currentPage;
  List<DataModel> data = [];

  CategoriesDataModel.fromJSON(Map<String, dynamic> json) {
    currentPage = json["current_page"];
    json["data"].forEach((element) {
      data.add(DataModel.fromJSON(element));
    });
  }
}

class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    image = json["image"];
  }
}
