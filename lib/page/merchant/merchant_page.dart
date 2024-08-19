import 'package:emenu_admin/page/merchant/merchant_list.dart';
import 'package:emenu_admin/page/merchant/merchant_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MerchantPage extends StatefulWidget {
  final String query;

  MerchantPage({required this.query});

  @override
  _MerchantPageState createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  int currentPosition = 0;
  GlobalKey<MerchantListState> expiredKey = GlobalKey<MerchantListState>();
  GlobalKey<MerchantListState> allKey = GlobalKey<MerchantListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Merchant',
            textAlign: TextAlign.center,
            style: GoogleFonts.cantoraOne(
              textStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15),
            )),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'drawable/emenu.png',
            height: 50,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.orangeAccent),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (currentPosition == 0) {
                expiredKey.currentState!.onRefresh();
              } else {
                allKey.currentState!.onRefresh();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                  onTap: (position) {
                    currentPosition = position;
                  },
                  indicatorColor: Colors.redAccent,
                  labelColor: Colors.redAccent,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: false,
                  tabs: [
                    Tab(text: 'Expired Soon'),
                    Tab(text: 'All'),
                  ]),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                    children: [MerchantList(query: '', type: 'expired_soon', key: expiredKey), MerchantList(query: '', type: 'all', key: allKey)]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
