package me.shokanmustafa.nfc_hce_reader.parser

import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.util.Log

object NdefMessageParser {

    fun parse(message: NdefMessage): List<ParsedNdefRecord> {
        return getRecords(message.records)
    }

    fun getRecords(records: Array<NdefRecord>): List<ParsedNdefRecord> {
        val elements = ArrayList<ParsedNdefRecord>()

        for (record in records) {
            if (TextRecord.isText(record)) {
                Log.e("werw", "inside if ")
                elements.add(TextRecord.parse(record))
            } else {
                Log.e("werw", "inside else ")
                elements.add(object : ParsedNdefRecord {
                    override fun str(): String {
                        return String(record.payload)
                    }
                })
            }
        }

        return elements
    }
}