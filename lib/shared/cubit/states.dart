import 'package:shop_app/models/login/login_model.dart';

import '../../models/change_favourit_model/change_favourit_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopHomeLoadingState extends ShopStates {}

class ShopHomeSuccessState extends ShopStates {}

class ShopHomeErrorState extends ShopStates {
  final String error;

  ShopHomeErrorState(this.error);
}

class ShopCategoriesLoadingState extends ShopStates {}

class ShopCategoriesSuccessState extends ShopStates {}

class ShopCategoriesErrorState extends ShopStates {
  final String error;

  ShopCategoriesErrorState(this.error);
}

class ShopChangeFavouritesState extends ShopStates {}

class ShopLoadingGetFavouritesState extends ShopStates {}

class ShopFavouritesSuccessState extends ShopStates {
  final ChangeFavoriteModel model;

  ShopFavouritesSuccessState({required this.model});
}

class ShopFavouritesErrorState extends ShopStates {
  final String error;

  ShopFavouritesErrorState(this.error);
}

class ShopAddToFavSuccessState extends ShopStates {}

class ShopAddToFavErrorState extends ShopStates {
  final String error;

  ShopAddToFavErrorState(this.error);
}

class ShopGetUserDataLoadingState extends ShopStates {}

class ShopGetUserDataSuccessState extends ShopStates {}

class ShopGetUserDataErrorState extends ShopStates {
  final String error;

  ShopGetUserDataErrorState(this.error);
}

class ShopUpdateUserDataLoadingState extends ShopStates {}

class ShopUpdateUserDataSuccessState extends ShopStates {

   final ShopLoginModel userModel;


   ShopUpdateUserDataSuccessState(this.userModel);
}

class ShopUpdateUserDataErrorState extends ShopStates {
  final String error;

  ShopUpdateUserDataErrorState(this.error);
}
