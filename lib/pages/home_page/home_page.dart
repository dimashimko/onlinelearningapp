import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_learning_app/blocs/account_bloc/account_bloc.dart';
import 'package:online_learning_app/blocs/ads_block/ads_bloc.dart';
import 'package:online_learning_app/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/firebase_options.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/my_courses_page/my_courses_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/statistic_alert_dialog.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/resources/app_themes.dart';
import 'package:online_learning_app/services/firestore_course_service.dart';
import 'package:online_learning_app/services/notifi_service.dart';
import 'package:online_learning_app/utils/count_completed_lesson.dart';
import 'package:online_learning_app/utils/get_course_model_by_uid.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';
import 'package:online_learning_app/widgets/elements/today_progress_widget.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int testCounter;

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

  void _goToMyCoursesPage() async {
/*    // context.read<AnalyticsBloc>().add(OnOpenMyCoursesPageEvent());

    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    analytics.setAnalyticsCollectionEnabled(true);
    await analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true.toString(),
      },
    );*/

    Navigator.of(context, rootNavigator: true).pushNamed(
      MyCoursesPage.routeName,
    );
  }

  void _goToOneCoursePage({
    required String uidCourse,
  }) async {
    _navigateToPage(
      context: context,
      route: OneCoursePage.routeName,
      arguments: OneCoursePageArguments(
        uidCourse: uidCourse,
      ),
      isRoot: true,
    );
  }

