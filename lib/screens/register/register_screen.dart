import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_shop_app/components/components.dart';
import 'package:the_shop_app/components/constants.dart';
import 'package:the_shop_app/network/cache_helper.dart';
import 'package:the_shop_app/screens/register/cubit/cubit.dart';
import 'package:the_shop_app/screens/register/cubit/states.dart';

import '../../layout.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ShopRegisterCubit(),
        child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
          listener: (context, state) {
            if (state is ShopRegisterSuccessState) {
              if (state.loginModel.status) {
                print(state.loginModel.message);
                print(state.loginModel.data.token);
                CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data.token,
                ).then((value) {
                  token = state.loginModel.data.token;
                  navigateAndDestroy(context, ShopLayout());
                });
              } else {
                showToast(
                    message: state.loginModel.message, state: ToastState.ERROR);
              }
            }
          },
          builder: (context, state) {
            var cubit = ShopRegisterCubit.get(context);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultTextField(
                          controller: emailController,
                          label: 'Email',
                          prefix: Icons.email,
                          textInputType: TextInputType.emailAddress,
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'email must not be empty!';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextField(
                          controller: passwordController,
                          label: 'password',
                          prefix: Icons.lock_outline,
                          suffix: cubit.icon,
                          isPassword: cubit.isVisible,
                          suffixPressed: () {
                            cubit.passwordVisible();
                          },
                          onSabmitted: (value) {},
                          textInputType: TextInputType.visiblePassword,
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'password to short!';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextField(
                          controller: nameController,
                          label: 'Name',
                          prefix: Icons.person,
                          textInputType: TextInputType.text,
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'name must not be empty!';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultTextField(
                          controller: phoneController,
                          label: 'Phone',
                          prefix: Icons.phone,
                          textInputType: TextInputType.number,
                          onValidate: (String value) {
                            if (value.isEmpty) {
                              return 'phone must not be empty!';
                            } else
                              return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState.validate()) {
                                cubit.userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'register',
                          ),
                          fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
