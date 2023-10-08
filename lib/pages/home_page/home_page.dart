import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_learning_app/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/my_courses_page/my_courses_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/statistic_alert_dialog.dart';
import 'package:online_learning_app/services/firestore_course_service.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/today_progress_widget.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  // static const routeName = '/home_pages/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int testCounter;

  void _goToSignInPage() async {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      SignInPage.routeName,
      (_) => false,
      arguments: SignInPageArguments(
        isFirst: false,
      ),
    );
  }

  void _goToMyCoursesPage() async {
    // context.read<AnalyticsBloc>().add(OnOpenMyCoursesPageEvent());

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
    );

    Navigator.of(context, rootNavigator: true).pushNamed(
      MyCoursesPage.routeName,
    );
  }

  void _throwTestException2() {
    throw FormatException('Button presss on Format Exception');
  }

  void _throwTestException1() {
    throw Exception();
  }

  void onTapTestLog() async {
    context.read<AnalyticsBloc>().add(OnTestLogEvent());
  }

  firebaseSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    _goToSignInPage();
  }

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(CourseBlocInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocListener<CoursesBloc, CoursesState>(
            listenWhen: (previous, current) {
              return previous.coursesList != current.coursesList;
            },
            listener: (context, state) {
              // log('*** precacheImage in HomePage');
              for (CourseModel course in state.coursesList) {
                precacheImage(NetworkImage(course.title ?? ''), context);
                // log('*** course.title: ${course.title ?? ''}');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TodayProgress(
                  // onTapMyCourses: null,
                  onTapMyCourses: () {
                    _goToMyCoursesPage();
                  },
                ),
                const Spacer(),
                CustomButton(
                  title: 'Add notification',
                  onTap: () {
                    context.read<NotificationBloc>().add(
                          AddNotificationSuccessfulPurchaseEvent(),
                        );
                  },
                ),
/*                CustomButton(
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
                ),*/
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
                    firebaseSignOut(context);
                    // log('*** name: ${ModalRoute.of(context)?.settings.name}');
                    // Navigator.of(context).
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget HomePageAppBar() {
  return const CustomAppBar(
    title: Text('HomePage'),
    action: Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
