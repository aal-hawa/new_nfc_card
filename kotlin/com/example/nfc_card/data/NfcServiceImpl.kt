package com.example.nfc_card.data

import android.app.Activity
import android.content.ComponentName
import android.content.pm.PackageManager
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.Ndef
import android.nfc.cardemulation.CardEmulation
import android.util.Log
import com.example.nfc_card.domain.NfcService
import com.example.nfc_card.presentation.MyHostApduService

class NfcServiceImpl(private val activity: Activity) : NfcService {
    private val TAG = "NfcServiceImpl"
    private lateinit var cardEmulation: CardEmulation
    private val nfcAdapter: NfcAdapter? = NfcAdapter.getDefaultAdapter(activity)
    
    init {
        nfcAdapter?.let {
            cardEmulation = CardEmulation.getInstance(it)
        }
    }

    override fun enableHce(enable: Boolean): Boolean {
        return try {
            val hceService = ComponentName(activity, MyHostApduService::class.java)
            if (enable) {
                cardEmulation.setPreferredService(activity, hceService)
            } else {
                cardEmulation.unsetPreferredService(activity)
            }
            true
        } catch (e: Exception) {
            Log.e(TAG, "HCE error", e)
            false
        }
    }

    override fun isNfcSupported(): Boolean {
        return nfcAdapter != null && nfcAdapter.isEnabled
    }

    override fun isHceSupported(): Boolean {
        return activity.packageManager.hasSystemFeature(PackageManager.FEATURE_NFC_HOST_CARD_EMULATION)
    }

    override fun parseTag(tag: Tag): Map<String, Any> {
        val ndef = Ndef.get(tag)
        val records = ndef?.cachedNdefMessage?.records ?: emptyArray<NdefRecord>()
        
        return mutableMapOf<String, Any>().apply {
            put("id", bytesToHex(tag.id))
            put("techList", tag.techList.toList())
            
            val recordList = mutableListOf<Map<String, Any>>()
            records.forEachIndexed { i, record ->
                recordList.add(mapOf(
                    "index" to i,
                    "tnf" to record.tnf,
                    "type" to bytesToHex(record.type),
                    "payload" to bytesToHex(record.payload)
                ))
            }
            
            if (recordList.isNotEmpty()) {
                put("records", recordList)
            }
            
            put("size", ndef?.maxSize ?: 0)
            put("isWritable", ndef?.isWritable ?: false)
            put("canMakeReadOnly", ndef?.canMakeReadOnly() ?: false)
        }
    }

    private fun bytesToHex(bytes: ByteArray): String {
        return bytes.joinToString("") { "%02x".format(it) }
    }
}