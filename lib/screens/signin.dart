import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mac24888food/model/user_model.dart';
import 'package:mac24888food/screens/main_rider.dart';
import 'package:mac24888food/screens/main_shop.dart';
import 'package:mac24888food/screens/main_user.dart';
import 'package:mac24888food/utility/my_style.dart';
import 'package:mac24888food/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Field
  String user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          colors: <Color>[Colors.white, MyStyle().primaryColor],
          center: Alignment(0, -0.3),
          radius: 1.0,
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyStyle().showLogo(),
                MyStyle().mySizebox(),
                MyStyle().shopTitle('Mac Food'),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                passwordForm(),
                MyStyle().mySizebox(),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: MyStyle().darkColor,
          onPressed: () {
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'มีช่องว่าง กรุณากรอกให้ครบ ค่ะ');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        'http://192.168.1.105/UngFood/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String chooseType = userModel.chooseType;
          if (chooseType == 'User') {
            routeTuService(MainUser(), userModel);
          } else if (chooseType == 'Shop') {
            routeTuService(MainShop(), userModel);
          } else if (chooseType == 'Rider') {
            routeTuService(MainRider(), userModel);
          } else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'Password ผิด กรุณาลองใหม่');
        }
      }
    } catch (e) {}
  }

  Future routeTuService(Widget myWidget, UserModel userModel) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id);
    preferences.setString('ChooseType', userModel.chooseType);
    preferences.setString('Name', userModel.name);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelText: 'User :',
            labelStyle: TextStyle(color: MyStyle().darkColor),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelText: 'Password :',
            labelStyle: TextStyle(color: MyStyle().darkColor),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      );
}
