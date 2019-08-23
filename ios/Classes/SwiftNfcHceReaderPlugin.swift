import Flutter
import UIKit

@available(iOS 11, *)
public class SwiftNfcHceReaderPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  private var mEventSink: FlutterEventSink?

  let helper = NFCHelper()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "nfc_hce_reader", binaryMessenger: registrar.messenger())
    let instance = SwiftNfcHceReaderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let chargingChannel = FlutterEventChannel(name: "nfcDataStream",binaryMessenger: registrar.messenger())
    chargingChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "initializeNFCReading") {
        DispatchQueue.main.async {
            self.helper.onNFCResult = self.onNFCResult(success:msg:)
            self.helper.restartSession()
            result(true)
        }
    }
    if (call.method == "isNFCAvailable") {
        DispatchQueue.main.async {
            result(self.helper.isNfcEnabled())
        }
    }
  }
    
    

  func onNFCResult(success: Bool, msg: String) {
        DispatchQueue.main.async {
          guard let mEventSink = self.mEventSink else {
              return
          }
          mEventSink(msg)
        }
      }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    mEventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    mEventSink = nil
    return nil
  }
}
