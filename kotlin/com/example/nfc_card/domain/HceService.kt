// android/app/src/main/kotlin/com/example/nfc_card/domain/HceService.kt
package com.example.nfc_card.domain

interface HceService {
    fun processCommandApdu(commandApdu: ByteArray?): ByteArray
    fun setDiscoveryMode(enabled: Boolean)
    fun getDiscoveredAids(): List<String>
    fun setTagData(aid: String?, payload: String?)
}