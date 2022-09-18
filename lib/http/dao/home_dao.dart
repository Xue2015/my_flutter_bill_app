import 'package:flutter_bill_app/http/core/hi_net.dart';
import 'package:flutter_bill_app/http/request/home_request.dart';
import 'package:flutter_bill_app/model/home_mo.dart';

class HomeDao {
  static get(String categoryName, {int pageIndex = 1, int pageSize = 1}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);

    var result = await HiNet.getInstance()!.fire(request);
    print(result);

    return HomeMo.fromJson(result['data']);
  }
}