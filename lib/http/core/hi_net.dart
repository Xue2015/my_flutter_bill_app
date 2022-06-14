import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bill_app/http/core/mock_adapter.dart';
import 'package:flutter_bill_app/http/request/base_request.dart';

class HiNet {
  //singleton
  HiNet._();

  static HiNet? _instance;

  static HiNet? getInstance() {
    _instance ??= HiNet._();
    return _instance;
  }

  Future fire(BaseRequest request) async {
    //TODO
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }
    var result = response!.data;
    printLog(result);

    var status = response.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status!, result.toString(), data: result);
    }
    return result;
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url: ${request.url()}');
    HiNetAdapter adapter = MockAdapter();
    return adapter.send<T>(request);
  }

  void printLog(log) {
    print('hi_net: ${log.toString()}');
  }
}
