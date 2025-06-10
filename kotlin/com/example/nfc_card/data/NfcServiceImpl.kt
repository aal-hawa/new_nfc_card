package com.example.nfc_card.data

import android.app.Activity
import android.content.ComponentName
import android.content.pm.PackageManager // Add this import
import android.nfc.NfcAdapter
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
        // Use activity.packageManager instead of context.packageManager
        return activity.packageManager.hasSystemFeature(PackageManager.FEATURE_NFC_HOST_CARD_EMULATION)
    }
}