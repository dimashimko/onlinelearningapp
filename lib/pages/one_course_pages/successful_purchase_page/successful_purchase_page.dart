import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liqpay/liqpay.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/services/custom_liqpay_service.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckPaymentStatusPageArguments {
  final LiqPayOrder liqPayOrder;

  CheckPaymentStatusPageArguments({
    required this.liqPayOrder,
  });
}

class CheckPaymentStatusPage extends StatefulWidget {
  const CheckPaymentStatusPage({
    required this.liqPayOrder,
    Key? key,
  }) : super(key: key);

  final LiqPayOrder liqPayOrder;
  static const routeName = '/one_course_pages/check_payment_status_page';

  @override
  State<CheckPaymentStatusPage> createState() => _CheckPaymentStatusPageState();
}

class _CheckPaymentStatusPageState extends State<CheckPaymentStatusPage> {
  LiqPayResponseStatus liqPayResponseStatus = LiqPayResponseStatus.wait;
  late Timer timer;
  int counter = 0;
  late CustomLiqPay customLiqPay;

  Widget contentWidget = const WaitStatusWidget(counterState: 0);

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _goToCoursePage(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      log('*** route: ${route.toString()}');
      log('*** route.settings.name: ${route.settings.name}');
      return route.settings.name == OneCoursePage.routeName;
    });
  }

/*  void _navigateToPage(String route) {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      route,
          (_) => false,
    );
  }*/

  @override
  void initState() {
    super.initState();
    customLiqPay = CustomLiqPay(
      "sandbox_i49070799254",
      "sandbox_hxuDfGwsvrH2EoWHED8F5nyHyvTikHYnPQWWOVbe",
    );

    purchase();
    startServerStatusTimer();
  }

  Future<void> purchase() async {
    Map<String, dynamic> liqPayResponse =
        await customLiqPay.customPurchase(widget.liqPayOrder);

    String? link = liqPayResponse['redirect_to'];
    if (link != null) {
      tryOpenUrl(link);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startServerStatusTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        setState(() {
          fetchServerStatus();
        });
      },
    );
  }

  Future<void> fetchServerStatus() async {
    counter++;
    ProgressBloc progressBloc = context.read<ProgressBloc>();
    NotificationBloc notificationBloc = context.read<NotificationBloc>();

    try {
      CustomPaymentStatus customPaymentStatus =
          await customLiqPay.checkOrderStatus(widget.liqPayOrder.id);
      liqPayResponseStatus = customPaymentStatus.status;

      if (liqPayResponseStatus == LiqPayResponseStatus.success) {
        timer.cancel();
        if (mounted) {
          progressBloc.add(CoursePurchasedEvent());
          notificationBloc.add(AddNotificationSuccessfulPurchaseEvent());
        }
        contentWidget = SuccessfulPaymentWidget(
          goToCoursePage: () {
            _goToCoursePage(context);
          },
        );
      }
      if (liqPayResponseStatus == LiqPayResponseStatus.error) {
        timer.cancel();
        contentWidget = ErrorWidget(
          customPaymentStatus: customPaymentStatus,
          goToBackPage: () {
            _goToBackPage(context);
          },
        );
      }

      if (liqPayResponseStatus == LiqPayResponseStatus.wait) {
        contentWidget = WaitStatusWidget(
          counterState: counter,
        );
        tryOpenUrl(customPaymentStatus.description);
      }
      if (liqPayResponseStatus == LiqPayResponseStatus.redirect) {
        tryOpenUrl(customPaymentStatus.description);
      }
    } catch (e) {
      log('*** error: $e');
    }

    setState(() {});
  }

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
    return Scaffold(
      appBar: const CustomAppBarDefault(
        title: '',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: contentWidget,
          ),
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    required this.customPaymentStatus,
    required this.goToBackPage,
    super.key,
  });

  final CustomPaymentStatus customPaymentStatus;
  final VoidCallback goToBackPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'An error occurred during payment',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const Text('Error description:'),
        Text(customPaymentStatus.description),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            title: 'Return',
            onTap: goToBackPage,
          ),
        )
      ],
    );
  }
}

class WaitStatusWidget extends StatelessWidget {
  const WaitStatusWidget({
    required this.counterState,
    Key? key,
  }) : super(key: key);

  final int counterState;

  @override
  Widget build(BuildContext context) {
    int numberOfPoint = counterState % 3 + 1;

    List<String> points = List.generate(numberOfPoint, (index) => '.');
    return SizedBox(
      width: 200,
      child: Text(
        'Payment is pending ${points.join().padRight(3 - numberOfPoint, ' ')}',
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }
}

class SuccessfulPaymentWidget extends StatelessWidget {
  const SuccessfulPaymentWidget({
    required this.goToCoursePage,
    super.key,
  });

  final VoidCallback goToCoursePage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(AppIcons.checkMark3),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Successful purchase!',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        CustomButton(
          title: 'Start learning',
          onTap: () {
            goToCoursePage();
          },
        ),
      ],
    );
  }
}
