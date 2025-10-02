import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:trezor_connect/trezor_connect.dart';

extension TrezorConnectBitcoin on TrezorConnect {
  // ToDo (Konsti): signTransaction

  /// [path] in BIP44 path scheme or Array of hardened numbers. minimum length is 5.
  /// [address] for validation
  /// [showOnTrezor] determines if address will be displayed on device. Default is set to true
  /// [chunkify] determines if address will be displayed in chunks of 4 characters. Default is set to false
  /// [coin] determines network definition specified in coins.json file. Coin shortcut, name or label can be used. If coin is not set API will try to get network definition from path.
  /// [scriptType] "SPENDADDRESS" | "SPENDMULTISIG" | "SPENDWITNESS" | "SPENDP2SHWITNESS" | "SPENDTAPROOT" used to distinguish between various address formats (non-segwit, segwit, etc.).
  Future<TrezorAddress?> getAddress(
    String path, {
    String? address,
    bool showOnTrezor = true,
    bool chunkify = false,
    String? coin,
    String? scriptType,
  }) {
    final completer = Completer<TrezorAddress>();

    launchDeeplink(
      method: "getAddress",
      params: {
        'path': path,
        if (address != null) 'address': address,
        'showOnTrezor': showOnTrezor,
        'chunkify': chunkify,
        if (coin != null) 'coin': coin,
        if (scriptType != null) 'scriptType': scriptType,
      },
      callback: (Uri uri) {
        Map<String, dynamic> response = jsonDecode(
          uri.queryParameters["response"]!,
        );

        completer.complete(TrezorAddress.fromJson(response["payload"]));
      },
    );

    return completer.future;
  }

  /// [path] minimum length is 1.
  /// [address] for validation
  /// [showOnTrezor] determines if address will be displayed on device. Default is set to false
  /// [suppressBackupWarning] By default, this method will emit an event to show a warning if the wallet does not have a backup. This option suppresses the message.
  /// [chunkify] determines if address will be displayed in chunks of 4 characters. Default is set to false
  /// [coin] determines network definition specified in coins.json file. Coin shortcut, name or label can be used. If coin is not set API will try to get network definition from path.
  /// [scriptType] "SPENDADDRESS" | "SPENDMULTISIG" | "SPENDWITNESS" | "SPENDP2SHWITNESS" | "SPENDTAPROOT" used to distinguish between various address formats (non-segwit, segwit, etc.).
  /// [ignoreXpubMagic] ignore SLIP-0132 XPUB magic, use xpub/tpub prefix for all account types.
  Future<TrezorAddressPublicKey?> getPublicKey(
    String path, {
    bool showOnTrezor = true,
    bool chunkify = false,
    bool suppressBackupWarning = false,
    String? coin,
    String? scriptType,
    bool? ignoreXpubMagic,
  }) {
    final completer = Completer<TrezorAddressPublicKey>();

    launchDeeplink(
      method: "getPublicKey",
      params: {
        'path': path,
        'showOnTrezor': showOnTrezor,
        'chunkify': chunkify,
        if (coin != null) 'coin': coin,
        if (scriptType != null) 'scriptType': scriptType,
        if (ignoreXpubMagic != null) 'ignoreXpubMagic': ignoreXpubMagic,
      },
      callback: (Uri uri) {
        Map<String, dynamic> response = jsonDecode(
          uri.queryParameters["response"]!,
        );
        completer.complete(
          TrezorAddressPublicKey.fromJson(response["payload"]),
        );
      },
    );

    return completer.future;
  }

  Future<List<TrezorAddressPublicKey>?> getPublicKeyBundle(
    List<TrezorGetPublicKeyParams> params,
  ) {
    final completer = Completer<List<TrezorAddressPublicKey>>();

    final paramsList = <Map<String, dynamic>>[];

    for (final param in params) {
      paramsList.add({
        'path': param.path,
        'showOnTrezor': param.showOnTrezor,
        'chunkify': param.chunkify,
        if (param.coin != null) 'coin': param.coin,
        if (param.scriptType != null) 'scriptType': param.scriptType,
        if (param.ignoreXpubMagic != null)
          'ignoreXpubMagic': param.ignoreXpubMagic,
      });
    }

    launchDeeplink(
      method: "getPublicKey",
      params: {'bundle': paramsList},
      callback: (Uri uri) {
        Map<String, dynamic> response = jsonDecode(
          uri.queryParameters["response"]!,
        );

        final responseBundle = response["payload"] as List;
        final responseList = <TrezorAddressPublicKey>[];

        for (final response in responseBundle) {
          responseList.add(TrezorAddressPublicKey.fromJson(response));
        }

        completer.complete(responseList);
      },
    );

    return completer.future;
  }

  /// [path] in BIP44 path scheme or Array of hardened numbers. minimum length is 5.
  /// [coin] determines network definition specified in coins.json file. Coin shortcut, name or label can be used. If coin is not set API will try to get network definition from path.
  Future<TrezorMessageSignature?> signMessage(
    String path, {
    required String message,
    String? coin,
    bool? hex,
  }) {
    final completer = Completer<TrezorMessageSignature>();
    launchDeeplink(
      method: "signMessage",
      params: {
        'path': path,
        'message': message,
        if (coin != null) 'coin': coin,
        if (hex != null) 'hex': hex,
      },
      callback: (Uri uri) {
        Map<String, dynamic> response = jsonDecode(
          uri.queryParameters["response"]!,
        );

        completer.complete(
          TrezorMessageSignature.fromJson(response["payload"]),
        );
      },
    );

    return completer.future;
  }
}
