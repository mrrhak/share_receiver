import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../share_receiver.dart';
import 'share_receiver_method_channel.dart';

abstract class ShareReceiverPlatform extends PlatformInterface {
  /// Constructs a ShareReceiverPlatform.
  ShareReceiverPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShareReceiverPlatform _instance = MethodChannelShareReceiver();

  /// The default instance of [ShareReceiverPlatform] to use.
  ///
  /// Defaults to [MethodChannelShareReceiver].
  static ShareReceiverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShareReceiverPlatform] when
  /// they register themselves.
  static set instance(ShareReceiverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> initialize({String? appGroupId}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<SharedData?> getInitialSharing() {
    throw UnimplementedError('getInitialSharing() has not been implemented.');
  }

  Future<void> clear() {
    throw UnimplementedError('clear() has not been implemented.');
  }
}
