import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../share_receiver.dart';
import 'share_receiver_platform_interface.dart';

/// An implementation of [ShareReceiverPlatform] that uses method channels.
class MethodChannelShareReceiver extends ShareReceiverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('share_receiver_method');

  @override
  Future<bool> initialize({String? appGroupId}) async {
    try {
      await methodChannel.invokeMethod('initialize', {
        'appGroupId': appGroupId,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<SharedData?> getInitialSharing() async {
    // if (Platform.isIOS) {
    //   return await _getIOSInitialSharedData();
    // } else if (Platform.isAndroid) {
    //   return await _getAndroidInitialSharedData();
    // }
    // return null;
    try {
      final result = await methodChannel.invokeMethod<dynamic>(
        'getInitialSharing',
      );
      if (result == null) return null;

      if (result is List && result.isNotEmpty) {
        final firstItem = result.first;
        if (firstItem is Map) {
          final data = SharedData.fromMap(Map<String, dynamic>.from(firstItem));
          return data.hasContent ? data : null;
        }
      } else if (result is Map) {
        final data = SharedData.fromMap(Map<String, dynamic>.from(result));
        return data.hasContent ? data : null;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // Future<SharedData?> _getIOSInitialSharedData() async {
  //   try {
  //     final result = await methodChannel.invokeMethod<dynamic>(
  //       'getInitialSharing',
  //     );
  //     if (result == null) return null;

  //     if (result is List && result.isNotEmpty) {
  //       final firstItem = result.first;
  //       if (firstItem is Map) {
  //         final data = SharedData.fromMap(Map<String, dynamic>.from(firstItem));
  //         return data.hasContent ? data : null;
  //       }
  //     } else if (result is Map) {
  //       final data = SharedData.fromMap(Map<String, dynamic>.from(result));
  //       return data.hasContent ? data : null;
  //     }

  //     return null;
  //   } catch (_) {
  //     return null;
  //   }
  // }

  // Future<SharedData?> _getAndroidInitialSharedData() async {
  //   try {
  //     final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
  //       'getInitialSharing',
  //     );
  //     if (result == null) return null;

  //     final data = SharedData.fromMap(Map<String, dynamic>.from(result));
  //     return data.hasContent ? data : null;
  //   } catch (_) {
  //     return null;
  //   }
  // }

  @override
  Future<void> clear() async {
    try {
      await methodChannel.invokeMethod('clear');
    } catch (_) {}
  }
}
