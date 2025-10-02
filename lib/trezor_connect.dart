import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

export 'models.dart';
export 'coins/bitcoin.dart';
export 'coins/ethereum.dart';

class TrezorConnect {
  TrezorConnectEnvironment environment;
  String callbackBackUri;

  TrezorConnect(
    this.callbackBackUri, {
    this.environment = TrezorConnectEnvironment.production,
  });

  final Map<String, TrezorCallback> _callbacks = {};

  String get rootUrl {
    switch (environment) {
      case TrezorConnectEnvironment.production:
        return 'https://connect.trezor.io/9/deeplink/1/';
      case TrezorConnectEnvironment.development:
        return 'https://dev.suite.sldev.cz/connect/develop/deeplink/1/';
      case TrezorConnectEnvironment.local:
        return 'trezorsuitelite://connect/1/';
    }
  }

  Future<bool> launchDeeplink({
    required String method,
    required Map<String, dynamic> params,
    required TrezorCallback callback,
  }) {
    final callbackId = registerCallback(callback);
    final deeplink = getDeeplink(
      method,
      params,
      "$callbackBackUri?id=$callbackId",
    );

    print(deeplink);
    return launchUrl(Uri.parse(deeplink));
  }

  String getDeeplink(
    String method,
    Map<String, dynamic> params,
    String callback,
  ) {
    final paramsEncoded = Uri.encodeQueryComponent(jsonEncode(params));
    final callbackEncoded = Uri.encodeQueryComponent(callback);
    return "$rootUrl?method=$method&params=$paramsEncoded&callback=$callbackEncoded";
  }

  String registerCallback(TrezorCallback callback) {
    final id = DateTime.timestamp().millisecondsSinceEpoch.toString();
    _callbacks[id] = callback;
    return id;
  }

  void handleCallback(Uri uri) async {
    final id = uri.queryParameters['id'];
    if (id == null) return;

    final callback = _callbacks[id];
    callback?.call(uri);
  }
}

enum TrezorConnectEnvironment { production, development, local }

typedef TrezorCallback = void Function(Uri);
