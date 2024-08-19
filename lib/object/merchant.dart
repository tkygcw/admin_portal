import 'package:intl/intl.dart';

class Merchant {
  int? merchantId;
  int? dayLeft;

  String? formId;
  String? name;
  String? domain;
  String? dealer;
  String? registrationNo;
  String? email;
  String? companyName;
  String? endDate;
  String? subscribePackage;
  String? subscribeFee;
  String? url;
  String? address;
  String? postcode;
  String? city;
  String? state;
  String? phone;
  String? whatsAppNumber;
  String? bankDetail;
  String? cashOnDelivery;
  String? bankTransfer;
  String? allowfPay;
  String? fpayTransfer;
  String? fpayUsername;
  String? fpayApiKey;
  String? fpaySecretKey;
  String? minOrderDay;
  String? workingDay;
  String? taxPercent;
  String? selfCollectOption;
  String? emailOption;
  String? dateOption;
  String? timeOption;
  String? minPurchase;
  String? allowTNG;
  String? allowBoost;
  String? allowDuit;
  String? allowSarawak;
  String? orderReminder;
  String? allowEmail;
  String? allowWhatsApp;
  String? allowReceipt;
  String? whatsAppRemark;
  String? allowIPay;
  String? iPayMerchantCode;
  String? iPayMerchantKey;
  String? noteDefaultValue;
  String? noteRequired;

  String? facebookPage;
  String? instagramLink;
  String? phoneNumber;
  String? messengerLink;

  Merchant(
      {this.merchantId,
      this.formId,
      this.name,
      this.url,
      this.domain,
      this.dealer,
      this.endDate,
      this.dayLeft,
      this.subscribePackage,
      this.subscribeFee,
      this.registrationNo,
      this.email,
      this.companyName,
      this.address,
      this.postcode,
      this.city,
      this.state,
      this.phone,
      this.whatsAppNumber,
      this.bankDetail,
      this.cashOnDelivery,
      this.bankTransfer,
      this.allowIPay,
      this.allowfPay,
      this.fpayTransfer,
      this.fpayUsername,
      this.fpayApiKey,
      this.fpaySecretKey,
      this.iPayMerchantCode,
      this.iPayMerchantKey,
      this.emailOption,
      this.selfCollectOption,
      this.dateOption,
      this.timeOption,
      this.minOrderDay,
      this.workingDay,
      this.taxPercent,
      this.minPurchase,
      this.allowTNG,
      this.allowBoost,
      this.allowDuit,
      this.allowSarawak,
      this.allowEmail,
      this.allowWhatsApp,
      this.allowReceipt,
      this.orderReminder,
      this.whatsAppRemark,
      this.noteDefaultValue,
      this.noteRequired,
      this.facebookPage,
      this.instagramLink,
      this.phoneNumber,
      this.messengerLink});

  Merchant.fromJson(Map<String?, dynamic> json)
      : merchantId = json['merchant_id'],
        formId = json['formId'],
        domain = json['domain'],
        url = json['url'],
        name = json['name'],
        dealer = json['dealer'],
        endDate = json['end_date'],
        dayLeft = countDayLeft(json['end_date']),
        subscribePackage = json['subscribe_package'],
        subscribeFee = json['subscribe_fee'],
        registrationNo = json['registration_no'],
        email = json['email'],
        companyName = json['company_name'],
        address = json['address'],
        postcode = json['postcode'],
        city = json['city'],
        state = json['state'],
        phone = json['phone'],
        whatsAppNumber = json['whatsapp_number'],
        bankDetail = json['bank_details'],
        cashOnDelivery = json['cash_on_delivery'],
        bankTransfer = json['bank_transfer'],
        allowfPay = json['allow_fpay_transfer'],
        allowIPay = json['ipay_transfer'],
        fpayTransfer = json['fpay_transfer'],
        fpayUsername = json['fpay_username'],
        fpayApiKey = json['fpay_api_key'],
        fpaySecretKey = json['fpay_secret_key'],
        emailOption = json['email_option'].toString(),
        selfCollectOption = json['self_collect'].toString(),
        dateOption = json['delivery_date_option'].toString(),
        minOrderDay = json['order_min_day'].toString(),
        workingDay = json['working_day'].toString(),
        timeOption = json['delivery_time_option'].toString(),
        minPurchase = json['order_min_purchase'].toString(),
        taxPercent = json['tax_percent'].toString(),
        allowTNG = json['tng_manual_payment'].toString(),
        allowBoost = json['boost_manual_payment'].toString(),
        allowDuit = json['duit_now_manual_payment'].toString(),
        allowSarawak = json['sarawak_pay_manual_payment'].toString(),
        allowEmail = json['allow_send_email'].toString(),
        allowWhatsApp = json['allow_send_whatsapp'].toString(),
        allowReceipt = json['allow_receipt'].toString(),
        orderReminder = json['order_reminder'].toString(),
        whatsAppRemark = json['whatsapp_remark'].toString(),
        iPayMerchantCode = json['ipay_merchant_code'].toString(),
        iPayMerchantKey = json['ipay_merchant_key'].toString(),
        noteDefaultValue = json['note_default_value'].toString(),
        noteRequired = json['note_required'].toString(),
        facebookPage = json['facebook_page_link'].toString(),
        instagramLink = json['instagram_link'].toString(),
        messengerLink = json['messenger_link'].toString(),
        phoneNumber = json['phone_number'].toString();

  static formatDate(date) {
    try {
      final dateFormat = DateFormat("yyy-MM-dd");
      DateTime todayDate = DateTime.parse(date);
      return dateFormat.format(todayDate).toString();
    } catch (e) {
      return '';
    }
  }

  static int countDayLeft(date) {
    final currentDate = DateTime.now();
    try {
      DateTime expired = DateTime.parse(date);
      return (expired.difference(currentDate).inDays + 1);
    } on Exception {
      return 0;
    }
  }
}
