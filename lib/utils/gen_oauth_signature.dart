import 'dart:convert';
import 'dart:math';

import 'package:cirilla/service/constants/endpoints.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class GenOauthSignature {
  final String url;
  final String consumerKey;
  final String consumerKeySecret;
  String requestMethod;

  late Hmac _sigHasher;

  GenOauthSignature({
    required this.consumerKey,
    required this.url,
    required this.consumerKeySecret,
    this.requestMethod = 'GET',
  });

  Map<String, String> generate(Map<String, String> data) {
    int millisecondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;
    int timestamp = (millisecondsSinceEpoch / 1000).round();

    data["oauth_consumer_key"] = consumerKey;
    data["oauth_nonce"] = _randomString(8);
    data["oauth_signature_method"] = "HMAC-SHA1";
    data["oauth_timestamp"] = timestamp.toString();
    data["oauth_token"] = "";
    data["oauth_version"] = "1.0";

    List<int> bytes = utf8.encode("$consumerKeySecret&");

    _sigHasher = Hmac(sha1, bytes);

    // Generate the OAuth signature and add it to our payload.
    data["oauth_signature"] = _generateSignature(requestMethod, Uri.parse(url), data);

    return data;
  }

  String _generateSignature(String requestMethod, Uri url, Map<String, String> data) {
    String sigString = _toQueryString(data);
    String fullSigData = "$requestMethod&${_encode(url.toString())}&${_encode(sigString)}";

    return base64.encode(_hash(fullSigData));
  }

  String _toQueryString(Map<String, String> data) {
    List items = data.keys.map((k) => "$k=${_encode(data[k]!)}").toList();
    items.sort();

    return items.join("&");
  }

  List<int> _hash(String data) => _sigHasher.convert(data.codeUnits).bytes;

  String _encode(String data) => percent.encode(data.codeUnits);

  String _randomString(int length) {
    Random rand = Random();
    List<int> codeUnits = List.generate(length, (index) {
      return rand.nextInt(26) + 97;
    });

    return String.fromCharCodes(codeUnits);
  }
}

/// Check Path URLs allow pass consumer key & secret
bool isAllowPassRestApiKeys(String apiPath) {
  bool allow = false;

  for (String path in Endpoints.allowPathAuthenticationRestApiKeys) {
    if (apiPath.indexOf(path) == 0) {
      allow = true;
      break;
    }
  }

  return allow;
}
