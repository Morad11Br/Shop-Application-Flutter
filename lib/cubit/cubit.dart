import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/components/constants.dart';
import 'package:the_shop_app/cubit/states.dart';
import 'package:the_shop_app/models/categories_model.dart';
import 'package:the_shop_app/models/change_favorite_model.dart';
import 'package:the_shop_app/models/favorites_model.dart';
import 'package:the_shop_app/models/home_model.dart';
import 'package:the_shop_app/models/login_model.dart';
import 'package:the_shop_app/network/dio_helper.dart';
import 'package:the_shop_app/network/end_point.dart';
import 'package:the_shop_app/screens/categories/categories_screen.dart';
import 'package:the_shop_app/screens/favorites/favorites_screen.dart';
import 'package:the_shop_app/screens/products/products_screen.dart';
import 'package:the_shop_app/screens/settings/settings_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screenItem = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeNavBarItem(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  HomeModel homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    Diohelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });
      print(favorites);
      emit(ShopSuccessHomeDataState());
    }).catchError((e) {
      print(e.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategories() {
    Diohelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((e) {
      print(e.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoriteModel changeFavoriteModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];
    emit(ShopChangeFavoritesState());
    Diohelper.postData(
      url: FAVORITES,
      data: {'product_id': productId},
      token: token,
    ).then((value) {
      changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);

      if (!changeFavoriteModel.status) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoriteModel));
    }).catchError((e) {
      favorites[productId] = !favorites[productId];
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());
    Diohelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((e) {
      print(e.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  LoginModel profileModel;

  void getProfile() {
    emit(ShopLoadingGetFavoritesState());
    Diohelper.getData(
      url: GET_PROFILE,
      token: token,
    ).then((value) {
      profileModel = LoginModel.fromJson(value.data);
      print(profileModel.data.name);

      emit(ShopSuccessGetProfileState());
    }).catchError((e) {
      print(e.toString());
      emit(ShopErrorGetProfileState());
    });
  }

  LoginModel upDateModel;

  void upDateProfile({
    @required String name,
    @required String phone,
    @required String email,
  }) {
    emit(ShopLoadingUpdateUserState());
    Diohelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      upDateModel = LoginModel.fromJson(value.data);
      print(upDateModel.data.name);

      emit(ShopSuccessUpdateUserState(upDateModel));
    }).catchError((e) {
      print(e.toString());
      emit(ShopErrorUpdateUserState());
    });
  }

//   bool isDark = false;

//   void changeAppTheme({bool fromShared}) {
//     if (fromShared != null) {
//       isDark = fromShared;
//     } else
//       isDark = !isDark;
//     CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {});
//   }
}
