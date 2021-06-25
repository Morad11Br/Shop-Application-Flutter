import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/components/components.dart';
import 'package:the_shop_app/cubit/cubit.dart';
import 'package:the_shop_app/cubit/states.dart';
import 'package:the_shop_app/models/categories_model.dart';
import 'package:the_shop_app/models/home_model.dart';
import 'package:the_shop_app/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status) {
            showToast(message: state.model.message, state: ToastState.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null && cubit.categoriesModel != null,
          builder: (context) =>
              productBuilder(cubit.homeModel, cubit.categoriesModel, context),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productBuilder(
      HomeModel model, CategoriesModel categoriesModel, context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model.data.banners
                .map(
                  (e) => Image(
                    image: NetworkImage(
                      '${e.image}',
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 250,
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              initialPage: 0,
              reverse: false,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 1.0,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  height: 100,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return buildCategoryItem(
                          categoriesModel.data.data[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: categoriesModel.data.data.length,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'New Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.71,
              children: List.generate(
                model.data.products.length,
                (index) => Container(
                  color: Colors.white,
                  child: gridProduct(model.data.products[index], context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: NetworkImage(
              model.image,
            ),
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Container(
            width: 100,
            color: Colors.black.withOpacity(.8),
            child: Text(
              model.name,
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  Widget gridProduct(ProductModel model, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image(
                image: NetworkImage('${model.image}'),
                width: double.infinity,
                height: 200,
              ),
              model.discount != 0
                  ? Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Text(''),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                style: TextStyle(
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    '${model.price.round()}',
                    style: TextStyle(
                      color: defaultColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  model.discount != 0
                      ? Text(
                          '${model.oldPrice.round()}',
                          style: TextStyle(
                            color: defaultColor,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        )
                      : Text(''),
                  Spacer(),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor:
                          ShopCubit.get(context).favorites[model.id]
                              ? defaultColor
                              : Colors.grey,
                      radius: 15.0,
                      child: Icon(
                        Icons.favorite_border,
                      ),
                    ),
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(model.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
