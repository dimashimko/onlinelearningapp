import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:online_learning_app/models/card/card_model.dart';

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
          cvvCode: cardModel.cardCvvCode,
          bankName: ' ',
          showBackView: false,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          cardBgColor: Theme.of(context).colorScheme.primary,
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
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
