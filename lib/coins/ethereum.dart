import 'dart:async';
import 'dart:convert';

import 'package:trezor_connect/trezor_connect.dart';

import '../models.dart';

extension TrezorConnectEthereum on TrezorConnect {
  // ToDo(Konsti): ethereumSignTransaction
  // ToDo(Konsti): ethereumSignTypedData

  /// Display requested address derived by given BIP32 path on device and returns it to caller. User is presented with a description of the requested key and asked to confirm the export on Trezor.
  ///
  /// [path] minimum length is 5.
  /// [address] (Optional) address for validation
  /// [showOnTrezor] (Optional) determines if address will be displayed on device. Default is set to true
  /// [chunkify] (Optional) determines if address will be displayed in chunks of 4 characters. Default is set to false
  Future<TrezorAddress?> ethereumGetAddress(
    String path, {
    String? address,
    bool showOnTrezor = true,
    bool chunkify = false,
  }) {
    final completer = Completer<TrezorAddress>();

    launchDeeplink(
      method: "ethereumGetAddress",
      params: {
        'path': path,
        if (address != null) 'address': address,
        'showOnTrezor': showOnTrezor,
        'chunkify': chunkify,
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

  /// Display requested public key derived by given BIP44 path on device and returns it to caller. User is presented with a description of the requested public key and asked to confirm the export.
  ///
  /// [path] minimum length is 5.
  /// [showOnTrezor] (Optional) determines if address will be displayed on device. Default is set to true
  /// [suppressBackupWarning] (Optional) By default, this method will emit an event to show a warning if the wallet does not have a backup. This option suppresses the message.
  /// [chunkify] (Optional) determines if address will be displayed in chunks of 4 characters. Default is set to false
  Future<TrezorAddressPublicKey?> ethereumGetPublicKey(
    String path, {
    bool? suppressBackupWarning,
    bool showOnTrezor = true,
    bool chunkify = false,
  }) {
    final completer = Completer<TrezorAddressPublicKey>();

    launchDeeplink(
      method: "ethereumGetPublicKey",
      params: {
        'path': path,
        if (suppressBackupWarning != null)
          'suppressBackupWarning': suppressBackupWarning,
        'showOnTrezor': showOnTrezor,
        'chunkify': chunkify,
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

  /// Asks device to sign a message using the private key derived by given BIP32 path.
  ///
  /// [path] minimum length is 3.
  /// [message] message to sign in plain text
  /// [hex] (Optional) convert message from hex
  Future<TrezorMessageSignature?> ethereumSignMessage(
    String path, {
    required String message,
    bool? hex,
  }) {
    final completer = Completer<TrezorMessageSignature>();

    launchDeeplink(
      method: "ethereumSignMessage",
      params: {'path': path, 'message': message, if (hex != null) 'hex': hex},
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
