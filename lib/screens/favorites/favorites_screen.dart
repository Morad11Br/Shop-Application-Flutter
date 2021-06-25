import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/components/components.dart';
import 'package:the_shop_app/cubit/cubit.dart';
import 'package:the_shop_app/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return buildProductItem(
                ShopCubit.get(context).favoritesModel.data.data[index].product,
                context,
                isOldPrice: true,
              );
            },
            separatorBuilder: (context, index) {
              return myDevider();
            },
            itemCount: ShopCubit.get(context).favoritesModel.data.data.length,
          ),
        );
      },
    );
  }
}
