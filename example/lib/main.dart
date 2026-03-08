import 'package:flutter/material.dart';
import 'package:share_receiver/share_receiver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedData? _sharedData;

  @override
  void initState() {
    super.initState();
    _initShareReceiver();
  }

  @override
  void dispose() {
    ShareReceiver.instance.dispose();
    super.dispose();
  }

  Future<void> _initShareReceiver() async {
    // Get initial sharing data (if app was opened via share)
    final initial = await ShareReceiver.instance.getInitialSharing();
    if (initial != null) {
      setState(() => _sharedData = initial);
      // Clear the initial data
      ShareReceiver.instance.clear();
    }

    // Listen for shares while app is running
    ShareReceiver.instance.getMediaStream().listen((data) {
      setState(() => _sharedData = data);
      // Clear the received data
      ShareReceiver.instance.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Share Receiver Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: .min,
              spacing: 8.0,
              children: [
                Text('Shared data: ${_sharedData?.toString() ?? 'No data'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
