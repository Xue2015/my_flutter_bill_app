import 'package:flutter/material.dart';
import 'package:flutter_bill_app/navigator/hi_navigator.dart';
import 'package:flutter_bill_app/provider/theme_provider.dart';
import 'package:flutter_bill_app/util/toast.dart';
import 'package:flutter_bill_app/widget/appbar.dart';
import 'package:flutter_bill_app/widget/login_button.dart';
import 'package:flutter_bill_app/widget/login_effect.dart';
import 'package:flutter_bill_app/widget/login_ipnut.dart';
import 'package:provider/provider.dart';

import '../http/core/hi_error.dart';
import '../http/dao/login_dao.dart';
import '../util/string_util.dart';

class LoginPage extends StatefulWidget {
  // final VoidCallback onJumpRegistration;
  // final VoidCallback onSuccess;
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        context.read<ThemeProvider>().setTheme(ThemeMode.dark);
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),

      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect,),
            LoginInput(title: '用户名', hint: '请输入用户名', onChanged: (text) {
              userName = text;
              checkInput();
            },),
            LoginInput(title: '密码', hint: '请输入密码',obscureText: true, onChanged: (text) {
              password = text;
              checkInput();
            },
            focusChanged: (focus) {
              this.setState(() {
                protect = focus;
              });
            },),
            Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 200),
            child: LoginButton("登录", enable: loginEnable, onPressed: send,),)
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
        isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }

    this.setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName!, password!);
      print(result);
      if (result['code'] == 0) {
        print('登录成功');
        showToast('登录成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);

      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
