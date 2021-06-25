import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/components/components.dart';
import 'package:the_shop_app/cubit/cubit.dart';
import 'package:the_shop_app/cubit/states.dart';
import 'package:the_shop_app/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
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
                return buildCatItem(
                    ShopCubit.get(context).categoriesModel.data.data[index]);
              },
              separatorBuilder: (context, index) {
                return myDevider();
              },
              itemCount: 10),
        );
      },
    );
  }

  Widget buildCatItem(DataModel model) => Row(
        children: [
          Image(
            image: NetworkImage(
              model.image,
            ),
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
          Spacer(),
          Text(
            model.name,
          ),
          IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: () {}),
        ],
      );
}
