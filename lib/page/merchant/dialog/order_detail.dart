import 'package:emenu_admin/object/merchant.dart';
import 'package:emenu_admin/object/order.dart';
import 'package:emenu_admin/shareWidget/domain.dart';
import 'package:emenu_admin/shareWidget/progress_bar.dart';

import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  final Merchant merchant;

  OrderDetail({required this.merchant});

  @override
  _SalesPersonDetailState createState() => _SalesPersonDetailState();
}

class _SalesPersonDetailState extends State<OrderDetail> {
  bool status = true;
  bool isLoad = false;

  late String totalOrder;
  List<Order> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        title: new Text('Order'),
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
        ],
      ),
    );
  }

  Widget mainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Text(
                  'Total Order $totalOrder',
                  style: TextStyle(fontSize: 15),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    'Invoice',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Status',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Date',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Amount',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )),
            ],
          ),
          orders.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: orders.length,
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
                                      Order.invoiceFormat(orders[index].invoiceId.toString()),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    Order.getStatus(orders[index].status),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      Merchant.formatDate(orders[index].created_at),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      Order.countTotal(orders[index]).toStringAsFixed(2),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 13),
                                    )),
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
                  'No Order Found.',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              )
        ],
      ),
    );
  }

  getOrderDetail() async {
    Map data = await Domain().readTotalOrder(widget.merchant.merchantId.toString());
    print(data);
    setState(() {
      if (data['status'] == '1') {
        totalOrder = data['order_no'].toString();

        if (data['order'] != false) {
          List responseJson = data['order'];
          orders.addAll(responseJson.map((jsonObject) => Order.fromJson(jsonObject)).toList());
        }
      }
      isLoad = true;
    });
  }
}
