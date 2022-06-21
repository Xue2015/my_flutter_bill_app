// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/dao/login_dao.dart';
import 'package:flutter_bill_app/util/string_util.dart';
import 'package:flutter_bill_app/widget/appbar.dart';
import 'package:flutter_bill_app/widget/login_effect.dart';
import 'package:flutter_bill_app/widget/login_ipnut.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpTOLogin;

  const RegistrationPage({Key? key, required this.onJumpTOLogin})
      : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName;
  String password;
  String rePassword;
  String imoocId;
  String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", widget.onJumpTOLogin),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(
              protect: protect,
            ),
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              title: "密码",
              hint: "请输入密码",
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              title: "确认密码",
              hint: "请再次输入密码",
              obscureText: true,
              lineStretch: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              title: "慕课网ID",
              hint: "请输入你的慕课网用户ID",
              keboardType: TextInputType.number,
              onChanged: (text) {
                imoocId = text;
                checkInput();
              },
            ),
            LoginInput(
              title: "课程订单号",
              hint: "请输入课程订单号后四位",
              lineStretch: true,
              keboardType: TextInputType.number,
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20, left: 20, right: 20)
            ,child: _loginButton(),),

          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) &&
    isNotEmpty(password) &&
    isNotEmpty(rePassword) &&
    isNotEmpty(imoocId) &&
    isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }

    this.setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return InkWell(child: Text('注册'), onTap: () {
      if (loginEnable) {
        // send()
        if (loginEnable) {
          checkParams()
        }
      } else {
        print('login enable is false');
      }

    },);
  }

  void send() async  {
    try {
      var result = await LoginDao.registration(userName, password, imoocId, orderId);
      print(result);
      if (result['code'] == 0) {
        print('注册成功');
        if (widget.onJumpTOLogin != null) {
          widget.onJumpTOLogin();
        }
      } else {
        print(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips= '两次密码不一致';
    } else if (orderId.length !=4) {
      tips = '请输入订单号的后四位';
    }

    if (tips != null) {
      print(tips);
      return;
    }

    send();
  }
}
