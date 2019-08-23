import 'dart:io';

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
  bool _isNFCAvaliable = false;
  bool _isPlatformIOS = Platform.isIOS;

  @override
  void initState() {
    super.initState();
    NfcHceReader.isNFCAvailable.then((supported){
      setState(() {
        _isNFCAvaliable = supported;
      });
    });
    if(!_isPlatformIOS && _isNFCAvaliable)
      initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      await NfcHceReader.initializeNFCReading();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('isNFCEnabled $_isNFCAvaliable'),
              Visibility(
                visible: _isPlatformIOS ,
                child: FlatButton(onPressed: () => initPlatformState(),child: Text('Running on: $_message\n')),
              ),
            ],
          )
        ),
      ),
    );
  }
}
