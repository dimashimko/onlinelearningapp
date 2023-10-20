import 'package:flutter/material.dart';
import 'package:online_learning_app/models/slide_model/slide_model.dart';
import 'package:online_learning_app/pages/auth_pages/log_in_page/log_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/widgets/custom_slide_item.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/widgets/custom_smooth_page_indicator.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_light.dart';

class SignInPageArguments {
  SignInPageArguments({
    required this.isFirst,
  });

  final bool isFirst;
}

class SignInPage extends StatefulWidget {
  const SignInPage({
    required this.isFirst,
    Key? key,
  }) : super(key: key);

  static const routeName = '/auth_pages/sign_in';
  final bool isFirst;

  @override
  State<SignInPage> createState() => _SignInPageState();
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
  }

  void _goToLogInPage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: LogInPage.routeName,
    );
  }

  late final PageController imageController;

  bool isButtonsVisible = false;

  @override
  void initState() {
    super.initState();

    imageController = PageController(
      viewportFraction: 1,
      keepPage: false,
      initialPage: widget.isFirst ? 0 : listSlideModel.length - 1,
    );
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
                          return CustomSlideItem(
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
                              onTap: () {
                                _goToLogInPage(context);
                              },
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

  final List<SlideModel> listSlideModel = [
    SlideModel(
      illustration: AppIcons.illustration_01,
      title: 'Numerous free trial courses',
      description: 'Free courses for you to find your way to learning',
    ),
    SlideModel(
      illustration: AppIcons.illustration_02,
      title: 'Quick and easy learning',
      description:
          'Easy and fast learning at any time to help you improve various skills',
    ),
    SlideModel(
      illustration: AppIcons.illustration_03,
      title: 'Create your own study plan',
      description:
          'Study according to the study plan, make study more motivated',
    ),
  ];
}
