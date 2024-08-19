import 'package:emenu_admin/object/merchant.dart';
import 'package:emenu_admin/shareWidget/domain.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetLoginCredential extends StatefulWidget {
  final Merchant merchant;
  final Function() callBack;

  ResetLoginCredential({required this.merchant, required this.callBack});

  @override
  _ResetLoginCredentialState createState() => _ResetLoginCredentialState();
}

class _ResetLoginCredentialState extends State<ResetLoginCredential> {
  var password = TextEditingController();
  var email = TextEditingController();
  bool updateSuccess = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    password.text = 'emenu666';
    email.text = widget.merchant.email!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        insetPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        title: new Text('Reset Password'),
        content: Container(height: 500, width: 500, child: mainContent()),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
            ),
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Reset'),
            onPressed: () {
              checkingInput();
            },
          ),
        ],
      ),
    );
  }

  Widget mainContent() {
    return Container(
      child: !updateSuccess
          ? Column(
              children: [
                TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    textAlign: TextAlign.start,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline),
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      hintText: 'channelsoftmy@gmail.com',
                      border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    keyboardType: TextInputType.text,
                    controller: password,
                    textAlign: TextAlign.start,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.price_change),
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
                    )),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLoginInfo(),
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: getLoginInfo()));
                        showSnackBar('Copy Successfully');
                      },
                      icon: Icon(Icons.copy),
                      label: Text('Copy Access')),
                )
              ],
            ),
    );
  }

  getLoginInfo() {
    return 'Login Detail'
        '\nEmail: ${email.text}'
        '\nPassword: ${password.text}'
        '\n\n\nAndroid App'
        '\nhttps://emenu.com.my/googleplay'
        '\n\nIOS'
        '\nhttps://emenu.com.my/appstore'
        '\n\nWeb'
        '\nhttps://cp.emenu.com.my/v2';
  }

  checkingInput() {
    if (email.text.isEmpty || password.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "All Field Above is Required!",
      );
      return;
    }
    resetLoginCredentials();
  }

  resetLoginCredentials() async {
    Map data = await Domain().resetLoginCredentials(password.text, email.text, widget.merchant.merchantId.toString());
    setState(() {
      if (data['status'] == '1') {
        Fluttertoast.showToast(
          msg: "Update Successfully!",
        );

        setState(() {
          updateSuccess = true;
        });
      } else if (data['status'] == '3') {
        Fluttertoast.showToast(
          msg: "Email is existed!",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Something Went Wrong!",
        );
      }
    });
  }

  void showSnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

