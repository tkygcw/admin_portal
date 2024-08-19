import 'package:emenu_admin/object/merchant.dart';
import 'package:emenu_admin/object/subscription.dart';
import 'package:emenu_admin/page/merchant/dialog/add_subscription.dart';
import 'package:emenu_admin/shareWidget/domain.dart';
import 'package:emenu_admin/shareWidget/progress_bar.dart';
import 'package:emenu_admin/shareWidget/snack_bar.dart';

import 'package:flutter/material.dart';

class SubscriptionDetail extends StatefulWidget {
  final Merchant merchant;

  SubscriptionDetail({required this.merchant});

  @override
  _SubscriptionDetailState createState() => _SubscriptionDetailState();
}

class _SubscriptionDetailState extends State<SubscriptionDetail> {
  bool status = true;
  bool isLoad = false;

  List<Subscription> subscriptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubscriptionDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        title: new Text('Subscription'),
        content: Container(height: 1000, width: 500, child: isLoad ? mainContent() : CustomProgressBar()),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey,
            ),
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: Text('Add Subscription'),
            onPressed: () {
              openSubscriptionDialog(widget.merchant, null, false);
            },
          ),
        ],
      ),
    );
  }

  Widget mainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    'Package',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Fee',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Expired',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
            ],
          ),
          subscriptions.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: subscriptions.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      subscriptions[index].subscribe_package,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 12),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'RM ' + subscriptions[index].subscribe_fee,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      Merchant.formatDate(subscriptions[index].end_date),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 13),
                                    )),
                              ],
                            ),
                            ButtonBar(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    primary: Colors.green,
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    openSubscriptionDialog(widget.merchant, subscriptions[index], true);
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    primary: Colors.red,
                                  ),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    openDeleteDialog(subscriptions[index]);
                                  },
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.blueGrey,
                            )
                          ],
                        ));
                  })
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'No Subscription Found.',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                )
        ],
      ),
    );
  }

  getSubscriptionDetail() async {
    Map data = await Domain().readSubscription(widget.merchant.merchantId.toString());
    setState(() {
      if (data['status'] == '1') {
        subscriptions.clear();
        if (data['subscription'] != false) {
          List responseJson = data['subscription'];
          subscriptions.addAll(responseJson.map((jsonObject) => Subscription.fromJson(jsonObject)).toList());
        }
      }
      isLoad = true;
    });
  }

  openSubscriptionDialog(merchant, subscription, isUpdate) {
    if (subscription == null) {
      if (subscriptions.length > 0) {
        subscription = subscriptions[subscriptions.length - 1];
      }
    }
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AddSubscription(
                merchant: merchant,
                subscription: subscription,
                isUpdate: isUpdate,
                callBack: () {
                  getSubscriptionDetail();
                },
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

  /*
  * edit product dialog
  * */
  openDeleteDialog(Subscription subscription) {
    print(subscription.id);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Text(
            "Delete Request",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 30,
            child: Text(
              'Confirm to Delete this Subscription?',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                deleteSubscription(subscription);
              },
            ),
          ],
        );
      },
    );
  }

  deleteSubscription(subscription) async {
    Map data = await Domain().deleteSubscription(subscription);
    if (data['status'] == '1') {
      CustomSnackBar.show(context, 'Delete Successfully!');
      getSubscriptionDetail();
    } else {
      CustomSnackBar.show(context, 'Something Went Wrong!');
    }
    Navigator.of(context).pop();
  }
}
