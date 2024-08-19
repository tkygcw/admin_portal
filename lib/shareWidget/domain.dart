import 'dart:convert';

import 'package:emenu_admin/object/subscription.dart';
import 'package:emenu_admin/object/user.dart';
import 'package:emenu_admin/shareWidget/sharePreference.dart';
import 'package:http/http.dart' as http;

class Domain {
  static var domain = 'https://www.myadmin.emenu.com.my/';
  static var webDomain = 'https://www.cp.emenu.com.my/';
  static var shareDomain = 'https://share.emenu.com.my/';

  //testing server
  // static var domain = 'https://emenumobile.lkmng.com/';
  // static var webDomain = 'https://www.formtest.lkmng.com/';
  // static var shareDomain = 'https://emenumobile.lkmng.com/share/';
  static Uri registration = Uri.parse(domain + 'registration/index.php');
  static Uri merchant = Uri.parse(domain + 'merchant/index.php');

  static Uri order = Uri.parse(domain + 'mobile_api/order/index.php');
  static Uri product = Uri.parse(domain + 'mobile_api/product/index.php');
  static Uri orderItem = Uri.parse(domain + 'mobile_api/order_detail/index.php');
  static Uri postcode = Uri.parse(domain + 'mobile_api/postcode/index.php');
  static Uri orderGroup = Uri.parse(domain + 'mobile_api/order_group/index.php');
  static Uri driver = Uri.parse(domain + 'mobile_api/driver/index.php');
  static Uri profile = Uri.parse(domain + 'mobile_api/profile/index.php');
  static Uri user = Uri.parse(domain + 'mobile_api/user/index.php');
  static Uri discount = Uri.parse(domain + 'mobile_api/coupon/index.php');
  static Uri notification = Uri.parse(domain + 'mobile_api/notification/index.php');
  static Uri category = Uri.parse(domain + 'mobile_api/category/index.php');
  static Uri export = Uri.parse(domain + 'mobile_api/export/index.php');
  static Uri form = Uri.parse(domain + 'mobile_api/form/index.php');
  static Uri shipping = Uri.parse(domain + 'mobile_api/shipping/index.php');
  static Uri promotionDialog = Uri.parse(domain + 'mobile_api/promotion_dialog/index.php');
  static Uri printer = Uri.parse(domain + 'mobile_api/printer/index.php');
  static Uri lanPrinter = Uri.parse(domain + 'mobile_api/printer/lanprinter/index.php');
  static Uri salesPerson = Uri.parse(domain + 'mobile_api/agent/profile/index.php');
  static Uri dineInTable = Uri.parse(domain + 'mobile_api/table/index.php');
  static Uri courier = Uri.parse(domain + 'mobile_api/courier/index.php');
  static Uri courierLogoPath = Uri.parse(domain + 'mobile_api/courier/logo/');
  static Uri analysis = Uri.parse(domain + 'mobile_api/analysis/index.php');
  static Uri easyParcelSetting = Uri.parse(domain + 'mobile_api/easy_parcel/index.php');

  /*
  * Web Domain
  *
  * */
  static Uri whatsAppLink = Uri.parse(webDomain + 'order/view-order.php');
  static Uri imagePath = Uri.parse(webDomain + 'product/image/');
  static Uri proofImgPath = Uri.parse(webDomain + 'order/proof_img/');
  static Uri invoiceLink = Uri.parse(webDomain + 'order/print.php?print=true&&id=');
  static Uri whatsAppApi = Uri.parse(webDomain + 'whatsapp/index.php');
  static Uri laLaMoveApi = Uri.parse(webDomain + 'merchant/lalamove/index.php');
  static Uri receiptPath = Uri.parse(webDomain + 'order/receipt/');
  static Uri easyParcel = Uri.parse(webDomain + 'merchant/easyparcel/index.php');

  /*
  * launch check
  * */
  launchCheck() async {
    var response = await http.post(Domain.registration, body: {
      'launch_check': '1',
      'dealer_id': Dealer.fromJson(await SharePreferences().read("dealer")).dealerId,
    });
    return jsonDecode(response.body);
  }

  /*
  * login
  * */
  login(email, password) async {
    var response = await http.post(Domain.registration, body: {
      'login': '1',
      'email': email,
      'password': password,
    });
    return jsonDecode(response.body);
  }

  /*
  * get merchant list
  * */
  readMerchant() async {
    var response = await http.post(Domain.merchant, body: {
      'read': '1',
      'dealer_id': Dealer.fromJson(await SharePreferences().read("dealer")).dealerId,
    });
    return jsonDecode(response.body);
  }

  /*
  * get merchant total order
  * */
  readTotalOrder(merchantId) async {
    var response = await http.post(Domain.merchant, body: {
      'order_detail': '1',
      'merchant_id': merchantId,
    });
    return jsonDecode(response.body);
  }

  /*
  * get subscription
  * */
  readSubscription(merchantId) async {
    var response = await http.post(Domain.merchant, body: {
      'read_subscription': '1',
      'merchant_id': merchantId,
    });
    return jsonDecode(response.body);
  }

  /*
  * get subscription
  * */
  createSubscription(merchantId, Subscription subscription) async {
    var response = await http.post(Domain.merchant, body: {
      'create_subscription': '1',
      'merchant_id': merchantId,
      'subscribe_package': subscription.subscribe_package,
      'subscribe_fee': subscription.subscribe_fee,
      'start_date': subscription.start_date,
      'end_date': subscription.end_date,
    });
    return jsonDecode(response.body);
  }

  /*
  * send whatsapp
  * */
  sendRenewSuccessWhatsApp(merchantId) async {
    var response = await http.post(Domain.whatsAppApi, body: {
      'send_renew_success': '1',
      'merchant_id': merchantId,
    });
    return jsonDecode(response.body);
  }

  /*
  * edit subscription
  * */
  editSubscription(Subscription subscription) async {
    var response = await http.post(Domain.merchant, body: {
      'edit_subscription': '1',
      'id': subscription.id.toString(),
      'subscribe_package': subscription.subscribe_package,
      'subscribe_fee': subscription.subscribe_fee,
      'start_date': subscription.start_date,
      'end_date': subscription.end_date,
    });
    return jsonDecode(response.body);
  }

  /*
  * reset password
  * */
  resetLoginCredentials(newPassword, newEmail, merchantId) async {
    var response = await http.post(Domain.registration, body: {
      'reset_password': '1',
      'new_password': newPassword,
      'email': newEmail,
      'merchant_id': merchantId,
    });
    return jsonDecode(response.body);
  }

  /*
  * delete subscription
  * */
  deleteSubscription(Subscription subscription) async {
    var response = await http.post(Domain.merchant, body: {
      'delete_subscription': '1',
      'id': subscription.id.toString(),
    });
    return jsonDecode(response.body);
  }
}
