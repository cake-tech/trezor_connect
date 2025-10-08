import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:trezor_connect/trezor_connect.dart';

class BitcoinExample extends StatefulWidget {
  const BitcoinExample({required this.trezorConnect, super.key});

  final TrezorConnect trezorConnect;

  @override
  State<StatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends State<BitcoinExample> {
  String? response;

  Future<void> getAddress() async {
    final res = await widget.trezorConnect.getAddress(
      "m/84'/0'/0'/0/0",
      coin: "btc",
    );

    developer.log("${res?.address}, ${res?.serializedPath}, ${res?.path}");
    if (res != null) {
      setState(() => response = res.address);
    }
  }

  Future<void> getPublicKey() async {
    final res = await widget.trezorConnect.getPublicKey("m/84'/0'");

    developer.log(
      "${res?.xpub}, ${res?.xpubSegwit}, ${res?.serializedPath}, ${res?.path}",
    );
    if (res != null) {
      setState(() => response = res.xpub);
    }
  }

  Future<void> signMessage() async {
    final res = await widget.trezorConnect.signMessage(
      "m/84'/0'/0'/0/0",
      message: "Hey Trezor!",
    );

    developer.log("${res?.address}, ${res?.signature}");
    if (res != null) {
      setState(() => response = res.signature);
    }
  }

  Future<void> signTransaction() async {
    final res = await widget.trezorConnect.signTransaction(
      coin: "btc",
      inputs: [
        TrezorTxInput(
          addressPath: [
            (44 | 0x80000000) >>> 0,
            (0 | 0x80000000) >>> 0,
            (2 | 0x80000000) >>> 0,
            1,
            0,
          ],
          prevIndex: 0,
          prevHash:
              'b035d89d4543ce5713c553d69431698116a822c57c03ddacf3f04b763d1999ac',
          amount: 3431747,
        ),
      ],
      outputs: [
        TrezorTxOutput(
          addressPath: [
            (44 | 0x80000000) >>> 0,
            (0 | 0x80000000) >>> 0,
            (2 | 0x80000000) >>> 0,
            1,
            1,
          ],
          amount: 3181747,
          scriptType: 'PAYTOADDRESS',
        ),
        TrezorTxOutput(
          address: '18WL2iZKmpDYWk1oFavJapdLALxwSjcSk2',
          amount: 200000,
          scriptType: 'PAYTOADDRESS',
        ),
      ],
    );

    developer.log("${res?.serializedTx}, ${res?.txid}");
    if (res != null) {
      setState(() => response = res.txid);
    }
  }

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: const Text('Bitcoin'),
    children: <Widget>[
      Offstage(offstage: response == null, child: Text(response ?? '')),
      TextButton(onPressed: getAddress, child: Text("Get Address")),
      TextButton(onPressed: getPublicKey, child: Text("Get Public Key")),
      TextButton(
        onPressed: signMessage,
        child: Text("Sign message \"Hey Trezor!\""),
      ),
      TextButton(onPressed: signTransaction, child: Text("Sign Transaction")),
    ],
  );
}
