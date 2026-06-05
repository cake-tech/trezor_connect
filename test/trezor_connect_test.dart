import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:trezor_connect/trezor_connect.dart';

void main() {
  test('getDeeplink', () {
    final tc = TrezorConnect("", environment: TrezorConnectEnvironment.local);

    expect(
      tc.getDeeplink('getAddress', {
        "coin": "btc",
        "path": "m/44'/0'/0'/0/0",
      }, "https://httpbin.org/get?id=123"),
      "trezorsuitelite://connect/1/?method=getAddress&params=%7B%22coin%22%3A%22btc%22%2C%22path%22%3A%22m%2F44%27%2F0%27%2F0%27%2F0%2F0%22%7D&callback=https%3A%2F%2Fhttpbin.org%2Fget%3Fid%3D123",
    );
  });

  group('TrezorConnect.parseResponse', () {
    Uri buildUri(Map<String, dynamic> response) => Uri.parse(
      'https://example/?response=${Uri.encodeQueryComponent(jsonEncode(response))}',
    );

    test('returns payload on success', () {
      final uri = buildUri({
        'success': true,
        'payload': {'address': 'bc1q...'},
      });
      final payload = TrezorConnect.parseResponse(uri);
      expect(payload, {'address': 'bc1q...'});
    });

    test('throws TrezorCallbackException on success=false', () {
      final uri = buildUri({
        'success': false,
        'payload': {
          'error': 'Failure_ActionCancelled',
          'code': 'Failure_ActionCancelled',
        },
      });
      expect(
        () => TrezorConnect.parseResponse(uri),
        throwsA(
          isA<TrezorCallbackException>()
              .having((e) => e.error, 'error', 'Failure_ActionCancelled')
              .having((e) => e.code, 'code', 'Failure_ActionCancelled'),
        ),
      );
    });

    test('throws when response query param is missing', () {
      final uri = Uri.parse('https://example/?id=123');
      expect(
        () => TrezorConnect.parseResponse(uri),
        throwsA(isA<TrezorCallbackException>()),
      );
    });

    test('throws on malformed JSON', () {
      final uri = Uri.parse('https://example/?response=not-json');
      expect(
        () => TrezorConnect.parseResponse(uri),
        throwsA(isA<TrezorCallbackException>()),
      );
    });
  });
}
