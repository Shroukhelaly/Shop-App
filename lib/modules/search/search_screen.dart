import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/cubit/search_cubit.dart';
import 'package:shop_app/modules/search/cubit/search_states.dart';
import 'package:shop_app/shared/components.dart';
import '../../shared/constance.dart';
import '../../shared/cubit/cubit.dart';
import '../Favorites/favorites_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    TextEditingController searchController = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, states) {},
        builder: (context, states) {
          return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ShopTextFormField(
                          controller: searchController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'value must not be empty';
                            }
                          },
                          onSubmit: (text) {
                            SearchCubit.get(context).search(text);
                          },
                          type: TextInputType.text,
                          prefix: const Icon(Icons.search),
                          label: 'search'),
                      const SizedBox(
                        height: 8,
                      ),
                      if (states is SearchLoadingState)
                        LinearProgressIndicator(
                          color: defaultColor,
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (states is SearchSuccessState)
                        ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildListProduct(
                               SearchCubit.get(context).searchModel!.data!.data![index],
                              context,
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data!
                              .length,
                        )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
