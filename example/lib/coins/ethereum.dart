import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:trezor_connect/trezor_connect.dart';

class EthereumExample extends StatefulWidget {
  const EthereumExample({required this.trezorConnect, super.key});

  final TrezorConnect trezorConnect;

  @override
  State<StatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends State<EthereumExample> {
  String? response;

  Future<void> getETHAddress() async {
    final res = await widget.trezorConnect.ethereumGetAddress(
      "m/44'/60'/0'/0/0",
    );

    developer.log("${res?.address}, ${res?.serializedPath}, ${res?.path}");
    if (res != null) {
      setState(() => response = res.address);
    }
  }

  Future<void> get10ETHAddress() async {
    final res = await widget.trezorConnect.ethereumGetAddressBundle([
      TrezorGetAddressParams(path: "m/44'/60'/0'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/1'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/2'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/3'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/4'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/5'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/6'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/7'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/8'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/9'/0/0"),
      TrezorGetAddressParams(path: "m/44'/60'/10'/0/0"),
    ]);

    developer.log("$res");
    if (res != null) {
      setState(() => response = "${res.length}\n$res");
    }
  }

  Future<void> signETHMessage() async {
    final res = await widget.trezorConnect.ethereumSignMessage(
      "m/44'/60'/0'/0/0",
      message: "Hey Trezor!",
    );

    developer.log("${res?.address}, ${res?.signature}");
    if (res != null) {
      setState(() => response = res.signature);
    }
  }

  Future<void> signETHEIP1559Tx() async {
    final res = await widget.trezorConnect.ethereumSignTransaction(
      "m/44'/60'/0'/0/0",
      transaction: TrezorEthereumTransaction(
        to: '0xd0d6d6c5fe4a677d343cc433536bb717bae167dd',
        value: '0xf4240',
        data: '0xa',
        chainId: 1,
        nonce: '0x0',
        maxFeePerGas: '0x14',
        maxPriorityFeePerGas: '0x0',
        gasLimit: '0x14',
      ),
    );

    developer.log("v: ${res?.v}, r: ${res?.r}, s: ${res?.s}");
    if (res != null) {
      setState(() => response = "v: ${res.v}, r: ${res.r}, s: ${res.s}");
    }
  }

  Future<void> signETHLegacyTx() async {
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
    title: const Text('Ethereum'),
    children: <Widget>[
      Offstage(offstage: response == null, child: Text(response ?? '')),
      TextButton(onPressed: getETHAddress, child: Text("Get Address")),
      TextButton(
        onPressed: get10ETHAddress,
        child: Text("Get 10 Addresses"),
      ),
      TextButton(
        onPressed: signETHMessage,
        child: Text("Sign message \"Hey Trezor!\""),
      ),
      TextButton(
        onPressed: signETHLegacyTx,
        child: Text("Sign example Legacy Transaction"),
      ),
      TextButton(
        onPressed: signETHEIP1559Tx,
        child: Text("Sign example EIP1559 Transaction"),
      ),
    ],
  );
}
