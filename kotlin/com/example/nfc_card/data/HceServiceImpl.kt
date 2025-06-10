// android/app/src/main/kotlin/com/example/nfc_card/data/HceServiceImpl.kt
package com.example.nfc_card.data

import android.content.SharedPreferences
import android.nfc.cardemulation.HostApduService
import android.os.Bundle
import android.util.Log
import com.example.nfc_card.domain.HceService
import java.util.*

class HceServiceImpl(
    private val prefs: SharedPreferences
) : HceService {
    private val TAG = "HceServiceImpl"
    private var currentAid: String? = null
    private var currentPayload: String? = null
    private var discoveryMode = false
    private val discoveredAids = mutableSetOf<String>()

    override fun processCommandApdu(commandApdu: ByteArray?): ByteArray {
        commandApdu?.let {
            val commandHex = it.toHexString()
            Log.d(TAG, "Received APDU: $commandHex")
            
            if (discoveryMode) {
                if (isSelectAidCommand(it)) {
                    val aid = extractAidFromCommand(it)
                    Log.d(TAG, "Discovered AID: $aid")
                    discoveredAids.add(aid)
                }
                return "9000".hexToBytes()
            }
            
            if (isSelectAidCommand(it)) {
                val receivedAid = extractAidFromCommand(it)
                if (receivedAid == currentAid) {
                    return "9000".hexToBytes()
                }
                return "6A82".hexToBytes()
            }
        }
        return "6A82".hexToBytes()
    }

    override fun setDiscoveryMode(enabled: Boolean) {
        discoveryMode = enabled
        if (!enabled) {
            saveDiscoveredAids()
        }
    }

    override fun getDiscoveredAids(): List<String> {
        return prefs.getStringSet("discovered_aids", mutableSetOf())?.toList() ?: emptyList()
    }

    override fun setTagData(aid: String?, payload: String?) {
        currentAid = aid
        currentPayload = payload
        prefs.edit()
            .putString("hce_aid", aid)
            .putString("hce_payload", payload)
            .apply()
    }

    private fun saveDiscoveredAids() {
        val existing = prefs.getStringSet("discovered_aids", mutableSetOf()) ?: mutableSetOf()
        existing.addAll(discoveredAids)
        prefs.edit().putStringSet("discovered_aids", existing).apply()
        discoveredAids.clear()
    }

    private fun isSelectAidCommand(command: ByteArray): Boolean {
        return command.size >= 5 && 
               command[0] == 0x00.toByte() && 
               command[1] == 0xA4.toByte() && 
               command[2] == 0x04.toByte() && 
               command[3] == 0x00.toByte()
    }
    
    private fun extractAidFromCommand(command: ByteArray): String {
        val aidLength = command[4].toInt() and 0xFF
        if (command.size < 5 + aidLength) return ""
        val aidBytes = command.copyOfRange(5, 5 + aidLength)
        return aidBytes.toHexString()
    }

    private fun String.hexToBytes(): ByteArray {
        return chunked(2).map { it.toInt(16).toByte() }.toByteArray()
    }

    private fun ByteArray.toHexString(): String {
        return joinToString("") { "%02X".format(it) }
    }
}