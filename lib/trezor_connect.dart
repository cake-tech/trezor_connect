import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

export 'coins/bitcoin.dart';
export 'coins/ethereum.dart';
export 'coins/solana.dart';
export 'models.dart';

class TrezorConnect {
  TrezorConnectEnvironment environment;
  String callbackBackUri;
  String? appName;
  String? appIcon;

  TrezorConnect(
    this.callbackBackUri, {
    this.appName,
    this.appIcon,
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

    return launchUrl(Uri.parse(deeplink), mode: LaunchMode.externalApplication);
  }

  String getDeeplink(
    String method,
    Map<String, dynamic> params,
    String callback,
  ) {
    final paramsEncoded = Uri.encodeQueryComponent(jsonEncode(params));
    final callbackEncoded = Uri.encodeQueryComponent(callback);

    String suffix = "";
    if (appName != null) {
      suffix += "&appName=${Uri.encodeQueryComponent(appName!)}";
    }
    if (appIcon != null) {
      suffix += "&appIcon=${Uri.encodeQueryComponent(appIcon!)}";
    }

    return "$rootUrl?method=$method&params=$paramsEncoded&callback=$callbackEncoded$suffix";
  }

  String registerCallback(TrezorCallback callback) {
    final id = DateTime.timestamp().millisecondsSinceEpoch.toString();
    _callbacks[id] = callback;
    return id;
  }

  void handleCallback(Uri uri) async {
    final id = uri.queryParameters['id'];
    if (id == null) return;

    // Remove the callback regardless of outcome — this id is done.
    // Prevents the _callbacks map from growing unbounded for the app's
    // lifetime.
    final callback = _callbacks.remove(id);
    callback?.call(uri);
  }

  /// Parses a callback URI's `response` query param.
  ///
  /// Returns the payload on success. Throws [TrezorCallbackException] when
  /// Trezor Suite signaled failure (`success: false`) or the response is
  /// missing/malformed. Coin extensions should use this helper instead of
  /// directly accessing `response["payload"]`, so that failures surface as
  /// errors on the awaiting completer rather than hanging it.
  static dynamic parseResponse(Uri uri) {
    final raw = uri.queryParameters['response'];
    if (raw == null) {
      throw TrezorCallbackException(
        error: 'Missing `response` in callback URI',
      );
    }
    late final Map<String, dynamic> response;
    try {
      response = jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      throw TrezorCallbackException(error: 'Malformed response JSON: $e');
    }
    if (response['success'] == false) {
      final payload = response['payload'];
      throw TrezorCallbackException(
        error: payload is Map ? payload['error'] as String? : null,
        code: payload is Map ? payload['code'] as String? : null,
      );
    }
    return response['payload'];
  }
}

enum TrezorConnectEnvironment { production, development, local }

typedef TrezorCallback = void Function(Uri);

/// Thrown when a Trezor Suite callback indicates failure
/// (`success: false` in the response) or when the response is missing/
/// malformed.
class TrezorCallbackException implements Exception {
  /// Error string from Trezor Suite's payload (e.g.
  /// "Failure_ActionCancelled", "Failure_DataError", "Permissions not granted").
  final String? error;

  /// Optional error code from Trezor Suite's payload.
  final String? code;

  TrezorCallbackException({this.error, this.code});

  @override
  String toString() => 'TrezorCallbackException(code: $code, error: $error)';
}
