import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:online_learning_app/pages/course_page/course_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class NoVideosPage extends StatelessWidget {
  const NoVideosPage({Key? key}) : super(key: key);

  static const routeName = '/template_pages/template_page';

  void _goToCoursesPage(BuildContext context) {
    context.read<NavigationBloc>().add(
          NavigateTab(
            tabIndex: 1,
            route: CoursePage.routeName,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarDefault(
        title: '',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.Illustration_no_video,
                ),
                Text(
                  'No videos!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Here is no video you want at the moment',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: 240,
                  child: CustomButton(
                    title: 'Search more',
                    onTap: () => _goToCoursesPage(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
