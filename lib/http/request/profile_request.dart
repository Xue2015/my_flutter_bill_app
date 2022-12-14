import 'package:flutter_bill_app/http/request/base_request.dart';

class ProfileRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return 'uapi/fa/profile';
  }

}