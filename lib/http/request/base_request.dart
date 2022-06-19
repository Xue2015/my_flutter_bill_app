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
    'course-flag' : "fa",
    "auth-token" : "MjAyMC0wNi0yMyAwMzoyNTowMQ==fa",
    "boarding-pass":""
  };

  BaseRequest addHeader(String k, Object v) {
    params[k] = v.toString();
    return this;
  }
}
