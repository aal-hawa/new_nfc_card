// android/app/src/main/kotlin/com/example/nfc_card/domain/NfcService.kt
package com.example.nfc_card.domain

interface NfcService {
    fun enableHce(enable: Boolean): Boolean
    fun isNfcSupported(): Boolean
    fun isHceSupported(): Boolean
}