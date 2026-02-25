package com.Safety.app

import io.flutter.plugin.common.MethodChannel

/**
 * Simple holder so the foreground service can send events back to Flutter
 * while the engine is alive.
 */
object VoiceSosChannelHolder {
    @Volatile
    var channel: MethodChannel? = null

    fun notifyStatus(isActive: Boolean) {
        channel?.invokeMethod("status", mapOf("active" to isActive))
    }

    fun notifySosTriggered(triggerWord: String?, lat: Double?, lng: Double?, timestamp: Long, status: String) {
        channel?.invokeMethod(
            "sos_triggered",
            mapOf(
                "triggerWord" to (triggerWord ?: "unknown"),
                "latitude" to lat,
                "longitude" to lng,
                "timestamp" to timestamp,
                "status" to status
            )
        )
    }
}

