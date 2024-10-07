import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model/categories_model.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, states) {},
        builder: (context, states) {
          return ListView.separated(
            itemBuilder: (context, index) => CategoryItem(
              model: ShopCubit.get(context).categoriesModel!.data!.data[index],
            ),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            itemCount:
                ShopCubit.get(context).categoriesModel!.data!.data.length,
          );
        });
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({super.key, required this.model});

  late DataModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image(
            image: NetworkImage(
              model.image!,
            ),
            fit: BoxFit.cover,
            width: 80,
            height: 120,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            model.name!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios),
            //icon: ShopCubit.get(context).favorites[model]! ? const Icon(Icons.favorite_outlined) :  const Icon(Icons.favorite_border_rounded),
          )
        ],
      ),
    );
  }
}
