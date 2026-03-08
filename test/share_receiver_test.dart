import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_receiver/share_receiver.dart';
import 'package:share_receiver/src/share_receiver_method_channel.dart';
import 'package:share_receiver/src/share_receiver_platform_interface.dart';

class MockShareReceiverPlatform
    with MockPlatformInterfaceMixin
    implements ShareReceiverPlatform {
  @override
  Future<SharedData?> getInitialSharing() {
    return Future.value(SharedData(text: 'Initial share data'));
  }

  @override
  Future<bool> initialize({String? appGroupId}) {
    return Future.value(true);
  }

  @override
  Future<void> clear() {
    return Future.value();
  }
}

void main() {
  final ShareReceiverPlatform initialPlatform = ShareReceiverPlatform.instance;

  test('$MethodChannelShareReceiver is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelShareReceiver>());
  });

  test('getInitialSharing', () async {
    MockShareReceiverPlatform fakePlatform = MockShareReceiverPlatform();
    ShareReceiverPlatform.instance = fakePlatform;

    expect(
      await ShareReceiver.instance.getInitialSharing(),
      SharedData(text: 'Initial share data'),
    );
  });

  test('initialize', () async {
    MockShareReceiverPlatform fakePlatform = MockShareReceiverPlatform();
    ShareReceiverPlatform.instance = fakePlatform;

    expect(await ShareReceiver.instance.initialize(), true);
  });

  test('initialize with group id', () async {
    MockShareReceiverPlatform fakePlatform = MockShareReceiverPlatform();
    ShareReceiverPlatform.instance = fakePlatform;

    expect(
      await ShareReceiver.instance.initialize(
        appGroupId: 'group.com.company.app',
      ),
      true,
    );
  });

  test('clear', () async {
    MockShareReceiverPlatform fakePlatform = MockShareReceiverPlatform();
    ShareReceiverPlatform.instance = fakePlatform;

    await ShareReceiver.instance.clear();
  });
}
