package com.Safety.app

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val helperChannel = "flutter.native/helper"
    private val voiceSosChannel = "voice_sos"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Existing helper channel for phone calls
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, helperChannel).setMethodCallHandler { call, result ->
            if (call.method == "makeCall") {
                val phoneNumber: String? = call.argument("phoneNumber")
                if (phoneNumber != null) {
                    makeCall(phoneNumber)
                    result.success("Calling $phoneNumber")
                } else {
                    result.error("INVALID_PHONE_NUMBER", "Phone number is null", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Voice SOS channel to start/stop the native foreground service
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, voiceSosChannel)
        VoiceSosChannelHolder.channel = channel

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startVoiceService" -> {
                    val contacts: List<String>? = call.argument("contacts")
                    startVoiceService(contacts ?: emptyList())
                    result.success(true)
                }
                "stopVoiceService" -> {
                    stopVoiceService()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun makeCall(phoneNumber: String) {
        val intent = Intent(Intent.ACTION_CALL)
        intent.data = Uri.parse("tel:$phoneNumber")
        startActivity(intent)
    }

    private fun startVoiceService(contacts: List<String>) {
        val intent = Intent(this, VoiceSosForegroundService::class.java).apply {
            action = VoiceSosForegroundService.ACTION_START
            putStringArrayListExtra(VoiceSosForegroundService.EXTRA_CONTACTS, ArrayList(contacts))
        }
        startForegroundServiceCompat(this, intent)
    }

    private fun stopVoiceService() {
        val intent = Intent(this, VoiceSosForegroundService::class.java).apply {
            action = VoiceSosForegroundService.ACTION_STOP
        }
        startForegroundServiceCompat(this, intent)
    }

    private fun startForegroundServiceCompat(context: Context, intent: Intent) {
        try {
            context.startForegroundService(intent)
        } catch (ex: Exception) {
            // Fallback in case of older API behavior
            context.startService(intent)
        }
    }
}