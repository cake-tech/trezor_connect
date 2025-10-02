import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:trezor_connect/coins/bitcoin.dart';
import 'package:trezor_connect/coins/ethereum.dart';
import 'package:trezor_connect/trezor_connect.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  ExampleApp({super.key})
    : trezorConnect = TrezorConnect("tcexample://trezor_connect") {
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
    ]
    );

    developer.log("$res");
    if (res != null) {
      setState(() => response = "${res.length}\n$res" );
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
            ],
          ),
          ExpansionTile(
            title: const Text('Ethereum'),
            children: <Widget>[
              TextButton(onPressed: getETHAddress, child: Text("Get Address")),
              TextButton(onPressed: get10ETHAddress, child: Text("Get 10 Addresses")),
              TextButton(onPressed: signETHMessage, child: Text("Sign message \"Hey Trezor!\"")),
            ],
          ),
        ],
      ),
    ),
  );
}
