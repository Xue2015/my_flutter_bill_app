import 'package:flutter_bill_app/http/request/base_request.dart';

class TestRequest extends BaseRequest {

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return "uapi/test/test";
  }
}