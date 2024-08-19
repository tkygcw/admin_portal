import 'package:emenu_admin/object/merchant.dart';
import 'package:emenu_admin/object/subscription.dart';
import 'package:emenu_admin/shareWidget/date_picker.dart';
import 'package:emenu_admin/shareWidget/domain.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddSubscription extends StatefulWidget {
  final Merchant merchant;
  final Subscription? subscription;
  final bool isUpdate;
  final Function() callBack;

  AddSubscription({required this.merchant, this.subscription, required this.isUpdate, required this.callBack});

  @override
  _AddSubscriptionState createState() => _AddSubscriptionState();
}

class _AddSubscriptionState extends State<AddSubscription> {
  var packageInfo = TextEditingController();
  var price = TextEditingController();
  var startDate = TextEditingController();
  var endDate = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.subscription != null) {
      if (widget.isUpdate) {
        startDate.text = widget.subscription!.start_date;
        endDate.text = widget.subscription!.end_date;
      } else {
        startDate.text = widget.subscription!.end_date;
        DateTime end = DateTime.parse(widget.subscription!.end_date);
        endDate.text = DateFormat('yyyy-MM-dd').format(DateTime(end.year + 1, end.month, end.day));
      }
      packageInfo.text = widget.subscription!.subscribe_package;
      price.text = widget.subscription!.subscribe_fee;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        title: new Text('Subscription'),
        content: Container(height: 1000, width: 500, child: mainContent()),
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
            child: Text('Add'),
            onPressed: () {
              checkingInput();
            },
          ),
        ],
      ),
    );
  }

  checkingInput() {
    if (packageInfo.text.isEmpty || price.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "All Field Above is Required!",
      );
      return;
    }
    Subscription subscription = Subscription(
        id: widget.isUpdate ? widget.subscription?.id : null,
        subscribe_package: packageInfo.text,
        subscribe_fee: price.text,
        start_date: startDate.text,
        end_date: endDate.text);

    if (widget.isUpdate) {
      editSubscription(subscription);
    } else {
      addSubscription(subscription);
    }
  }

  Widget mainContent() {
    return Container(
      child: Column(
        children: [
          TextField(
              keyboardType: TextInputType.text,
              controller: packageInfo,
              textAlign: TextAlign.start,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.info_outline),
                labelText: 'Package',
                labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                hintText: 'Package Info',
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
              )),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.text,
              controller: price,
              textAlign: TextAlign.start,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.price_change),
                labelText: 'Package Price (RM)',
                labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                hintText: '299',
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
              )),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.text,
              controller: startDate,
              onTap: () => openDatePicker('start', startDate.text),
              readOnly: true,
              textAlign: TextAlign.start,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.date_range),
                labelText: 'Start Date',
                labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
              )),
          SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: TextInputType.text,
              controller: endDate,
              onTap: () => openDatePicker('end', endDate.text),
              textAlign: TextAlign.start,
              autocorrect: false,
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.date_range),
                labelText: 'End Date',
                labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
              )),
        ],
      ),
    );
  }

  openDatePicker(type, date) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: DatePicker(
                date: date,
                callBack: (result) {
                  if (type == 'start') {
                    startDate.text = result!;
                  } else {
                    endDate.text = result!;
                  }
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

  addSubscription(subscription) async {
    Map data = await Domain().createSubscription(widget.merchant.merchantId.toString(), subscription);
    setState(() {
      if (data['status'] == '1') {
        Fluttertoast.showToast(
          msg: "Create Successfully!",
        );
        Domain().sendRenewSuccessWhatsApp(widget.merchant.merchantId.toString());
        widget.callBack();
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: "Something Went Wrong!",
        );
      }
    });
  }

  editSubscription(subscription) async {
    Map data = await Domain().editSubscription(subscription);
    print(data);
    setState(() {
      if (data['status'] == '1') {
        Fluttertoast.showToast(
          msg: "Update Successfully!",
        );
        widget.callBack();
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: "Something Went Wrong!",
        );
      }
    });
  }
}
