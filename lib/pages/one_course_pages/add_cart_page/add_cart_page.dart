import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/models/card/card_model.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/payment_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class AddCartPage extends StatefulWidget {
  const AddCartPage({super.key});

  static const routeName = '/one_course_pages/addCartPage';

  @override
  State<AddCartPage> createState() => _AddCartPageState();
}

class _AddCartPageState extends State<AddCartPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late OutlineInputBorder border;

  String _cardNumber = "";
  String _cardExpiryDate = "";
  String _cardHolderName = "";
  String _cardCvvCode = "";
  bool _isCvvFocused = false;

  void onTapSaveNewCard() {
    FocusScope.of(context).unfocus();
    CardModel cardModel = CardModel(
      cardNumber: _cardNumber,
      cardExpiryDate: _cardExpiryDate,
      cardHolderName: _cardHolderName,
      cardCvvCode: _cardCvvCode,
    );
    Navigator.pop(context, cardModel);
  }

  @override
  void initState() {
    super.initState();

    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );

    _cardNumber = "4242424242424242";
    final now = DateTime.now();
    _cardExpiryDate =
        '${now.month.toString().padLeft(2, '0')}/${(now.year + 1).toString().substring(2)}';
    _cardCvvCode = '000';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchases"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CreditCardWidget(
              glassmorphismConfig: null,
              cardNumber: _cardNumber,
              expiryDate: _cardExpiryDate,
              cardHolderName: _cardHolderName,
              // cardHolderName: '_cardHolderName',
              cvvCode: _cardCvvCode,
              bankName: ' ',
              showBackView: _isCvvFocused,
              // showBackView: true,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              // cardBgColor: Colors.green,
              cardBgColor: Theme.of(context).colorScheme.primary,
              backgroundImage: null,
              // isSwipeGestureEnabled: true,
              isSwipeGestureEnabled: false,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
/*                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/mastercard.png',
                    height: 48,
                    width: 48,
                  ),
                ),*/
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: _cardNumber,
                      cvvCode: _cardCvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: _cardHolderName,
                      expiryDate: _cardExpiryDate,
                      themeColor: Colors.green,
                      textColor: Colors.black,
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'CVV',
                        hintText: 'XXX',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: border,
                        enabledBorder: border,
                        labelText: 'Card Holder',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                title: "SAVE",
                onTap: () => onTapSaveNewCard(),
              ),
/*              child: ElevatedButton(
                onPressed: () async {
                    final cardDate = _cardExpiryDate.split('/');
                    final card = LiqPayCard(_cardNumber.trim(), cardDate[0],
                        cardDate[1], _cardCvvCode);
                    final order = LiqPayOrder(const Uuid().v4(), 1, 'Test',
                        card: card, action: LiqPayAction.auth);
                    await liqPay.purchase(order);
                },
                child: const Text("SAVE"),
              ),*/
            )
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      _cardNumber = creditCardModel!.cardNumber;
      _cardExpiryDate = creditCardModel.expiryDate;
      _cardHolderName = creditCardModel.cardHolderName;
      _cardCvvCode = creditCardModel.cvvCode;
      _isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
