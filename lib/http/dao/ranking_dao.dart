import 'package:flutter_bill_app/http/core/hi_error.dart';
import 'package:flutter_bill_app/http/core/hi_net.dart';
import 'package:flutter_bill_app/http/request/ranking_request.dart';
import 'package:flutter_bill_app/model/ranking_mo.dart';

class RankingDao {
  static get(String sort, {int pageIndex = 1, pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    request
        .add('sort', sort)
        .add('pageIndex', pageIndex)
        .add('pageSize', pageSize);

    var result = await HiNet.getInstance()!.fire(request);
    print(result);
    return RankingMo.fromJson(result['data']);
  }
}
