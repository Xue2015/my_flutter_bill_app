import 'package:flutter_bill_app/http/request/base_request.dart';
import 'package:flutter_bill_app/http/request/favorite_request.dart';

class CancelFavoriteRequest extends FavoriteRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}