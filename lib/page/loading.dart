import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:emenu_admin/object/user.dart';
import 'package:emenu_admin/shareWidget/domain.dart';
import 'package:emenu_admin/shareWidget/not_found.dart';
import 'package:emenu_admin/shareWidget/progress_bar.dart';
import 'package:emenu_admin/shareWidget/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  /*
  * network checking purpose
  * */
  late StreamSubscription<ConnectivityResult> connectivity;
  bool networkConnection = true;

  final key = new GlobalKey<ScaffoldState>();
  late String status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('haha');
    connectivity = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        networkConnection = (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
      });
    });
    netWorkChecking();
  }

  @override
  void dispose() {
    super.dispose();
    connectivity.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: networkConnection ? CustomProgressBar() : networkNotFound(),
    );
  }

  Widget networkNotFound() {
    return NotFound(
        title: 'No Network Found!',
        description: 'Please check your network connection!',
        showButton: true,
        refresh: () {
          setState(() {});
        },
        button: 'Retry',
        drawable: 'drawable/no_wifi.png');
  }

  netWorkChecking() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      checkMerchantInformation();
    } else {
      setState(() {
        networkConnection = false;
      });
    }
  }

  void checkMerchantInformation() async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      var data = await SharePreferences().read('dealer');
      if (data != null) {
        launchChecking();
      } else
        Navigator.pushReplacementNamed(context, '/login');
    } on Exception {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void launchChecking() async {
    Map data = await Domain().launchCheck();
    if (data['status'] == '1') {
      status = data['launch_check']['status'].toString();

      //email & device checking
      // print('email ${await SharePreferences().read('email')}');
      String email = await SharePreferences().read('email') ?? '';
      if (email.isEmpty) {
        SharePreferences().save('email', data['launch_check']['email']);
      } else if (email != data['launch_check']['email']) {
        openDisableDialog();
        return;
      }
      checkMerchantStatus();
    } else
      openDisableDialog();
  }

  checkMerchantStatus() async {
    if (mounted) {
      String dealerStatus = status;
      if (dealerStatus == '0') {
        Dealer dealer = Dealer.fromJson(await SharePreferences().read('dealer'));
        dealer.dealerId.isNotEmpty ? Navigator.pushReplacementNamed(context, '/merchant') : Navigator.pushReplacementNamed(context, '/login');
      } else
        openDisableDialog();
    }
  }

  getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /*
  * edit product dialog
  * */
  openDisableDialog() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: Text(
            "Something Went Wrong",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('drawable/error.png'),
                Text(
                  'Your Account is unable to access!',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                SharePreferences().clear();
                Navigator.of(context).pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
            TextButton(
              child: Text(
                'Contact',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                SharePreferences().clear();
                launchUrl((Uri.parse('https://www.emenu.com.my')));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
