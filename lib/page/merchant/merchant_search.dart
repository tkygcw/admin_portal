import 'package:emenu_admin/page/merchant/merchant_list.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var queryController = TextEditingController();
  GlobalKey<MerchantListState> key = GlobalKey<MerchantListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
              controller: queryController,
              autofocus: true,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Search by name or url',
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.orangeAccent,
                    onPressed: () {
                      queryController.clear();
                    }),
              ),
              style: TextStyle(color: Colors.black87),
              onChanged: (text) async {
                key.currentState!.search(text);
              }),
          iconTheme: IconThemeData(color: Colors.orangeAccent),
        ),
        backgroundColor: Colors.white,
        body: MerchantList(
          type: 'all',
          query: '',
          key: key,
        ));
  }
}
