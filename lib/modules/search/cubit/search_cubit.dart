import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/cubit/search_states.dart';
import 'package:shop_app/networks/remote/dio_helper.dart';
import 'package:shop_app/shared/constance.dart';

import '../../../models/search/Search_model.dart';
import '../../../networks/remote/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

   SearchModel? searchModel;

  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(url: Search, token: token, data: {
      'text': text,
    }).then(
      (value) {
        searchModel = SearchModel.fromJson(value.data!);
        print(value.data);
        emit(SearchSuccessState());
      },
    ).catchError((error) {
      print(error.toString());
      emit(SearchErrorState(error.toString()));
    });
  }
}
