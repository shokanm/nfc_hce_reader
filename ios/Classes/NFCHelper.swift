import Foundation
import CoreNFC

@available(iOS 11, *)
class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate {
  var onNFCResult: ((Bool, String) -> ())?
  @available(iOS 11, *)
  func restartSession() {
    let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    session.begin()
  }

  @available(iOS 11, *)
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    guard let onNFCResult = onNFCResult else { return }
    onNFCResult(false, error.localizedDescription)
  }

  @available(iOS 11, *)
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    guard let onNFCResult = onNFCResult else { return }

    var payload = ""
    for message in messages {
      for record in message.records {
        print(record.identifier)
        print(record.payload)
        print(record.type)
        print(record.typeNameFormat)

        payload += "\(record.identifier)\n"
        payload += "\(record.payload)\n"
        payload += "\(record.type)\n"
        payload += "\(record.typeNameFormat)\n"

        print("payload \(record.payload)")
        if let resultString = String(data: record.payload, encoding: .utf8) {
            print("resultString \(resultString)")
          onNFCResult(true, resultString)
            session.invalidate()
        }
      }
    }
  }
}
