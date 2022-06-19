// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bill_app/widget/login_ipnut.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) {
                print(text);
              },
            ),
            LoginInput(
                title: "密码",
                hint: "请输入密码",
                obscureText: true,
                lineStretch: true,
                onChanged: (text) {
                  print(text);
                })
          ],
        ),
      ),
    );
  }
}
