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

class TrezorEthereumTransaction {
  final String to;
  final String value;
  final String? gasPrice;
  final String gasLimit;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;
  final String nonce;
  final String? data;
  final int chainId;
  final int? txType;

  const TrezorEthereumTransaction({
    required this.to,
    required this.value,
    required this.gasLimit,
    required this.nonce,
    required this.chainId,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.data,
    this.txType,
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

class TrezorTxInput {
  /// previous transaction hash (reversed)
  final String prevHash;

  /// previous transaction index
  final int prevIndex;

  final int amount;
  final int? sequence;

  final String? origHash; // RBF
  final int? origIndex; // RBF

  /// required if script_type=EXTERNAL
  final String? scriptPubkey;

  /// bit field of coinjoin-specific flags
  final int? coinjoinFlags;

  /// used by EXTERNAL, depending on script_pubkey
  final String? scriptSig;

  /// used by EXTERNAL, depending on script_pubkey
  final String? witness;

  /// used by EXTERNAL, depending on script_pubkey
  final String? ownershipProof;

  /// used by EXTERNAL, depending on ownership_proof
  final String? commitmentData;

  final List<int> addressPath;

  /// SPENDADDRESS, SPENDMULTISIG, SPENDWITNESS, SPENDP2SHWITNESS, SPENDTAPROOT
  final String? scriptType;

  const TrezorTxInput({
    required this.prevHash,
    required this.prevIndex,
    required this.amount,
    this.sequence,
    this.origHash,
    this.origIndex,
    this.scriptPubkey,
    this.coinjoinFlags,
    this.scriptSig,
    this.witness,
    this.ownershipProof,
    this.commitmentData,
    required this.addressPath,
    this.scriptType,
  });

  Map<String, dynamic> toParams() => {
    "prev_hash": prevHash,
    "prev_index": prevIndex,
    "amount": amount,
    if (sequence != null) "sequence": sequence,
    if (origHash != null) "orig_hash": origHash,
    if (origIndex != null) "orig_index": origIndex,
    if (scriptPubkey != null) "script_pubkey": scriptPubkey,
    if (coinjoinFlags != null) "coinjoin_flags": coinjoinFlags,
    if (scriptSig != null) "script_sig": scriptSig,
    if (witness != null) "witness": witness,
    if (ownershipProof != null) "ownership_proof": ownershipProof,
    if (commitmentData != null) "commitment_data": commitmentData,
    "address_n": addressPath,
    if (scriptType != null) "script_type": scriptType,
  };
}

class TrezorTxOutput {
  final String? address;
  final List<int>? addressPath;
  final int amount;
  final String? scriptType;
  final String? origHash; // RBF
  final int? origIndex; // RBF

  const TrezorTxOutput({
    this.address,
    this.addressPath,
    required this.amount,
    this.scriptType,
    this.origHash,
    this.origIndex,
  });

  Map<String, dynamic> toParams() => {
    if (address != null) "address": address,
    if (addressPath != null) "address_n": addressPath,
    "amount": amount,
    if (scriptType != null) "script_type": scriptType,
    if (origHash != null) "orig_hash": origHash,
    if (origIndex != null) "orig_index": origIndex,
  };
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

class TrezorEthereumSignedTx {
  /// hexadecimal string with "0x" prefix
  final String v;

  /// hexadecimal string with "0x" prefix
  final String r;

  /// hexadecimal string with "0x" prefix
  final String s;

  const TrezorEthereumSignedTx._({
    required this.v,
    required this.r,
    required this.s,
  });

  static TrezorEthereumSignedTx fromJson(Map<String, dynamic> payload) =>
      TrezorEthereumSignedTx._(
        v: payload['v'],
        r: payload['r'],
        s: payload['s'],
      );
}

class TrezorSignedTransaction {
  /// Array of signer signatures
  final List<String> signatures;

  /// serialized transaction
  final String serializedTx;

  /// broadcasted transaction id
  final String? txid;

  const TrezorSignedTransaction._({
    required this.signatures,
    required this.serializedTx,
    required this.txid,
  });

  static TrezorSignedTransaction fromJson(Map<String, dynamic> payload) =>
      TrezorSignedTransaction._(
        signatures: List<String>.from(payload['signatures'] as List),
        serializedTx: payload['serializedTx'],
        txid: payload['txid'],
      );
}
