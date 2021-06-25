import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:the_shop_app/components/components.dart';
import 'package:the_shop_app/network/cache_helper.dart';
import 'package:the_shop_app/screens/login/login_screen.dart';
import 'package:the_shop_app/styles/colors.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String body;

  OnboardingModel({
    @required this.image,
    @required this.title,
    @required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<OnboardingModel> onBorading = [
    OnboardingModel(
      image: 'assets/images/onboarding_1.png',
      title: 'Title Screen 1',
      body: 'Body Screen 1',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_2.png',
      title: 'Title Screen 2',
      body: 'Body Screen 2',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_1.png',
      title: 'Title Screen 3',
      body: 'Body Screen 3',
    ),
  ];
  var boardingController = PageController();
  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Text('SKIP'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardingController,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildOnBoardingItem(onBorading[index]);
                },
                itemCount: onBorading.length,
                onPageChanged: (int index) {
                  if (index == onBorading.length - 1) {
                    setState(() {
                      isLast = true;
                      print('is Last');
                    });
                  } else {
                    setState(() {
                      isLast = false;
                      print('not last');
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardingController,
                  count: onBorading.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 4,
                    spacing: 5,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardingController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true);
    navigateAndDestroy(context, LoginScreen());
  }

  Widget buildOnBoardingItem(OnboardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(
                '${model.image}',
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${model.title}',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${model.body}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      );
}
