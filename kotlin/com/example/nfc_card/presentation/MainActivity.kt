package com.example.nfc_card.presentation

import android.content.Context
import android.content.SharedPreferences
import android.nfc.cardemulation.HostApduService
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.nfc_card.data.NfcServiceImpl
import com.example.nfc_card.data.HceServiceImpl
import com.example.nfc_card.domain.NfcService
import com.example.nfc_card.domain.HceService
import android.content.pm.PackageManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.nfc_card/channel"
    private lateinit var nfcService: NfcService
    private lateinit var hceService: HceService
    private lateinit var prefs: SharedPreferences

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        prefs = getSharedPreferences("NfcPrefs", Context.MODE_PRIVATE)
        nfcService = NfcServiceImpl(this)
        hceService = HceServiceImpl(prefs)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setHceEmulation" -> {
                    val active = call.argument<Boolean>("active") ?: false
                    result.success(nfcService.enableHce(active))
                }
                "setHcePayload" -> {
                    val data = call.argument<Map<String, String>>("data")
                    hceService.setTagData(data?.get("aid"), data?.get("payload"))
                    result.success(true)
                }
                "setDiscoveryMode" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    hceService.setDiscoveryMode(enabled)
                    result.success(true)
                }
                "getDiscoveredAids" -> {
                    result.success(hceService.getDiscoveredAids())
                }
                "checkHceSupport" -> {
                    result.success(nfcService.isHceSupported())
                }
                else -> result.notImplemented()
            }
        }
    }
}

class MyHostApduService : HostApduService() {
    override fun processCommandApdu(commandApdu: ByteArray?, extras: Bundle?): ByteArray {
        // Implementation would delegate to HceServiceImpl
        return byteArrayOf(0x6A.toByte(), 0x82.toByte()) // Fixed byte conversion
    }

    override fun onDeactivated(reason: Int) {
        // Handle deactivation
    }
}