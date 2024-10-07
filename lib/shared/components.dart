import 'package:flutter/material.dart';
import 'package:shop_app/shared/constance.dart';
import '../modules/Login/login.dart';
import '../networks/local/cache_helper.dart';
import 'cubit/cubit.dart';

class ShopTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final Icon prefix;
  final String label;
  final Function()? onTap;
  Function(String)? onSubmit;
  Function(dynamic)? suffixPressed;

  ShopTextFormField({
    super.key,
    required this.controller,
    required this.type,
    this.validator,
    this.onChanged,
    required this.prefix,
    required this.label,
    this.onTap,
    this.onSubmit,
    this.suffixPressed,
    bool obscureText = false,
    IconButton? suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      cursorColor: defaultColor,
      textInputAction: TextInputAction.next,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        floatingLabelStyle: TextStyle(
          color: defaultColor,
        ),
        prefixIcon: prefix,
        prefixIconColor: defaultColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: defaultColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.red,
              style: BorderStyle.solid,
            )),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  final Color background;
  final double width;
  final Function function;
  final String text;

  const DefaultButton({
    super.key,
    required this.background,
    required this.width,
    required this.function,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      width: width,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void signOut (context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ShopLoginScreen()),
            (route) => false,
      );
    }
  });
}

Widget buildListProduct(model, context)=> Padding(
  padding: const EdgeInsets.all(20.0),
  child: SizedBox(
    height: 120.0,
    child: Row(
      children: [
        Stack(alignment: AlignmentDirectional.bottomStart, children: [
          Image(
            image: NetworkImage(
              model!.image!,
            ),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          if (model.discount != 0.0)
            const SizedBox(
              width: 20,
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            color: Colors.red,
            child: const Text(
              'DISCOUNT',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        ]),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20, height: 1),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '${model.price!.round()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: defaultColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  if (model.discount! != 0.0)
                    Text(
                      '${model.oldPrice!.round()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        ShopCubit.get(context)
                            .changeFavorite(model.id!);
                      },
                      icon: Icon(
                        ShopCubit.get(context).favorites[model.id]!
                            ? Icons.favorite_outlined
                            : Icons.favorite_border_rounded,
                        color: ShopCubit.get(context)
                            .favorites[model.id]!
                            ? Colors.red
                            : Colors.black,
                      ))
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);


