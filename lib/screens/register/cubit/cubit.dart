import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/models/login_model.dart';
import 'package:the_shop_app/network/dio_helper.dart';
import 'package:the_shop_app/network/end_point.dart';
import 'package:the_shop_app/screens/register/cubit/states.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  LoginModel registerModel;

  void userRegister({
    @required String email,
    @required String password,
    @required String name,
    @required String phone,
  }) {
    emit(ShopRegisterLoadingState());

    Diohelper.postData(
      url: REGISTER,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      },
    ).then((value) {
      print(value.data);
      registerModel = LoginModel.fromJson(value.data);

      emit(ShopRegisterSuccessState(registerModel));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  bool isVisible = false;
  IconData icon;

  void passwordVisible() {
    isVisible = !isVisible;
    if (isVisible) {
      icon = Icons.visibility_off;
    } else {
      icon = Icons.visibility;
    }

    emit(ShopRegisterIsPasswordState());
  }
}
