import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login/login_model.dart';
import 'package:shop_app/networks/remote/dio_helper.dart';
import 'package:shop_app/networks/remote/end_points.dart';
import 'package:shop_app/modules/Login/cubit/states.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(url: login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      debugPrint(value.data.toString());
      loginModel = ShopLoginModel.fromJSON(value.data!);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;

  bool isPassword = true;

  void changePasswordVisibility() {
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    isPassword = !isPassword;

    emit(ShopLoginChangePasswordVisibilityState());
  }
}
