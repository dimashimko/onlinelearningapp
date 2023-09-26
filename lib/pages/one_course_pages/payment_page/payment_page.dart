import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liqpay/liqpay.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/database/secure_storage.dart';
import 'package:online_learning_app/models/card/card_model.dart';
import 'package:online_learning_app/pages/one_course_pages/add_card_page/add_card_page.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/payment_password_bottom_sheet.dart';
import 'package:online_learning_app/pages/one_course_pages/successful_purchase_page/successful_purchase_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_themes.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  late LiqPay liqPay;

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _goToAddCardPage() {
    Navigator.of(
      context,
      rootNavigator: false,
    ).pushNamed(AddCardPage.routeName).then(
      (result) {
        // log('Result from second page: ${result.toString()}');
        if (result != null) {
          cards.add(result as CardModel);
          _saveCards(cards);
          setState(() {});
        }
      },
    );
  }

  void _goToSuccessfulPurchasePage() {
    Navigator.of(
      context,
      rootNavigator: false,
    ).pushReplacementNamed(
      SuccessfulPurchasePage.routeName,
    );
  }

  void _deleteCard(int index) {
    // _goToSuccessfulPurchasePage();
    cards.removeAt(index);
    _saveCards(cards);
    setState(() {});
  }

  void _saveCards(List<CardModel> cards) {
    String? cardsData = json.encode(cards);
    // log('*** cardsData: $cardsData');
    secureStorageDB.write(
      key: 'cards_',
      value: cardsData,
    );
  }

  void _getStoredCards() async {
    String? cardsData = await secureStorageDB.read(key: 'cards_');

    final cardsRaw =
        List<Map<String, dynamic>>.from(json.decode(cardsData ?? ''));
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

    // Handle the result here
    if (result != null) {
      if (result) {
        log('*** Result from bottom sheet: $result');
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
    final order = LiqPayOrder(
      const Uuid().v4(), widget.price, 'Test',
      card: card,
      action: LiqPayAction.pay,
      // currency: LiqPayCurrency.uah
      currency: LiqPayCurrency.usd,
    );
    if (context.mounted) {
      LiqPayResponse liqPayResponse = await liqPay.purchase(order);
      if (liqPayResponse.result == 'ok') {
        // log('*** ok');
        if (liqPayResponse.status == 'success') {
          log('*** success');

          _goToSuccessfulPurchasePage();
          context.read<ProgressBloc>().add(
                CoursePurchasedEvent(),
              );
        }
      } else {
        liqPayResponse as LiqPayErrorResponse;
        BotToast.showText(
          text: '${liqPayResponse.status}: ${liqPayResponse.errorCode} '
              '\n ${liqPayResponse.errorDescription}',
          duration: const Duration(
            seconds: 3,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    liqPay = LiqPay(
      "sandbox_i49070799254",
      "sandbox_hxuDfGwsvrH2EoWHED8F5nyHyvTikHYnPQWWOVbe",
    );

    _getStoredCards();
    cardController = PageController(
      viewportFraction: 1,
      keepPage: false,
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: paymentPageAppBar(onTap: () {
        _goToBackPage(context);
      }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                // fit: FlexFit.tight,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        itemCount: cards.length + 1,
                        controller: cardController,
                        itemBuilder: (_, index) {
                          return index == (cards.length)
                              ?
                              // Center(child: Text('Add'))
                              InkWell(
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
                    CustomSmoothPageIndicator(
                      cardController: cardController,
                      length: cards.length + 1,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                // fit: FlexFit.tight,
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

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({
    required this.cardController,
    required this.length,
    super.key,
  });

  final PageController cardController;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SmoothPageIndicator(
          controller: cardController,
          count: length,
          effect: SlideEffect(
            spacing: 8.0,
            radius: 6.0,
            dotWidth: 8.0,
            dotHeight: 8.0,
            paintStyle: PaintingStyle.fill,
            // strokeWidth: 1.5,
            // dotColor: AppColors.scaffold,
            dotColor: colors(context).violet_light ?? Colors.grey,
            activeDotColor: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    required this.cardModel,
    required this.deleteCard,
    super.key,
  });

  final CardModel cardModel;
  final VoidCallback deleteCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        CreditCardWidget(
          glassmorphismConfig: null,
          cardNumber: cardModel.cardNumber,
          expiryDate: cardModel.cardExpiryDate,
          cardHolderName: cardModel.cardHolderName,
          // cardHolderName: '_cardHolderName',
          cvvCode: cardModel.cardCvvCode,
          bankName: ' ',
          showBackView: false,
          // showBackView: true,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          // cardBgColor: Colors.green,
          cardBgColor: Theme.of(context).colorScheme.primary,
          // cardBgColor: colors(context).orange!,
          backgroundImage: null,
          isSwipeGestureEnabled: false,
          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
        ),
        InkWell(
          onTap: () => deleteCard(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Delete card',
              style: TextStyle(
                // color: colors(context).red!,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        // SvgPicture.asset(AppIcons.bucket),
      ],
    );
  }
}

PreferredSizeWidget paymentPageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: SvgPicture.asset(AppIcons.arrow_back),
    onLeading: onTap,
    title: const Text('Payment'),
    action: const Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
