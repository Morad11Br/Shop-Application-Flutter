import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:the_shop_app/components/components.dart';
import 'package:the_shop_app/cubit/cubit.dart';
import 'package:the_shop_app/cubit/states.dart';
import 'package:the_shop_app/screens/search/search_screen.dart';

class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('SouQ'),
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  }),
            ],
          ),
          body: cubit.screenItem[cubit.currentIndex],
          bottomNavigationBar: SalomonBottomBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeNavBarItem(index);
              },
              items: [
                SalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.apps),
                  title: Text('Categories'),
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.favorite),
                  title: Text('Favorites'),
                ),
                SalomonBottomBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ]),
        );
      },
    );
  }
}
