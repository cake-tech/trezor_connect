import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:trezor_connect/trezor_connect.dart';

class SolanaExample extends StatefulWidget {
  const SolanaExample({required this.trezorConnect, super.key});

  final TrezorConnect trezorConnect;

  @override
  State<StatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends State<SolanaExample> {
  String? response;

  Future<void> getAddress() async {
    final res = await widget.trezorConnect.solanaGetAddress("m/44'/501'/0'/0'");

    developer.log("${res?.address}, ${res?.serializedPath}, ${res?.path}");
    if (res != null) {
      setState(() => response = res.address);
    }
  }

  Future<void> get10Address() async {
    final res = await widget.trezorConnect.solanaGetAddressBundle([
      TrezorGetAddressParams(path: "m/44'/501'/0'"),
      TrezorGetAddressParams(path: "m/44'/501'/1'"),
      TrezorGetAddressParams(path: "m/44'/501'/2'"),
    ]);

    developer.log("$res");
    if (res != null) {
      setState(() => response = "${res.length}\n$res");
    }
  }

  Future<void> signTransaction() async {
    final res = await widget.trezorConnect.ethereumSignTransaction(
      "m/44'/60'/0'/0/0",
      transaction: TrezorEthereumTransaction(
        to: '0x7314e0f1c0e28474bdb6be3e2c3e0453255188f8',
        value: '0xf4240',
        data: '0x01',
        chainId: 1,
        nonce: '0x0',
        gasLimit: '0x5208',
        gasPrice: '0xbebc200',
      ),
    );

    developer.log("v: ${res?.v}, r: ${res?.r}, s: ${res?.s}");
    if (res != null) {
      setState(() => response = "v: ${res.v}, r: ${res.r}, s: ${res.s}");
    }
  }

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: const Text('Solana'),
    children: <Widget>[
      Offstage(offstage: response == null, child: Text(response ?? '')),
      TextButton(onPressed: getAddress, child: Text("Get Address")),
      TextButton(onPressed: get10Address, child: Text("Get 10 Addresses")),
      TextButton(
        onPressed: signTransaction,
        child: Text("Sign example Transaction"),
      ),
    ],
  );
}
