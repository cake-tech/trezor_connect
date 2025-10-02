class TrezorGetAddressParams {
  final String path;
  final bool showOnTrezor;
  final bool chunkify;
  final String? address;
  final String? coin;
  final String? scriptType;

  const TrezorGetAddressParams({
    required this.path,
    this.showOnTrezor = true,
    this.chunkify = false,
    this.address,
    this.coin,
    this.scriptType,
  });
}

class TrezorGetPublicKeyParams {
  final String path;
  final bool showOnTrezor;
  final bool chunkify;
  final String? address;
  final String? coin;
  final String? scriptType;
  final bool suppressBackupWarning;
  final bool? ignoreXpubMagic;

  const TrezorGetPublicKeyParams({
    required this.path,
    this.showOnTrezor = true,
    this.chunkify = false,
    this.suppressBackupWarning = false,
    this.address,
    this.coin,
    this.scriptType,
    this.ignoreXpubMagic,
  });
}

class TrezorAddress {
  final String address;
  final List<int> path;
  final String serializedPath;

  const TrezorAddress._(this.address, this.path, this.serializedPath);

  static TrezorAddress fromJson(Map<String, dynamic> payload) =>
      TrezorAddress._(
        payload["address"],
        List<int>.from(payload['path'] as List),
        payload["serializedPath"],
      );
}

/// [xpub] in legacy format
/// [xpubSegwit] optional for segwit accounts: xpub in segwit format
/// [chainCode] in BIP-32 serialization format
/// [childNum] in BIP-32 serialization format
/// [publicKey] in BIP-32 serialization format
/// [fingerprint] in BIP-32 serialization format
/// [depth] in BIP-32 serialization format
/// [descriptor] in BIP-380 descriptor. Not available for model One
class TrezorAddressPublicKey {
  final List<int> path;
  final String serializedPath;
  final String xpub;
  final String? xpubSegwit;
  final String chainCode;
  final int childNum;
  final String publicKey;
  final int fingerprint;
  final int depth;
  final String? descriptor;

  const TrezorAddressPublicKey._({
    required this.path,
    required this.serializedPath,
    required this.xpub,
    required this.xpubSegwit,
    required this.chainCode,
    required this.childNum,
    required this.publicKey,
    required this.fingerprint,
    required this.depth,
    required this.descriptor,
  });

  static TrezorAddressPublicKey fromJson(Map<String, dynamic> payload) =>
      TrezorAddressPublicKey._(
        path: List<int>.from(payload['path'] as List),
        serializedPath: payload["serializedPath"],
        xpub: payload["xpub"],
        xpubSegwit: payload["xpubSegwit"],
        chainCode: payload["chainCode"],
        childNum: payload["childNum"],
        publicKey: payload["publicKey"],
        fingerprint: payload["fingerprint"],
        depth: payload["depth"],
        descriptor: payload["descriptor"],
      );
}

class TrezorMessageSignature {
  /// [signer] address
  final String address;

  /// [signature] in base64 format
  final String signature;

  const TrezorMessageSignature._({
    required this.address,
    required this.signature,
  });

  static TrezorMessageSignature fromJson(Map<String, dynamic> payload) =>
      TrezorMessageSignature._(
        address: payload['address'],
        signature: payload['signature'],
      );
}
