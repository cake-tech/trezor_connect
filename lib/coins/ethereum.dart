import 'dart:async';

import 'package:trezor_connect/trezor_connect.dart';

extension TrezorConnectEthereum on TrezorConnect {
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
        try {
          final payload = TrezorConnect.parseResponse(uri);
          completer.complete(TrezorAddress.fromJson(payload));
        } catch (e) {
          completer.completeError(e);
        }
      },
    );

    return completer.future;
  }

  Future<List<TrezorAddress>?> ethereumGetAddressBundle(
    List<TrezorGetAddressParams> params,
  ) {
    final completer = Completer<List<TrezorAddress>>();

    final paramsList = <Map<String, dynamic>>[];

    for (final param in params) {
      paramsList.add({
        'path': param.path,
        if (param.address != null) 'address': param.address,
        'showOnTrezor': param.showOnTrezor,
        'chunkify': param.chunkify,
      });
    }

    launchDeeplink(
      method: "ethereumGetAddress",
      params: {'bundle': paramsList},
      callback: (Uri uri) {
        try {
          final payload = TrezorConnect.parseResponse(uri);
          final responseBundle = payload as List;
          final responseList = <TrezorAddress>[];

          for (final response in responseBundle) {
            responseList.add(TrezorAddress.fromJson(response));
          }

          completer.complete(responseList);
        } catch (e) {
          completer.completeError(e);
        }
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
        try {
          final payload = TrezorConnect.parseResponse(uri);
          completer.complete(TrezorAddressPublicKey.fromJson(payload));
        } catch (e) {
          completer.completeError(e);
        }
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
        try {
          final payload = TrezorConnect.parseResponse(uri);
          completer.complete(TrezorMessageSignature.fromJson(payload));
        } catch (e) {
          completer.completeError(e);
        }
      },
    );

    return completer.future;
  }

  /// Asks device to sign given transaction using the private key derived by given BIP32 path. User is asked to confirm all transaction details on Trezor.
  ///
  /// [path] minimum length is 3.
  /// [message] message to sign in plain text
  /// [chunkify] (Optional) determines if recipient address will be displayed in chunks of 4 characters. Default is set to false
  Future<TrezorEthereumSignedTx?> ethereumSignTransaction(
    String path, {
    required TrezorEthereumTransaction transaction,
    bool? chunkify,
  }) {
    final completer = Completer<TrezorEthereumSignedTx>();

    launchDeeplink(
      method: "ethereumSignTransaction",
      params: {
        'path': path,
        'transaction': {
          'to': transaction.to,
          'value': transaction.value,
          if (transaction.data != null) 'data': transaction.data,
          'chainId': transaction.chainId,
          'nonce': transaction.nonce,
          'gasLimit': transaction.gasLimit,
          if (transaction.gasPrice != null) 'gasPrice': transaction.gasPrice,
          if (transaction.maxFeePerGas != null)
            'maxFeePerGas': transaction.maxFeePerGas,
          if (transaction.maxPriorityFeePerGas != null)
            'maxPriorityFeePerGas': transaction.maxPriorityFeePerGas,
          if (transaction.txType != null) 'txType': transaction.txType,
        },
        if (chunkify != null) 'chunkify': chunkify,
      },
      callback: (Uri uri) {
        try {
          final payload = TrezorConnect.parseResponse(uri);
          completer.complete(TrezorEthereumSignedTx.fromJson(payload));
        } catch (e) {
          completer.completeError(e);
        }
      },
    );

    return completer.future;
  }
}
