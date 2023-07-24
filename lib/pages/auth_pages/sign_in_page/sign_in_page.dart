import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_light.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SignInPageArguments {
  SignInPageArguments({
    required this.isFirst,
  });

  final bool isFirst;
}

class SignInPage extends StatefulWidget {
  SignInPage({
    required this.isFirst,
    Key? key,
  }) : super(key: key);

  static const routeName = '/auth_pages/sign_in';
  final bool isFirst;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SlideModel {
  _SlideModel({
    required this.illustration,
    required this.title,
    required this.description,
  });

  String illustration;
  String title;
  String description;
}

class _SignInPageState extends State<SignInPage> {
  void _navigateToPage({
    required BuildContext context,
    required String route,
    bool isRoot = false,
    Object? arguments,
  }) {
    Navigator.of(
      context,
      rootNavigator: isRoot,
    ).pushNamed(route, arguments: arguments);
  }

  void _goToSignUpPage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: SignUpPage.routeName,
    );
    // testRequest();
  }

  final List<_SlideModel> listSlideModel = [
    _SlideModel(
      illustration: AppIcons.illustration_01,
      title: 'Numerous free trial courses',
      description: 'Free courses for you to find your way to learning',
    ),
    _SlideModel(
      illustration: AppIcons.illustration_02,
      title: 'Quick and easy learning',
      description:
          'Easy and fast learning at any time to help you improve various skills',
    ),
    _SlideModel(
      illustration: AppIcons.illustration_03,
      title: 'Create your own study plan',
      description:
          'Study according to the study plan, make study more motivated',
    ),
  ];

  late final imageController;

  bool isButtonsVisible = false;

  @override
  void initState() {
    super.initState();
    imageController = PageController(
        viewportFraction: 1,
        keepPage: false,
        initialPage: widget.isFirst ? 0 : listSlideModel.length - 1);
    isButtonsVisible = !widget.isFirst;
    imageController.addListener(() {
      if (imageController.page != null) {
        bool newIsButtonsVisible = imageController.page! >= 1.8;
        if (newIsButtonsVisible != isButtonsVisible) {
          setState(() {
            isButtonsVisible = newIsButtonsVisible;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      imageController.jumpToPage(listSlideModel.length - 1);
                    },
                    child: Text(
                      !isButtonsVisible ? 'Skip' : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Flexible(
                flex: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        itemCount: listSlideModel.length,
                        controller: imageController,
                        itemBuilder: (_, index) {
                          return _CustomSlideItem(
                            slideModel:
                                listSlideModel[index % listSlideModel.length],
                          );
                        },
                      ),
                    ),
                    CustomSmoothPageIndicator(
                      imageController: imageController,
                      length: listSlideModel.length,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isButtonsVisible)
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: 'Sign up',
                              padding: 4,
                              onTap: () {
                                _goToSignUpPage(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomButtonLight(
                              title: 'Log in',
                              padding: 4,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({
    required this.imageController,
    required this.length,
    super.key,
  });

  final imageController;
  final length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SmoothPageIndicator(
          controller: imageController,
          count: length,
          effect: ExpandingDotsEffect(
            spacing: 12.0,
            radius: 4.0,
            dotWidth: 12.0,
            dotHeight: 6.0,
            paintStyle: PaintingStyle.fill,
            // strokeWidth: 1.5,
            // dotColor: AppColors.scaffold,
            // dotColor: Theme.of(context).primaryColor,
            activeDotColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _CustomSlideItem extends StatelessWidget {
  const _CustomSlideItem({
    required this.slideModel,
    Key? key,
  }) : super(key: key);

  final _SlideModel slideModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            slideModel.illustration,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              slideModel.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              slideModel.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
