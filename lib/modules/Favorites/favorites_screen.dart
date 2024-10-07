import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shop_app/models/Fav_model/favorit_model.dart';
import 'package:shop_app/shared/cubit/states.dart';

import '../../shared/constance.dart';
import '../../shared/cubit/cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, states) {},
      builder: (context, states) {
        return ConditionalBuilder(
          condition: states is! ShopLoadingGetFavouritesState,
          builder: (context) =>
              ShopCubit.get(context).favoriteModel!.data!.data!.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => BuildFavItem(
                        model: ShopCubit.get(context)
                            .favoriteModel!
                            .data!
                            .data![index].product!,
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                      itemCount: ShopCubit.get(context)
                          .favoriteModel!
                          .data!
                          .data!
                          .length,
                    )
                  : const Center(
                    child:  Text(
                    'No Favorite Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                                  ),
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

class BuildFavItem extends StatelessWidget {
  BuildFavItem({super.key, required this.model});

  Product model;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
  }
}
