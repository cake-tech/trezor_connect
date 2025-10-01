import 'package:flutter_test/flutter_test.dart';

import 'package:trezor_connect/trezor_connect.dart';

void main() {
  test('getDeeplink', () {
    final tc = TrezorConnect("", environment: TrezorConnectEnvironment.local);

    expect(tc.getDeeplink('getAddress', {"coin":"btc","path":"m/44'/0'/0'/0/0"}, "https://httpbin.org/get?id=123"), "trezorsuitelite://connect/1/?method=getAddress&params=%7B%22coin%22%3A%22btc%22%2C%22path%22%3A%22m%2F44%27%2F0%27%2F0%27%2F0%2F0%22%7D&callback=https%3A%2F%2Fhttpbin.org%2Fget%3Fid%3D123");
  });
}
