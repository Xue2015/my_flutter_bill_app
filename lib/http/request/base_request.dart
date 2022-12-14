import 'package:flutter_bill_app/http/dao/login_dao.dart';
import 'package:flutter_bill_app/util/hi_constants.dart';

enum HttpMethod { GET, POST, DELETE }

/// base request class
abstract class BaseRequest {
  var pathParams;
  var useHttps = true;

  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    var pathStr = path();

    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}${pathParams}";
      } else {
        pathStr = "${path()}/${pathParams}";
      }
    }

    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }

    if(needLogin()) {
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }

    print(uri.toString());

    return uri.toString();
  }
  bool needLogin();

  Map<String, String> params = Map();

  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
    HiConstants.courseFlagK : HiConstants.courseFlagV,
    HiConstants.authTokenK : HiConstants.authTokenV,
    "boarding-pass":""
  };

  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
