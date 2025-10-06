import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:trezor_connect/trezor_connect.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  ExampleApp({super.key})
    : trezorConnect = TrezorConnect(
        "tcexample://trezor_connect",
        appName: 'Trezor Connect Example',
      ) {
    appLinks = AppLinks();
    appLinks.uriLinkStream.listen(trezorConnect.handleCallback);
  }

  late AppLinks appLinks;
  final TrezorConnect trezorConnect;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Trezor Connect Example',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromRGBO(94, 227, 150, 1),
        onSurface: Color.fromRGBO(20, 20, 20, 1),
      ),
    ),
    home: HomePage(title: 'Trezor Demo', trezorConnect: trezorConnect),
    debugShowCheckedModeBanner: false,
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.trezorConnect});

  final String title;
  final TrezorConnect trezorConnect;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      title: Text(
        widget.title,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Offstage(offstage: response == null, child: Text(response ?? '')),
          ExpansionTile(
            title: const Text('Bitcoin'),
            children: <Widget>[
              TextButton(onPressed: getAddress, child: Text("Get Address")),
              TextButton(
                onPressed: getPublicKey,
                child: Text("Get Public Key"),
              ),
              TextButton(
                onPressed: signMessage,
                child: Text("Sign message \"Hey Trezor!\""),
              ),
              TextButton(
                onPressed: signTransaction,
                child: Text("Sign Transaction"),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Ethereum'),
            children: <Widget>[
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
          ),
        ],
      ),
    ),
  );
}
