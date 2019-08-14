import 'dart:async';

import 'package:flutter/services.dart';

class NfcHceReader {
  static const MethodChannel _channel =
      const MethodChannel('nfc_hce_reader');

//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }

  static const EventChannel _eventChannel = const EventChannel("nfcDataStream");

  static Stream<String> _nfcDataStream;

  static Stream<String> readNFCStream(){
    if(_nfcDataStream == null){
      _nfcDataStream = _eventChannel.receiveBroadcastStream().map<String>((value)=>value);
    }
    return _nfcDataStream;
  }

  static Future<bool> initializeNFCReading() async {
    await _channel.invokeMethod("initializeNFCReading");
  }
}
