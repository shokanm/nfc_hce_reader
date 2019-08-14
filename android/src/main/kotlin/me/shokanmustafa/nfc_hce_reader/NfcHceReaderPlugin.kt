package me.shokanmustafa.nfc_hce_reader

import android.app.Activity
import android.app.Person
import android.nfc.FormatException
import android.nfc.NdefMessage
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.Ndef
import android.os.Bundle
import android.os.Handler
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import me.shokanmustafa.nfc_hce_reader.parser.NdefMessageParser
import java.io.IOException

class NfcHceReaderPlugin() : MethodCallHandler, NfcAdapter.ReaderCallback, EventChannel.StreamHandler  {
  private var mNfcAdapter: NfcAdapter? = null
  private var  mEventSink: EventChannel.EventSink? = null
  private var mActivity: Activity? = null

  constructor(activity: Activity?) : this() {
    mActivity = activity
  }
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      var nfchcereaderPlugin = NfcHceReaderPlugin(registrar.activity())
      val channel = MethodChannel(registrar.messenger(), "nfc_hce_reader")
      channel.setMethodCallHandler(nfchcereaderPlugin)
      val eventChannel = EventChannel(registrar.messenger(), "nfcDataStream")
      eventChannel.setStreamHandler(nfchcereaderPlugin)
    }
  }

  fun initializeNFCReading():Boolean {
    mNfcAdapter = NfcAdapter.getDefaultAdapter(mActivity)

    if(!checkNFCEnable())
      return false
    if(mNfcAdapter == null)
      return false

    val bundle = Bundle()
    mNfcAdapter?.enableReaderMode(mActivity, this, NfcAdapter.FLAG_READER_NFC_A, bundle)

    return true
  }

  private fun checkNFCEnable(): Boolean {
    return if (mNfcAdapter == null) {
      false
    } else {
      mNfcAdapter!!.isEnabled
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {

    if (call.method == "initializeNFCReading") {
      result.success(initializeNFCReading())
      return
    }

    result.notImplemented()

  }

  override fun onTagDiscovered(tag: Tag) {
    val ndef = Ndef.get(tag)
            ?: // tag is not in NDEF format; skip!
            return
    try {
      ndef.connect()
      val message = ndef.ndefMessage ?: return
      val list = arrayListOf<NdefMessage>()
      list.add(message)
      parserNDEFMessage(message)

    } catch (e: IOException) {
    } catch (e: FormatException) {
    }

  }

  private fun parserNDEFMessage(message: NdefMessage) {
    val builder = StringBuilder()
    val records = NdefMessageParser.parse(message)

    val size = records.size

    for (i in 0 until size) {
      val record = records.get(i)
      val str = record?.str()
      builder.append(str).append("\n")
    }
    eventSuccess(builder.toString())
  }

  private fun eventSuccess(result: Any) {
    val mainThread = Handler(mActivity?.getMainLooper())
    val runnable = Runnable {
      if (mEventSink != null) {
        mEventSink?.success(result)
      }
    }
    mainThread.post(runnable)
  }

  override fun onListen(p0: Any?, eventSink: EventChannel.EventSink?) {
    mEventSink = eventSink
  }

  override fun onCancel(p0: Any?) {
    mEventSink = null
  }
}
