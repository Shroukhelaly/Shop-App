import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shop_app/layout/shop_app_home.dart';
import 'package:shop_app/modules/Login/cubit/cubit.dart';
import 'package:shop_app/modules/Login/cubit/states.dart';
import 'package:shop_app/modules/register/shop_register_screen.dart';
import 'package:shop_app/networks/local/cache_helper.dart';
import 'package:shop_app/shared/components.dart';

import '../../shared/constance.dart';

class ShopLoginScreen extends StatelessWidget {
  ShopLoginScreen({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool isPassword = true;

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, states) {
          if (states is ShopLoginSuccessState) {
            if (states.loginModel.status!) {
              debugPrint(states.loginModel.message);
              debugPrint(states.loginModel.data?.token);
              CacheHelper.saveData(key: 'token',
                  value: states.loginModel.data?.token).then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopHomeScreen()),
                      (route) => false,
                );
              });
            } else {
              debugPrint(states.loginModel.message);
              AnimatedSnackBar.material(
                states.loginModel.message!,
                type: AnimatedSnackBarType.error,
                animationCurve: Curves.fastEaseInToSlowEaseOut,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            }
          }
        },
        builder: (context, states) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Login Now And Enjoy Your Offers',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        ShopTextFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          prefix: const Icon(Icons.email_outlined),
                          label: 'Email Address',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email address must not be empty';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ShopTextFormField(
                          controller: passwordController,
                          type: TextInputType.text,
                          prefix: const Icon(Icons.lock_outline),
                          label: 'Password',
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid password';
                            }
                          },
                          obscureText: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: (value) {},
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ConditionalBuilder(
                          condition: states is! ShopLoginLoadingState,
                          builder: (context) => DefaultButton(
                            background: defaultColor,
                            width: double.infinity,
                            function: () {
                              if (formKey.currentState!.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'login',
                          ),
                          fallback: (context) => Center(
                            child: LoadingAnimationWidget.fourRotatingDots(
                              color: defaultColor,
                              size: 45.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Don\'t Have Account?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                             ShopRegisterScreen(),
                                      ));
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: defaultColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
