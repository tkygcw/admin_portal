import 'package:emenu_admin/object/merchant.dart';
import 'package:emenu_admin/object/order.dart';
import 'package:emenu_admin/page/merchant/dialog/order_detail.dart';
import 'package:emenu_admin/page/merchant/dialog/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialog/resetPassword.dart';

class MerchantListView extends StatefulWidget {
  final Merchant merchant;
  final url;

  MerchantListView({required this.merchant, this.url});

  @override
  _MerchantListViewState createState() => _MerchantListViewState();
}

class _MerchantListViewState extends State<MerchantListView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.merchant.name ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => openMerchantLink(),
                child: Text(
                  getUrl(),
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
              ),
              Text(
                'Dealer ${widget.merchant.dealer}',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Expired Date ${Merchant.formatDate(widget.merchant.endDate)}',
                style: TextStyle(fontSize: 13),
              ),
              Text('${widget.merchant.dayLeft} Day Left'),
              ButtonBar(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ),
                    child: Text('Copy Detail'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: getShareInfo()));
                      showSnackBar('Copy Successfully');
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: Text('WhatsApp'),
                    onPressed: () {
                      Order.openWhatsApp(widget.merchant.whatsAppNumber, getUrl(), context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text('Share'),
                    onPressed: () {
                      Order.shareOrder(getShareInfo(), context);
                    },
                  ),
                ],
              )
            ],
          ),
          trailing: popUpMenu()),
    );
  }

  openMerchantLink() async {
    try {
      var url = Uri.parse(getUrl());
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        showSnackBar('Unable to open');
      }
    } catch (e) {
      showSnackBar(e);
    }
  }

  getShareInfo() {
    return '${getUrl()}'
        '\nExpired Date: ${Merchant.formatDate(widget.merchant.endDate)}'
        '\nPackage: ${widget.merchant.subscribePackage}'
        '\nLast Subscription: RM${widget.merchant.subscribeFee}'
        '\nWhatsApp: wasap.my/${widget.merchant.whatsAppNumber}'
        '\nPhone: wasap.my/${widget.merchant.phone}';
  }

  getUrl() {
    String url;
    if (widget.merchant.domain!.isNotEmpty) {
      url = '${widget.merchant.domain}';
    } else {
      url = 'https://emenu.com.my/${widget.merchant.url}';
    }
    return url;
  }

  Widget popUpMenu() {
    return new PopupMenuButton(
      icon: Icon(Icons.tune),
      offset: Offset(0, 10),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'order_detail',
          child: Text('Order Detail'),
        ),
        PopupMenuItem(
          value: 'subscription',
          child: Text('Subscription'),
        ),
        PopupMenuItem(
          value: 'reset',
          child: Text('Reset Password'),
        ),
      ],
      onCanceled: () {},
      onSelected: (value) {
        switch (value) {
          case 'order_detail':
            openOrderDetail(widget.merchant);
            break;
          case 'subscription':
            openSubscription(widget.merchant);
            break;
          case 'reset':
            resetPassword(widget.merchant);
            break;
        }
      },
    );
  }

  openOrderDetail(merchant) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: OrderDetail(
                merchant: merchant,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Text('');
        });
  }

  resetPassword(merchant) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: ResetLoginCredential(
                merchant: merchant,
                callBack: () {},
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Text('');
        });
  }

  openSubscription(merchant) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: SubscriptionDetail(
                merchant: merchant,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Text('');
        });
  }

  void showSnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
