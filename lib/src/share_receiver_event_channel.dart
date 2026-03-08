import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../share_receiver.dart';

class ShareReceiverEventChannel {
  static final instance = ShareReceiverEventChannel._();

  ShareReceiverEventChannel._();

  StreamController<SharedData>? _streamController;
  StreamSubscription? _streamSubscription;

  @visibleForTesting
  final eventChannel = const EventChannel('share_receiver_event');

  void dispose() {
    _streamController?.close();
    _streamSubscription?.cancel();
    _streamController = null;
    _streamSubscription = null;
  }

  Stream<SharedData> getMediaStream() {
    _streamController ??= StreamController<SharedData>.broadcast(
      onListen: _startListening,
      onCancel: _checkAndStopListening,
    );
    return _streamController!.stream;
  }

  void _startListening() {
    if (_streamSubscription != null) return;

    _streamSubscription = eventChannel.receiveBroadcastStream().listen((
      dynamic event,
    ) {
      if (event is Map) {
        try {
          final data = SharedData.fromMap(Map<String, dynamic>.from(event));
          if (data.hasContent) {
            _streamController?.add(data);
          }
        } catch (_) {}
      }
    }, onError: (_) {});
  }

  void _checkAndStopListening() {
    if (_streamController?.hasListener == false) {
      _streamSubscription?.cancel();
      _streamSubscription = null;
    }
  }
}
