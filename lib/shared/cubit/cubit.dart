import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/Fav_model/favorit_model.dart';
import 'package:shop_app/models/categories_model/categories_model.dart';
import 'package:shop_app/models/change_favourit_model/change_favourit_model.dart';
import 'package:shop_app/models/home_model/home_model.dart';
import 'package:shop_app/models/login/login_model.dart';
import 'package:shop_app/modules/Favorites/favorites_screen.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/setting/setting_screen.dart';
import 'package:shop_app/networks/remote/dio_helper.dart';
import 'package:shop_app/networks/remote/end_points.dart';
import 'package:shop_app/shared/cubit/states.dart';

import '../constance.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopHomeLoadingState());
    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJSON(value.data);

      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      });

      debugPrint(favorites.toString());

      emit(ShopHomeSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopHomeErrorState(error.toString()));
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    emit(ShopCategoriesLoadingState());

    DioHelper.getData(
      url: categories,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJSON(value.data);
      debugPrint("categories length: ${value.data}");

      emit(ShopCategoriesSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopCategoriesErrorState(error.toString()));
    });
  }

  ChangeFavoriteModel? changeFavoriteModel;

  void changeFavorite(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavouritesState());
    DioHelper.postData(
      url: Favorites,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJSON(value.data!);
      debugPrint('$changeFavoriteModel');

      if (!(changeFavoriteModel!.status!)) {
        favorites[productId] = !favorites[productId]!;

        emit(ShopFavouritesErrorState(changeFavoriteModel!.message!));
      } else {
        getFavoriteData();
        emit(ShopFavouritesSuccessState(model: changeFavoriteModel!));
      }
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;

      debugPrint(error.toString());
      emit(ShopFavouritesErrorState(error.toString()));
    });
  }

  FavoriteModel? favoriteModel;

  void getFavoriteData() {
    emit(ShopLoadingGetFavouritesState());

    DioHelper.getData(
      url: Favorites,
      token: token,
    ).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);
      debugPrint('favoriteModel: ${favoriteModel.toString()}');

      emit(ShopAddToFavSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopAddToFavErrorState(error.toString()));
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopGetUserDataLoadingState());

    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJSON(value.data);
      debugPrint('name is : ${userModel!.data!.name}');
      debugPrint('favoriteModel: ${userModel.toString()}');

      emit(ShopGetUserDataSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopGetUserDataErrorState(error.toString()));
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopUpdateUserDataLoadingState());

    DioHelper.putData(
      url: update_profile,
      token: token,
      data: {
        'name': name,
        'email' : email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJSON(value.data!);
      debugPrint('name is : ${userModel!.data!.name}');
      debugPrint('favoriteModel: ${userModel.toString()}');

      emit(ShopUpdateUserDataSuccessState(userModel!));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopUpdateUserDataErrorState(error.toString()));
    });
  }
}
