import 'dart:async';

import 'package:emenu_admin/object/merchant.dart';
import 'package:emenu_admin/page/merchant/merchant_list_view.dart';
import 'package:emenu_admin/shareWidget/domain.dart';
import 'package:emenu_admin/shareWidget/not_found.dart';
import 'package:emenu_admin/shareWidget/progress_bar.dart';
import 'package:flutter/material.dart';

class MerchantList extends StatefulWidget {
  final String query;
  final String type;
  final Key key;

  MerchantList({required this.query, required this.type, required this.key});

  @override
  MerchantListState createState() => MerchantListState();
}

class MerchantListState extends State<MerchantList> {
  List<Merchant> list = [];
  var url;
  bool dataFound = false;
  bool isLoading = true;
  List<Merchant> tempList = [];
  late StreamController queryStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryStream = StreamController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMerchantList(),
        builder: (context, object) {
          return isLoading
              ? CustomProgressBar()
              : dataFound
                  ? customListView()
                  : notFound();
        });
  }

  Widget customListView() {
    return StreamBuilder(
        stream: queryStream.stream,
        builder: (context, object) {
          return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return MerchantListView(
                  merchant: list[index],
                  url: url,
                );
              });
        });
  }

  Widget notFound() {
    return NotFound(
        title: 'Merchant Not Found',
        description: 'Nothing found here...',
        showButton: true,
        refresh: () {
          setState(() {
            onRefresh();
          });
        },
        button: 'Refresh',
        drawable: 'drawable/not_found.png');
  }

  onRefresh() async {
    if (mounted)
      setState(() {
        queryStream = StreamController();
        list.clear();
        isLoading = true;
        getMerchantList();
      });
  }

  getMerchantList() async {
    Map data = await Domain().readMerchant();
    await Future.delayed(Duration(milliseconds: 500));
    if (data['status'] == '1') {
      list.clear();
      tempList.clear();
      List responseJson = data['merchant'];
      list.addAll(responseJson.map((jsonObject) {
        return Merchant.fromJson(jsonObject);
      }).toList());
      tempList = list;
      /**
       * sort merchant from smaller day left to higher
       */
      list.sort((a, b) => a.dayLeft!.compareTo(b.dayLeft ?? 0));
      /**
       * show merchant who going to expired within 10 days
       */
      if (widget.type == 'expired_soon') {
        list = list.where((merchant) => merchant.dayLeft! <= 10).toList();
      }
    }
    //ui control
    dataFound = data['status'] == '1';
    isLoading = false;
  }

  // search
  search(String query) {
    List<Merchant> results = [];
    if (query.isEmpty) {
      results = tempList;
    } else {
      results = tempList
          .where(
              (merchant) => merchant.name!.toLowerCase().contains(query.toLowerCase()) || merchant.url!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    list = results;
    queryStream.add('');
  }
}
