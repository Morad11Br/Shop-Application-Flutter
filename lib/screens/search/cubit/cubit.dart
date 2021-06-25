import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/components/constants.dart';
import 'package:the_shop_app/models/search_model.dart';
import 'package:the_shop_app/network/dio_helper.dart';
import 'package:the_shop_app/network/end_point.dart';
import 'package:the_shop_app/screens/search/cubit/states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel model;

  void search(String text) {
    emit(SearchLoadingState());

    Diohelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then((value) {
      model = SearchModel.fromJson(value.data);

      emit(SearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
