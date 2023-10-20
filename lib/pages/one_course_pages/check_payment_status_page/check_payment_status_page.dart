import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liqpay/liqpay.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/models/payment_status_model/payment_status_model.dart';
import 'package:online_learning_app/pages/one_course_pages/check_payment_status_page/widgets/error_payment_widget.dart';
import 'package:online_learning_app/pages/one_course_pages/check_payment_status_page/widgets/successful_payment_widget.dart';
import 'package:online_learning_app/pages/one_course_pages/check_payment_status_page/widgets/wait_payment_status_widget.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/services/custom_liqpay_service.dart';
import 'package:online_learning_app/utils/enums.dart';
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

  Widget contentWidget = const WaitPaymentStatusWidget(counterState: 0);

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _goToCoursePage(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == OneCoursePage.routeName;
    });
  }

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
        contentWidget = ErrorPaymentWidget(
          customPaymentStatus: customPaymentStatus,
          goToBackPage: () {
            _goToBackPage(context);
          },
        );
      }

      if (liqPayResponseStatus == LiqPayResponseStatus.wait) {
        contentWidget = WaitPaymentStatusWidget(
          counterState: counter,
        );
        tryOpenUrl(customPaymentStatus.description);
      }
      if (liqPayResponseStatus == LiqPayResponseStatus.redirect) {
        tryOpenUrl(customPaymentStatus.description);
      }
    } catch (e) {}

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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarDefault(
        title: '',
        onLeading: () => _goToCoursePage(context),
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
