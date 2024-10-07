import 'package:flutter/material.dart';
import 'package:shop_app/modules/Login/login.dart';
import 'package:shop_app/networks/local/cache_helper.dart';
import 'package:shop_app/shared/constance.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingModel {
  final String image;
  final String title;
  final String body;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController boardController = PageController();

  List<OnBoardingModel> onBoarding = [
    OnBoardingModel(
      image: 'assets/onboarding_3.jpg',
      title: 'On Board Title 1',
      body: 'On Board body 1',
    ),
    OnBoardingModel(
      image: 'assets/onboarding_2.jpg',
      title: 'On Board Title 2',
      body: 'On Board body 2',
    ),
    OnBoardingModel(
      image: 'assets/onboarding_1.jpg',
      title: 'On Board Title 3',
      body: 'On Board body 3',
    ),
  ];

  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShopLoginScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: defaultColor,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (int index) {
                  if (index == onBoarding.length - 1) {
                    setState(() {
                      isLast = true;
                      debugPrint('last');
                    });
                  } else {
                    setState(() {
                      isLast = false;
                      debugPrint('not last');
                    });
                  }
                },
                physics: const BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) =>
                    buildOnBoardingItem(onBoarding[index]),
                itemCount: onBoarding.length,
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: onBoarding.length,
                  effect: SwapEffect(
                    spacing: 6,
                    dotWidth: 12.0,
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 12.0,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  elevation: 15.0,
                  backgroundColor: defaultColor,
                  shape: const CircleBorder(),
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardController.nextPage(
                        duration: const Duration(
                          milliseconds: 1500,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildOnBoardingItem(OnBoardingModel model) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Image(
          image: AssetImage(model.image),
          height: 250.0,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 120,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                model.body,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
