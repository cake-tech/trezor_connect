import 'dart:async';

import 'package:trezor_connect/trezor_connect.dart';

extension TrezorConnectSolana on TrezorConnect {
  /// Display requested address derived by given BIP44 path on device and return it to the caller.
  /// User is presented with a description of the requested address and asked to confirm the export on Trezor.
  ///
  /// [path] minimum length is 2.
  /// [address] (Optional) address for validation
  /// [showOnTrezor] (Optional) determines if address will be displayed on device. Default is set to true
  /// [chunkify] (Optional) determines if address will be displayed in chunks of 4 characters. Default is set to false
  Future<TrezorAddress?> solanaGetAddress(
    String path, {
    String? address,
    bool showOnTrezor = true,
    bool chunkify = false,
  }) {
    final completer = Completer<TrezorAddress>();

    launchDeeplink(
      method: "solanaGetAddress",
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

  Future<List<TrezorAddress>?> solanaGetAddressBundle(
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
      method: "solanaGetAddress",
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

  /// Display requested public key derived by given BIP44 path on device and return it to the caller.
  /// User is presented with a description of the requested public key and asked to confirm the export on Trezor.
  ///
  /// [path] minimum length is 2.
  /// [showOnTrezor] (Optional) determines if address will be displayed on device. Default is set to true
  /// [suppressBackupWarning] (Optional) By default, this method will emit an event to show a warning if the wallet does not have a backup. This option suppresses the message.
  /// [chunkify] (Optional) determines if address will be displayed in chunks of 4 characters. Default is set to false
  Future<TrezorAddressPublicKey?> solanaGetPublicKey(
    String path, {
    bool? suppressBackupWarning,
    bool showOnTrezor = true,
    bool chunkify = false,
  }) {
    final completer = Completer<TrezorAddressPublicKey>();

    launchDeeplink(
      method: "solanaGetPublicKey",
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

  /// Asks device to sign given transaction. User is asked to confirm all transaction details on Trezor.
  ///
  /// [path] minimum length is 2.
  /// [serialize] If true, the transaction will be deserialized before signing and serialized back after signing. Without this option, the method will only return the signature by itself.
  Future<TrezorEthereumSignedTx?> solanaSignTransaction(
    String path, {
    required String serializedTx,
    List<TrezorSolanaTxAdditionalInfo>? tokenAccountsInfos,
    bool? serialize,
  }) {
    final completer = Completer<TrezorEthereumSignedTx>();

    launchDeeplink(
      method: "solanaSignTransaction",
      params: {
        'path': path,
        'serializedTx': serializedTx,
        if (tokenAccountsInfos != null)
          'additionalInfo': {
            'tokenAccountsInfos': tokenAccountsInfos.map(
              (info) => {
                'baseAddress': info.baseAddress,
                'tokenProgram': info.tokenProgram,
                'tokenMint': info.tokenMint,
                'tokenAccount': info.tokenAccount,
                if (info.symbol != null) 'symbol': info.symbol,
                if (info.isDevnet != null) 'isDevnet': info.isDevnet,
              },
            ),
          },
        if (serialize != null) 'serialize': serialize,
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

class TrezorSolanaTxAdditionalInfo {
  final String baseAddress;
  final String tokenProgram;
  final String tokenMint;
  final String tokenAccount;
  final String? symbol;
  final bool? isDevnet;

  const TrezorSolanaTxAdditionalInfo({
    required this.baseAddress,
    required this.tokenProgram,
    required this.tokenMint,
    required this.tokenAccount,
    this.symbol,
    this.isDevnet,
  });
}
