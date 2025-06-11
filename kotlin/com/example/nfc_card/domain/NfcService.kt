// android/app/src/main/kotlin/com/example/nfc_card/domain/NfcService.kt
package com.example.nfc_card.domain

import android.nfc.Tag

interface NfcService {
    fun enableHce(enable: Boolean): Boolean
    fun isNfcSupported(): Boolean
    fun isHceSupported(): Boolean
    fun parseTag(tag: Tag): Map<String, Any>
}