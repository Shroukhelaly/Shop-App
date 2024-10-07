class ChangeFavoriteModel{

  bool? status;
  String? message;

  ChangeFavoriteModel.fromJSON(Map<String, dynamic> json){

    status = json["status"];
    message = json["message"];
  }
}