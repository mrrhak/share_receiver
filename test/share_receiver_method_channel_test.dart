import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_receiver/share_receiver.dart';
import 'package:share_receiver/src/share_receiver_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelShareReceiver platform = MethodChannelShareReceiver();
  const channel = MethodChannel('share_receiver_method');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getInitialSharing') {
            return SharedData(text: 'Initial share data').toMap();
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getInitialSharing', () async {
    final data = await platform.getInitialSharing();
    expect(data, SharedData(text: 'Initial share data'));
  });

  test('initialize', () async {
    expect(await platform.initialize(), true);
  });

  test('initialize with group id', () async {
    expect(
      await platform.initialize(appGroupId: 'group.com.company.app'),
      true,
    );
  });

  test('clear', () async {
    await platform.clear();
  });
}
