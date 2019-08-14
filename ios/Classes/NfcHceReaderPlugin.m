#import "NfcHceReaderPlugin.h"
#import <nfc_hce_reader/nfc_hce_reader-Swift.h>

@implementation NfcHceReaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNfcHceReaderPlugin registerWithRegistrar:registrar];
}
@end
