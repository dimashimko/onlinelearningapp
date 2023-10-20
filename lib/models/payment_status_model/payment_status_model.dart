import 'package:online_learning_app/services/custom_liqpay_service.dart';

class CustomPaymentStatus {
  final LiqPayResponseStatus status;
  final String description;

  CustomPaymentStatus(this.status, this.description);

  @override
  String toString() {
    return 'CustomPaymentStatus{status: $status, description: $description}';
  }
}