/*  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(
          CourseBlocInit(),
        );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: const CustomAppBarDefault(
        title: 'HomePage',
      ),*/

      body: SafeArea(
        child: BlocListener<CoursesBloc, CoursesState>(
          listenWhen: (previous, current) {
            return previous.coursesList != current.coursesList;
          },
          listener: (context, state) {
            for (CourseModel course in state.coursesList) {
              try {
                if (course.title != null && course.title!.isNotEmpty) {
                  precacheImage(
                    NetworkImage(course.title ?? ''),
                    context,
                  );
                }
              } catch (e) {
                log(e.toString());
              }
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const UserInfoWidget(),
                Container(
                  height: 32.0,
                  color: colors(context).blue,
                ),
                TodayProgressWidgetWithBackground(
                  goToMyCoursesPage: () => _goToMyCoursesPage(),
                ),
                const SizedBox(height: 16.0),
                AdsWidget(
                  goToOneCoursePage: (uidCourse) {
                    _goToOneCoursePage(
                      uidCourse: uidCourse,
                    );
                  },
                ),
                const LearningPlanWidget(),
                const MeetupBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MeetupBanner extends StatelessWidget {
  const MeetupBanner({super.key});

  void tryOpenUrl(String link) {
    final Uri? uri = Uri.tryParse(link);
    if (uri != null) {
      _launchUrl(uri);
    }
  }

  Future<void> _launchUrl(Uri url) async {
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          tryOpenUrl('https://engplace.in.ua/en/');
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors(context).pink,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meetup',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24.0,
                                  color: colors(context).violet,
                                ),
                      ),
                      Text(
                        'Off-line exchange of learning experiences',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  color: colors(context).violet,
                                ),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.meetupIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LearningPlanWidget extends StatelessWidget {
  const LearningPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Plan',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8.0),
          Container(
            height: 120.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<CoursesBloc, CoursesState>(
                builder: (context, state) {
                  Map<String, CourseProgressModel>? userProgress =
                      context.read<ProgressBloc>().state.userProgress;
                  context.read<CoursesBloc>().add(
                        FilterUserCourses(
                          userProgress:
                              context.read<ProgressBloc>().state.userProgress,
                        ),
                      );
                  return SingleChildScrollView(
                    child: Column(
                      children: state.userCoursesList.map(
                        (e) {
                          int lessonCompleted = countCompletedLesson(
                            userProgress: userProgress?[e.uid],
                          );
                          return CourseProgressItem(
                            courseModel: e,
                            lessonCompleted: lessonCompleted,
                          );
                        },
                      ).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseProgressItem extends StatelessWidget {
  const CourseProgressItem({
    required this.courseModel,
    required this.lessonCompleted,
    super.key,
  });

  final CourseModel courseModel;
  final int lessonCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Center(
            child: SizedBox(
              height: 18.0,
              width: 18.0,
              child: CircularProgressIndicator(
                value: lessonCompleted / (courseModel.lessons?.length ?? 1.0),
                color: colors(context).greyDark,
                backgroundColor: colors(context).violetLight,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              courseModel.name ?? '',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Text(
                lessonCompleted.toString(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
              ),
              Text(
                '/${courseModel.lessons?.length}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdsWidget extends StatelessWidget {
  const AdsWidget({
    required this.goToOneCoursePage,
    super.key,
  });

  final Function(String) goToOneCoursePage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you want to learn today?',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
          ),
          AdsListView(
            onTapAdsCourse: (uidCourse) {
              goToOneCoursePage(uidCourse);
              log('*** uidCategory: $uidCourse');
            },
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class AdsListView extends StatelessWidget {
  const AdsListView({
    required this.onTapAdsCourse,
    super.key,
  });

  final Function(String) onTapAdsCourse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        top: 5,
        bottom: 5.0,
      ),
      child: SizedBox(
        height: 156,
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, coursesState) {
            return BlocBuilder<AdsBloc, AdsState>(
              builder: (context, adsState) {
                return ListView.separated(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                    ),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 8.0,
                        ),
                    itemCount: adsState.adsCoursesUids.length,
                    itemBuilder: (context, index) {
                      CourseModel? courseModel = getCourseModelByUid(
                        adsState.adsCoursesUids[index],
                        coursesState.coursesList,
                      );
                      if (courseModel == null) return null;
                      return InkWell(
                        onTap: () {
                          onTapAdsCourse(adsState.adsCoursesUids[index]);
                        },
                        child: SizedBox(
                          width: 250,
                          child: AdsCourseItem(
                            courseModel: courseModel,
                          ),
                        ),
                      );
                    });
              },
            );
          },
        ),
      ),
    );
  }
}

class AdsCourseItem extends StatelessWidget {
  const AdsCourseItem({
    required this.courseModel,
    super.key,
  });

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return CustomImageViewer(
      link: courseModel.title,
      alternativePhoto: AppImages.empty_course,
    );
  }
}

class TodayProgressWidgetWithBackground extends StatelessWidget {
  const TodayProgressWidgetWithBackground({
    required this.goToMyCoursesPage,
    super.key,
  });

  final VoidCallback goToMyCoursesPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50.0,
          color: colors(context).blue,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TodayProgress(
            onTapMyCourses: () {
              goToMyCoursesPage();
            },
          ),
        ),
      ],
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors(context).blue,
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${state.accountModel.name ?? 'User'}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: colors(context).white,
                            fontSize: 24.0,
                          ),
                    ),
                    Text(
                      'Let’s start learning',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: colors(context).white,
                            fontSize: 14.0,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 96.0,
                  width: 96.0,
                  child: CustomImageViewer(
                    link: state.accountModel.avatarLink,
                    alternativePhoto: AppImages.empty_avatar,
                    boxFitNetworkImage: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  void _goToSignInPage() async {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      SignInPage.routeName,
      (_) => false,
      arguments: SignInPageArguments(
        isFirst: false,
      ),
    );
  }

  void _throwTestException2() {
    throw const FormatException('Button presses on Format Exception');
  }

  void _throwTestException1() {
    throw Exception();
  }

  void onTapTestLog() async {
    context.read<AnalyticsBloc>().add(OnTestLogEvent());
  }

  logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    ).signOut();
    _goToSignInPage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          title: 'Add notification2',
          onTap: () {
            NotificationService().showNotification(
              title: 'Sample title',
              body: 'It works!',
              payLoad: 'payLoad',
            );
          },
        ),
        const SizedBox(height: 8.0),
        CustomButton(
          title: 'Add notification',
          onTap: () {
            context.read<NotificationBloc>().add(
                  AddNotificationSuccessfulPurchaseEvent(),
                );
          },
        ),
        const SizedBox(height: 8.0),
        CustomButton(
          title: 'Show Alert',
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CustomAlertDialog();
              },
            );
          },
        ),
        const SizedBox(height: 8.0),
        CustomButton(
          title: 'Test Log Event',
          onTap: () {
            onTapTestLog();
          },
        ),
        const SizedBox(height: 8.0),
        CustomButton(
          title: 'FillCourses',
          onTap: () {
            MyFirestoreCourseService fireStoreService =
                MyFirestoreCourseService();
            fireStoreService.fillCourses();
          },
        ),
        const SizedBox(height: 8.0),
        CustomButton(
          title: 'LogOut',
          onTap: () {
            logOut(context);
          },
        ),
        const SizedBox(height: 8.0),
        CustomButton(
          title: 'Throw Test Exception2',
          onTap: () {
            _throwTestException2();
          },
        ),
        const SizedBox(height: 8.0),
        CustomButton(
          title: 'Throw Test Exception1',
          onTap: () {
            _throwTestException1();
          },
        ),
      ],
    );
  }
}

PreferredSizeWidget homePageAppBar() {
  return const CustomAppBar(
    title: Text(
      'HomePage',
    ),
    action: Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
