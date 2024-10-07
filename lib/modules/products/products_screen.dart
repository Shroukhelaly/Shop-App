import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shop_app/models/home_model/home_model.dart';
import 'package:shop_app/shared/constance.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

import '../../models/categories_model/categories_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, states) {
        if (states is ShopFavouritesErrorState) {
          AnimatedSnackBar.material(
            states.error,
            type: AnimatedSnackBarType.error,
            animationCurve: Curves.fastEaseInToSlowEaseOut,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        }
        if (states is ShopFavouritesSuccessState) {
          AnimatedSnackBar.material(
            states.model.message!,
            type: AnimatedSnackBarType.success,
            animationCurve: Curves.elasticInOut,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        }
      },
      builder: (context, states) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => BuildProductItem(
            model: ShopCubit.get(context).homeModel!,
            categoriesModel: ShopCubit.get(context).categoriesModel!,
          ),
          fallback: (context) => Center(
              child: LoadingAnimationWidget.fourRotatingDots(
            color: defaultColor,
            size: 45.0,
          )),
        );
      },
    );
  }
}

class BuildProductItem extends StatelessWidget {
  final HomeModel model;
  final CategoriesModel categoriesModel;

  const BuildProductItem({
    super.key,
    required this.model,
    required this.categoriesModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model.data?.banners
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 200,
              initialPage: 0,
              viewportFraction: 0.8,
              enlargeFactor: 0.3,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => BuildCategoriesItem(
                      model: categoriesModel.data!.data[index],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    itemCount: categoriesModel.data!.data.length,
                  ),
                ),
                const Text(
                  'New Products',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1 / 1.52,
              children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      BuildGridProduct(model: model.data!.products[index])),
            ),
          )
        ],
      ),
    ));
  }
}

class BuildCategoriesItem extends StatelessWidget {
  final DataModel model;

  const BuildCategoriesItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Image(
          image: NetworkImage(
            model.image!,
          ),
          height: 100,
          width: 100,
        ),
        Container(
          width: 100,
          color: Colors.black.withOpacity(
            0.6,
          ),
          child: Text(
            model.name!,
            style: const TextStyle(
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class BuildGridProduct extends StatelessWidget {
  final ProductsModel model;

  const BuildGridProduct({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
            Image(
              image: NetworkImage(
                model.image!,
              ),
              width: double.infinity,
              height: 200,
            ),
            if (model.discount != 0.0)
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20, height: 1),
                ),
                Row(
                  children: [
                    Text(
                      '${model.price?.round()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    if (model.discount != 0.0)
                      Text(
                        '${model.oldPrice?.round()}',
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
                          ShopCubit.get(context).changeFavorite(model.id!);
                          print(model.id);
                        },
                        icon: Icon(
                          ShopCubit.get(context).favorites[model.id]!
                              ? Icons.favorite_outlined
                              : Icons.favorite_border_rounded,
                          color: ShopCubit.get(context).favorites[model.id]!
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
    );
  }
}
