import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shop_app/shared/components.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

import '../../models/login/login_model.dart';
import '../../shared/constance.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, states) {},
        builder: (context, states) {
          ShopLoginModel? model = ShopCubit.get(context).userModel;

          nameController.text = model!.data!.name!;
          emailController.text = model!.data!.email!;
          phoneController.text = model!.data!.phone!;

          return ConditionalBuilder(
              condition: ShopCubit.get(context).userModel != null,
              builder: (context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Expanded(
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              if (states is ShopUpdateUserDataLoadingState)
                                LinearProgressIndicator(
                                  color: defaultColor,
                                ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Image(
                                image: NetworkImage(
                                  model.data!.image!,
                                ),
                                fit: BoxFit.contain,
                                height: 150,
                                width: 150,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              ShopTextFormField(
                                controller: nameController,
                                type: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    'Name Must Not BeEmpty';
                                  }
                                },
                                prefix: const Icon(Icons.person),
                                label: 'Name',
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              ShopTextFormField(
                                controller: phoneController,
                                type: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    'phone Must Not BeEmpty';
                                  }
                                },
                                prefix: const Icon(Icons.phone),
                                label: 'phone',
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              ShopTextFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    'email Must Not BeEmpty';
                                  }
                                },
                                prefix: const Icon(Icons.email_rounded),
                                label: 'Email Address',
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              DefaultButton(
                                background: defaultColor,
                                width: double.infinity,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    if (states is ShopUpdateUserDataSuccessState) {
                                      AnimatedSnackBar.material(
                                        states.userModel.message!,
                                        type: AnimatedSnackBarType.success,
                                        animationCurve: Curves.fastEaseInToSlowEaseOut,
                                        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                                      ).show(context);
                                      ShopCubit.get(context).updateUserData(
                                        name: nameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                      );
                                    }else if(states is ShopGetUserDataErrorState) {
                                      AnimatedSnackBar.material(
                                        states.error,
                                        type: AnimatedSnackBarType.error,
                                        animationCurve: Curves.fastEaseInToSlowEaseOut,
                                        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                                      ).show(context);

                                    }

                                  }
                                },
                                text: 'UpDate',
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              DefaultButton(
                                  background: defaultColor,
                                  width: double.infinity,
                                  function: () {
                                    signOut(context);
                                  },
                                  text: 'LogOut')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              fallback: (context) => Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: defaultColor,
                      size: 45.0,
                    ),
                  ));
        });
  }
}
