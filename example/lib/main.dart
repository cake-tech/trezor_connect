import 'package:app_links/app_links.dart';
import 'package:example/coins/bitcoin.dart';
import 'package:flutter/material.dart';
import 'package:trezor_connect/trezor_connect.dart';

import 'coins/ethereum.dart';
import 'coins/solana.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title, required this.trezorConnect});

  final String title;
  final TrezorConnect trezorConnect;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    ),
    body: Center(
      child: Column(
        children: <Widget>[
          BitcoinExample(trezorConnect: trezorConnect),
          EthereumExample(trezorConnect: trezorConnect),
          SolanaExample(trezorConnect: trezorConnect),
        ],
      ),
    ),
  );
}
