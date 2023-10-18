class CardModel {
  String cardNumber;
  String cardExpiryDate;
  String cardHolderName;
  String cardCvvCode;
  String cardPaymentPassword;

  CardModel({
    required this.cardNumber,
    required this.cardExpiryDate,
    required this.cardHolderName,
    required this.cardCvvCode,
    required this.cardPaymentPassword,
  });



  @override
  String toString() {
    return 'CardModel{cardNumber: $cardNumber, cardExpiryDate: $cardExpiryDate, cardHolderName: $cardHolderName, cardCvvCode: $cardCvvCode, cardPaymentPassword: $cardPaymentPassword}';
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardExpiryDate': cardExpiryDate,
      'cardHolderName': cardHolderName,
      'cardCvvCode': cardCvvCode,
      'cardPaymentPassword': cardPaymentPassword,
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardNumber: json['cardNumber'],
      cardExpiryDate: json['cardExpiryDate'],
      cardHolderName: json['cardHolderName'],
      cardCvvCode: json['cardCvvCode'],
      cardPaymentPassword: json['cardPaymentPassword'],
    );
  }




}
