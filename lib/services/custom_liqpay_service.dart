import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:liqpay/liqpay.dart';
import 'package:liqpay/src/constants.dart';

enum LiqPayResponseStatus { success, wait, error, redirect }

class CustomPaymentStatus {
  final LiqPayResponseStatus status;
  final String description;

  CustomPaymentStatus(this.status, this.description);

  @override
  String toString() {
    return 'CustomPaymentStatus{status: $status, description: $description}';
  }
}

class CustomLiqPay extends LiqPay {
  CustomLiqPay(super.publicKey, super.privateKey);

  final setOfSuccessfulStatus = {
    'success',
  };

  final setOfWaitStatus = {
    '3ds_verify',
    'phone_verify',
  };

  Future<Map<String, dynamic>> customPurchase(LiqPayOrder order) async {
    final url = Uri.https(kHost, kServerApiEndpoint);

    final response = await client.post(url, body: getRequestData(order));

    log('*** response body*: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
/*      if (data["status"] == "success") {
        return LiqPayResponse.success(data);
      } else {
        return LiqPayResponse.error(data);
      }*/
    } else {
      throw HttpException(response.toString(), uri: url);
    }
  }

  Future<CustomPaymentStatus> checkOrderStatus(String id) async {
    Map<String, String> params = {};
    params['action'] = 'status';
    params['order_id'] = id;

    final url = Uri.https(kHost, kServerApiEndpoint);

    final http.Response response =
        await client.post(url, body: getRequestDataFromMap(params));

    if (response.statusCode == 200) {
      Map responseMap = json.decode(response.body);
      final String? status = responseMap["status"];

      if (setOfSuccessfulStatus.contains(status)) {
        return CustomPaymentStatus(LiqPayResponseStatus.success, '');
      } else if (setOfWaitStatus.contains(status)) {
        String? redirectTo = responseMap["redirect_to"];
        String description = redirectTo ?? '';
        return CustomPaymentStatus(LiqPayResponseStatus.wait, description);
      } else {
        String? errCode = responseMap["err_code"];
        errCode ??= 'Something wrong';
        String? errDescription = responseMap["err_description"] ?? '';
        errDescription ??= '';
        return CustomPaymentStatus(LiqPayResponseStatus.error, errDescription);
      }
    } else if (response.statusCode == 302) {
      final String location = response.headers["location"] ??
          (throw HttpException(response.toString(), uri: url));

      return CustomPaymentStatus(LiqPayResponseStatus.redirect, location);
    } else {
      throw HttpException(response.toString(), uri: url);
    }
  }
}
