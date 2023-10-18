import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:online_learning_app/models/card/card_model.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  static const routeName = '/one_course_pages/addCardPage';

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late OutlineInputBorder border;

  String _cardNumber = "";
  String _cardExpiryDate = "";
  String _cardHolderName = "";
  String _cardCvvCode = "";
  bool _isCvvFocused = false;
  late TextEditingController textEditingController;

  void onTapSaveNewCard() {
    if (formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      CardModel cardModel = CardModel(
        cardNumber: _cardNumber.replaceAll(' ', ''),
        cardExpiryDate: _cardExpiryDate,
        cardHolderName: _cardHolderName,
        cardCvvCode: _cardCvvCode,
        cardPaymentPassword: textEditingController.text.trim(),
      );
      Navigator.pop(context, cardModel);
    }
  }

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();

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
  }

  String? cardValidation(String? number) {
    if (number == null || number.isEmpty) {
      return "Inputs Can't be Empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarDefault(
        title: 'Add new card',
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
              cvvCode: _cardCvvCode,
              bankName: ' ',
              showBackView: _isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Theme.of(context).colorScheme.primary,
              backgroundImage: null,
              isSwipeGestureEnabled: false,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: const <CustomCardTypeIcon>[],
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
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: border,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: border,
                        labelText: 'Expired Date',
                        hintText: 'XX/XX',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: border,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Payment password (optional)',
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    )
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
