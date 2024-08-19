import 'package:emenu_admin/shareWidget/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class Order {
  String? invoiceId, status, total_amount, tax, delivery_fee, discount_amount, coupon_discount, created_at;

  Order({this.invoiceId, this.status, this.total_amount, this.tax, this.delivery_fee, this.discount_amount, this.coupon_discount, this.created_at});

  factory Order.fromJson(Map<String, dynamic> json) {
    print(json['coupon_discount']);
    return Order(
        invoiceId: json['invoice_id'] as String,
        status: json['status'] as String,
        total_amount: json['total_amount'] as String,
        tax: json['tax'] as String,
        delivery_fee: json['delivery_fee'],
        discount_amount: json['discount_amount'],
        coupon_discount: json['coupon_discount'].toString(),
        created_at: json['created_at'] as String);
  }

  static String invoiceFormat(orderID) {
    String prefix = '';
    for (int i = orderID.length; i < 5; i++) {
      prefix = prefix + "0";
    }
    return '\#' + prefix + orderID;
  }

  static String getStatus(status) {
    switch (status) {
      case '1':
        return 'New';
      case '2':
        return 'Processing';
      case '3':
        return 'Canceled';
      default:
        return 'Completed';
    }
  }

  static double countTotal(Order order) {
    return convertToInt(order.delivery_fee) +
        convertToInt(order.total_amount) +
        convertToInt(order.tax) -
        convertToInt(order.discount_amount) -
        convertToInt(order.coupon_discount);
  }

  static convertToInt(value) {
    try {
      return double.parse(value ?? 0);
    } catch (e) {
      return 0;
    }
  }

  static openWhatsApp(phone, message, context) async {
    try {
      var url = "https://api.whatsapp.com/send?phone=$phone&text=$message";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url),
            mode: !kIsWeb && Platform.isIOS ? LaunchMode.externalNonBrowserApplication : LaunchMode.externalNonBrowserApplication);
      } else {
        debugPrint('Something Went Wrong!');
      }
    } catch (e) {
      CustomSnackBar.show(context, 'WhatsApp Not Found!');
    }
  }

  static shareOrder(message, context) async {
    try {
      message = message.replaceAll(' ', '%20');
      var url = "https://wa.me/?text=$message";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        debugPrint('Something Went Wrong!');
      }
    } catch (e) {
      CustomSnackBar.show(context, 'WhatsApp Not Found!');
    }
  }
}
