import 'package:flutter_bill_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bill_app/http/request/base_request.dart';

// class MockAdapter extends HiNetAdapter {
//   @override
//   Future<HiNetResponse<T>> send<T>(BaseRequest request) {
//     return Future<HiNetResponse<T>>.delayed(Duration(milliseconds:1000), () {
//       return HiNetResponse(data: {"code" : 0, "message" : "success"}, statusCode: 200);
//     });
//   }
// }

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future<HiNetResponse<T>>.delayed(const Duration(milliseconds: 1000),
        () {
      return HiNetResponse(
          data: {"code": 0, "message": 'success'} as T, statusCode: 401);
    });
  }
}
