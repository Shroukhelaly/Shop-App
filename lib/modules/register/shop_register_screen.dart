import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/modules/register/cubit/states.dart';

import '../../layout/shop_app_home.dart';
import '../../networks/local/cache_helper.dart';
import '../../shared/components.dart';
import '../../shared/constance.dart';
import '../Login/cubit/cubit.dart';
import '../Login/cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget {
  ShopRegisterScreen({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ShopRegisterCubit(),
        child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
          listener: (context, states) {
            if (states is ShopRegisterSuccessState) {
              if (states.loginModel.status!) {
                debugPrint(states.loginModel.message);
                debugPrint(states.loginModel.data?.token);
                CacheHelper.saveData(
                        key: 'token', value: states.loginModel.data?.token)
                    .then((value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShopHomeScreen()),
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
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REGISTER',
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
                            'Register Now And Enjoy Your Offers',
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
                            controller: nameController,
                            type: TextInputType.text,
                            prefix: const Icon(Icons.person),
                            label: 'Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ShopTextFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            prefix: const Icon(Icons.phone),
                            label: 'Phone',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required';
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
                            onSubmit: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Invalid password';
                              }
                            },
                            obscureText:
                                ShopRegisterCubit.get(context).isPassword,
                            suffixPressed: (value) {},
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ConditionalBuilder(
                            condition: states is! ShopRegisterLoadingState,
                            builder: (context) => DefaultButton(
                              background: defaultColor,
                              width: double.infinity,
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                      phone: phoneController.text);
                                }
                              },
                              text: 'register',
                            ),
                            fallback: (context) => Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: defaultColor,
                                size: 45.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
