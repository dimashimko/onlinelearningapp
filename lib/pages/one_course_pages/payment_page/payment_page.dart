import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liqpay/liqpay.dart';
import 'package:online_learning_app/database/secure_storage.dart';
import 'package:online_learning_app/models/card/card_model.dart';
import 'package:online_learning_app/pages/one_course_pages/add_card_page/add_card_page.dart';
import 'package:online_learning_app/pages/one_course_pages/check_payment_status_page/check_payment_status_page.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/widgets/card_item.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/widgets/custom_smooth_payment_page_indicator.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/widgets/payment_password_bottom_sheet.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:uuid/uuid.dart';

class PaymentPageArguments {
  PaymentPageArguments({
    required this.price,
  });

  final double price;
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    required this.price,
    Key? key,
  }) : super(key: key);

  final double price;
  static const routeName = '/one_course_pages/payment_page';

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<CardModel> cards = [];
  SecureStorageDB secureStorageDB = SecureStorageDB.instance;
  late final PageController cardController;

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

  void _goToAddCardPage() {
    Navigator.of(
      context,
      rootNavigator: false,
    ).pushNamed(AddCardPage.routeName).then(
      (result) {
        if (result != null) {
          result as CardModel;

          cards.add(result);
          _saveCards(cards);
          setState(() {});
        }
      },
    );
  }

  void _goToCheckPaymentStatusPage({required LiqPayOrder liqPayOrder}) {
    _navigateToPage(
      context: context,
      route: CheckPaymentStatusPage.routeName,
      arguments: CheckPaymentStatusPageArguments(
        liqPayOrder: liqPayOrder,
      ),
    );
  }

  void _deleteCard(int index) {
    cards.removeAt(index);
    _saveCards(cards);
    setState(() {});
  }

  void _saveCards(List<CardModel> cards) {
    String? cardsData = json.encode(cards);

    secureStorageDB.saveCards(
      value: cardsData,
    );
  }

  void _getStoredCards() async {
    String? cardsData = await secureStorageDB.loadCards();

    final cardsRaw = List<Map<String, dynamic>>.from(
      json.decode(
        cardsData ?? '',
      ),
    );
    List<CardModel> cardsList = [];
    for (Map<String, dynamic> cardRaw in cardsRaw) {
      cardsList.add(
        CardModel.fromJson(
          cardRaw,
        ),
      );
    }
    cards = cardsList;
    setState(() {});
  }

  Future<bool?> _showBottomSheet({
    required String correctPin,
  }) async {
    final bool? result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BottomSheetPaymentPassword(
          correctPin: correctPin,
        );
      },
    );

    if (result != null) {
      if (result) {
        return true;
      }
    }
    return null;
  }

  _onTapPay() async {
    int cardIndex = ((cardController.page ?? 0.0) + 0.5).toInt();
    CardModel currentCard = cards[cardIndex];

    bool? isConfirmed =
        await _showBottomSheet(correctPin: currentCard.cardPaymentPassword);
    if (isConfirmed != null) {
      if (isConfirmed) {
        _purchase(currentCard);
      }
    }
  }

  _purchase(CardModel currentCard) async {
    final cardDate = currentCard.cardExpiryDate.split('/');

    final card = LiqPayCard(
      currentCard.cardNumber.trim(),
      cardDate[0],
      cardDate[1],
      currentCard.cardCvvCode,
    );
    final LiqPayOrder liqPayOrder = LiqPayOrder(
      const Uuid().v4(),
      widget.price,
      'Test',
      card: card,
      action: LiqPayAction.pay,
      currency: LiqPayCurrency.usd,
    );
    if (context.mounted) {
      _goToCheckPaymentStatusPage(liqPayOrder: liqPayOrder);
    }
  }

  @override
  void initState() {
    super.initState();

    _getStoredCards();
    cardController = PageController(
      viewportFraction: 1,
      keepPage: false,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    cardController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarDefault(
        title: 'Payment',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        itemCount: cards.length + 1,
                        controller: cardController,
                        itemBuilder: (_, index) {
                          return index == (cards.length)
                              ? InkWell(
                                  onTap: () => _goToAddCardPage(),
                                  child: SvgPicture.asset(
                                    AppIcons.plus4,
                                    fit: BoxFit.scaleDown,
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).colorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                )
                              : CardItem(
                                  cardModel: cards[index % cards.length],
                                  deleteCard: () {
                                    _deleteCard(index);
                                  },
                                );
                        },
                      ),
                    ),
                    CustomSmoothPaymentPageIndicator(
                      cardController: cardController,
                      length: cards.length + 1,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: CustomButton(
                    title: 'Pay Now ${widget.price}\$',
                    onTap: () {
                      _onTapPay();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

