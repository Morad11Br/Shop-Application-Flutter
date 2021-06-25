import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/cubit/cubit.dart';
import 'package:the_shop_app/layout.dart';
import 'package:the_shop_app/network/cache_helper.dart';
import 'package:the_shop_app/network/dio_helper.dart';
import 'package:the_shop_app/screens/login/login_screen.dart';
import 'package:the_shop_app/screens/onBoarding/on_boarding_screen.dart';
import 'package:the_shop_app/styles/themes.dart';

import 'components/constants.dart';
import 'cubit/bloc_observer.dart';
import 'cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  Diohelper.init();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark');
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print('TOKEN = $token');
  Widget widget;
  if (onBoarding != null) {
    if (token != null) {
      widget = ShopLayout();
    } else
      widget = LoginScreen();
  } else
    widget = OnBoardingScreen();
  runApp(
    MyApp(
      isDark: isDark,
      startWidget: widget,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  const MyApp({this.isDark, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()
        ..getHomeData()
        ..getCategories()
        ..getFavorites()
        ..getProfile(),
      // ..changeAppTheme(fromShared: isDark),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, states) {},
        builder: (context, states) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
