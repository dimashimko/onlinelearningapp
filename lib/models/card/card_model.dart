class CardModel {
  String cardNumber;
  String cardExpiryDate;
  String cardHolderName;
  String cardCvvCode;

  CardModel({
    required this.cardNumber,
    required this.cardExpiryDate,
    required this.cardHolderName,
    required this.cardCvvCode,
  });

  // Convert CardModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardExpiryDate': cardExpiryDate,
      'cardHolderName': cardHolderName,
      'cardCvvCode': cardCvvCode,
    };
  }

  // Create CardModel from JSON
  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardNumber: json['cardNumber'],
      cardExpiryDate: json['cardExpiryDate'],
      cardHolderName: json['cardHolderName'],
      cardCvvCode: json['cardCvvCode'],
    );
  }


/*  factory CardModel.fromJson(Map<String, dynamic> json) {
    // cardNumber = json['cardNumber'];
    // cardExpiryDate = json['cardExpiryDate'];
    // cardHolderName = json['cardHolderName'];
    // cardCvvCode = json['cardCvvCode'];
  }*/
}
