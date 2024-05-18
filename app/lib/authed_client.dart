import 'dart:io';
import 'package:http/http.dart' as http;

class AuthedClientInner extends http.BaseClient {
  final String _secret;
  final http.Client _inner;

  AuthedClientInner(this._secret, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['X-ZT1-Auth'] = _secret;
    return _inner.send(request);
  }

  // @override
  // Future<http.Response> post(Uri url,
  //     {Map<String, String>? headers, Object? body, Encoding? encoding}) {
  //   Map<String, String> hd = headers ?? <String, String>{};
  //   hd['content-type'] = 'application/json';
  //   return super.post(url, headers: hd, body: body, encoding: encoding);
  // }
}

class AuthedClient {
  late Future<AuthedClientInner> client;
  Future<AuthedClientInner> loadSecret() async {
    final results = await Process.run(
        'su', ['-c', 'cat', '/data/adb/zerotier/home/authtoken.secret']);
    return AuthedClientInner(results.stdout.toString().trim(), http.Client());
  }

  AuthedClient() {
    client = loadSecret();
  }
}
