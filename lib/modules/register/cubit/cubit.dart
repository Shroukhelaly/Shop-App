import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login/login_model.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/networks/remote/dio_helper.dart';
import 'package:shop_app/networks/remote/end_points.dart';
import 'package:shop_app/modules/Login/cubit/states.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(url: register, data: {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
    }).then((value) {
      debugPrint(value.data.toString());
      loginModel = ShopLoginModel.fromJSON(value.data!);
      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;

  bool isPassword = true;

  void changePasswordVisibility() {
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    isPassword = !isPassword;

    emit(ShopRegisterChangePasswordVisibilityState());
  }
}
