import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_shop_app/cubit/cubit.dart';
import 'package:the_shop_app/styles/colors.dart';

Widget buildarticleItems(article, context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage('${article['urlToImage']}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ' ${article['title']} ',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Text(
                  '${article['publishedAt']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget myDevider() => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 1,
      ),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey[300],
      ),
    );

Widget articleBuilder(list, context) => ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return buildarticleItems(list[index], context);
        },
        separatorBuilder: (context, index) => myDevider(),
        itemCount: 10,
      ),
      fallback: (context) => Center(child: CircularProgressIndicator()),
    );

Widget defaultTextField({
  @required TextEditingController controller,
  @required String label,
  @required IconData prefix,
  @required TextInputType textInputType,
  @required Function onValidate,
  Function onChanged,
  Function onSabmitted,
  IconData suffix,
  Function suffixPressed,
  bool isPassword = false,
}) {
  return TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
      prefix: Icon(prefix),
      suffix: Icon(suffix),
    ),
    obscureText: isPassword,
    controller: controller,
    keyboardType: textInputType,
    onFieldSubmitted: onSabmitted,
    onChanged: onChanged,
    validator: onValidate,
    onTap: suffixPressed,
  );
}

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => widget),
    );

void navigateAndDestroy(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );

Widget defaultButton({
  @required Function function,
  @required String text,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(3),
    ),
    child: MaterialButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Widget defaultTextButton({
  @required Function function,
  @required String text,
}) {
  return TextButton(
    onPressed: function,
    child: Text(text.toUpperCase()),
  );
}

void showToast({
  @required String message,
  @required ToastState state,
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}

Widget buildProductItem(model, context, {bool isOldPrice = true}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
      height: 120,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image(
                image: NetworkImage(
                  model.image,
                ),
                width: 120,
                height: 120,
              ),
              model.discount != 0 && isOldPrice
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
          Expanded(
            child: Column(
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
                Spacer(),
                Row(
                  children: [
                    Text(
                      model.price.toString(),
                      style: TextStyle(
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    model.discount != 0 && isOldPrice
                        ? Text(
                            model.oldPrice.toString(),
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
          ),
        ],
      ),
    ),
  );
}
