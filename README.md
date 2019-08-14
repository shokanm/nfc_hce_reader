# nfc_hce_reader

nfc_hce_reader is Flutter plugin for reading NDEF messages on Android and iOS phones. Currently it reads messages from Android phones emulating tags via HCE.
This plugin was inspired by [this](https://pub.dev/packages/nfc_in_flutter) plugin, by [this](https://github.com/underwindfall/NFCAndroid) and [this](https://github.com/underwindfall/NFCReaderiOS) repos.
## Usage
```
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
```

## Example
```
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
    initPlatformState();
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
          child: Text('Running on: $_message\n'),
        ),
      ),
    );
  }
}
```
## Installation

Add `nfc_hce_reader` to your `pubspec.yaml`

```yaml
dependencies:
  nfc_hce_reader: ^0.0.1
```
