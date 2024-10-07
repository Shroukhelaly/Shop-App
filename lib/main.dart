import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app_home.dart';
import 'package:shop_app/modules/Login/login.dart';
import 'package:shop_app/networks/local/cache_helper.dart';
import 'package:shop_app/networks/remote/dio_helper.dart';
import 'package:shop_app/shared/constance.dart';
import 'package:shop_app/shared/cubit/bloc_observer.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/styles/themes.dart';

import 'modules/on_boarding/on_boarding_screen.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Bloc.observer = MyBlocObserver();
    DioHelper.init();
    await CacheHelper.init();

    Widget? widget;
     token = CacheHelper.getData(key: 'token');

    bool? onBoarding = CacheHelper.getData(key: 'OnBoarding');

    if (onBoarding != null) {
      if (token != null) {
        widget = const ShopHomeScreen();
      } else {
        widget = ShopLoginScreen();
      }
    }else {
      widget = const OnBoardingScreen();
    }

    runApp(
      MyApp(
        startWidget: widget,
      ),
    );
  }, (error, stack) {
    debugPrint("Global Error: $error");
    debugPrint("Global StackTrace: $stack");
  });
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({
    super.key,
    required this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavoriteData()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
