import 'dart:io';

import 'package:emenu_admin/object/user.dart';
import 'package:emenu_admin/shareWidget/domain.dart';
import 'package:emenu_admin/shareWidget/sharePreference.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginPage> {
  String _platformVersion = 'Default';

  //clear message purpose
  var email = TextEditingController();
  var password = TextEditingController();
  bool hidePassword = true;

  @override
  initState() {
    super.initState();
    getVersionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (BuildContext innerContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Image.asset('drawable/emenu-logo-text.jpg', height: 230),
                  SizedBox(height: 20.0),
                  customTextField(email, 'Email', null),
                  SizedBox(height: 20.0),
                  customTextField(password, 'Password', hidePassword),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        login(innerContext);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('drawable/logo.jpg', height: 50),
              Text(
                'All Right Reserved By CHANNEL SOFT PLT',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Text(
                'Version $_platformVersion',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
    );
  }

  // Toggles the password show status
  void showPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void getVersionNumber() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        setState(() {
          _platformVersion = version;
        });
      }
    } catch ($e) {
      _platformVersion = 'Latest';
    }
  }

  void login(context) async {
    if (email.text.length > 0 && password.text.length > 0) {
      Map data = await Domain().login(email.text, password.text);
      print(data);
      if (data['status'] == '1') {
        //user information
        storeUser(data['user_detail']);
        showSnackBar(context, 'Login Successfully!');
      } else
        showSnackBar(context, 'Invalid Account!');
    } else {
      showSnackBar(context, 'All Fields Above Is Required!');
    }
  }

  storeUser(data) async {
    try {
      await SharePreferences().save('dealer', Dealer(dealerId: data['dealer_id'].toString(), name: data['name'], email: data['email']));
      Navigator.pushReplacementNamed(context, '/');
    } on Exception catch (e) {
      print('Error!! $e');
    }
  }

  void showSnackBar(context, text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextField customTextField(controller, String hint, hidePassword) {
    return TextField(
      controller: controller,
      obscureText: hint == 'Password' ? hidePassword : false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        enabledBorder: new OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300] ?? Colors.black),
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        suffixIcon: IconButton(
            icon: hint == 'Password' ? Icon(Icons.remove_red_eye) : Icon(Icons.clear),
            onPressed: () => hint == 'Password' ? showPassword() : controller.clear()),
        prefixIcon: Icon(hint == 'Password' ? Icons.lock : Icons.email),
      ),
    );
  }
}
