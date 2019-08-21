import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nfc_hce_reader/nfc_hce_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = 'none';
  StreamSubscription<String> _stream;

  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool isInitialized;
    try {
      isInitialized = await NfcHceReader.initializeNFCReading();
      _readNFC(context);
    } on PlatformException {

    }

    if (!mounted) return;


  }

  void _readNFC(BuildContext context) {

    StreamSubscription<String> subscription = NfcHceReader.readNFCStream()
        .listen((tag) {
      setState(() {
        _message = tag;
        _stream?.cancel();
      });
    },
        onDone: () {
          setState(() {
            _stream = null;
          });
        },
        onError: (e) {
          setState(() {
            _stream = null;
          });
        });
    setState(() {
      _stream = subscription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(onPressed: () => initPlatformState(),child: Text('Running on: $_message\n')),
        ),
      ),
    );
  }
}
