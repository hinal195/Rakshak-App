package com.Safety.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.SystemClock
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import java.util.Locale

class VoiceSosForegroundService : Service() {

    companion object {
        const val ACTION_START = "VOICE_SOS_START"
        const val ACTION_STOP = "VOICE_SOS_STOP"
        const val EXTRA_CONTACTS = "VOICE_SOS_CONTACTS"

        private const val NOTIFICATION_CHANNEL_ID = "voice_sos_channel"
        private const val NOTIFICATION_CHANNEL_NAME = "Voice SOS Listening"
        private const val NOTIFICATION_ID = 9911
        private const val COOLDOWN_MS = 30_000L

        private val WAKE_WORDS = listOf("sos", "help", "bachao", "emergency", "danger")
    }

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var speechRecognizer: SpeechRecognizer? = null
    private var recognizerIntent: Intent? = null
    private val handler = Handler(Looper.getMainLooper())
    private var contacts: List<String> = emptyList()
    private var lastTriggerTime: Long = 0
    private var isListening: Boolean = false

    override fun onCreate() {
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        setupSpeechRecognizer()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                contacts = intent.getStringArrayListExtra(EXTRA_CONTACTS) ?: emptyList()
                startInForeground()
                startListening()
                VoiceSosChannelHolder.notifyStatus(true)
            }
            ACTION_STOP -> {
                stopListening()
                VoiceSosChannelHolder.notifyStatus(false)
                stopSelf()
            }
        }
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        stopListening()
        VoiceSosChannelHolder.notifyStatus(false)
        super.onDestroy()
    }

    private fun setupSpeechRecognizer() {
        if (!SpeechRecognizer.isRecognitionAvailable(this)) {
            Log.e("VoiceSOS", "Speech recognition not available")
            return
        }
        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
        recognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE, packageName)
        }

        speechRecognizer?.setRecognitionListener(object : RecognitionListener {
            override fun onReadyForSpeech(params: Bundle?) {}
            override fun onBeginningOfSpeech() {}
            override fun onRmsChanged(rmsdB: Float) {}
            override fun onBufferReceived(buffer: ByteArray?) {}
            override fun onEndOfSpeech() {}
            override fun onError(error: Int) {
                restartListeningWithDelay()
            }

            override fun onResults(results: Bundle?) {
                handleResults(results)
                restartListeningWithDelay()
            }

            override fun onPartialResults(partialResults: Bundle?) {
                handleResults(partialResults)
            }

            override fun onEvent(eventType: Int, params: Bundle?) {}
        })
    }

    private fun handleResults(bundle: Bundle?) {
        val matches = bundle?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION) ?: return
        val text = matches.joinToString(" ").lowercase(Locale.getDefault())
        val matchedWord = WAKE_WORDS.firstOrNull { text.contains(it) } ?: return

        val now = SystemClock.elapsedRealtime()
        if (now - lastTriggerTime < COOLDOWN_MS) return
        lastTriggerTime = now

        triggerSos(matchedWord)
    }

    private fun startInForeground() {
        val notification = buildNotification("Active – Listening for emergency keywords")
        startForeground(NOTIFICATION_ID, notification)
    }

    private fun buildNotification(status: String): Notification {
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            packageManager.getLaunchIntentForPackage(packageName),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("Voice SOS")
            .setContentText(status)
            .setSmallIcon(android.R.drawable.ic_lock_silent_mode_off)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                NOTIFICATION_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.description = "Voice SOS background listening"
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    private fun startListening() {
        if (isListening) return
        isListening = true
        speechRecognizer?.startListening(recognizerIntent)
    }

    private fun stopListening() {
        isListening = false
        try {
            speechRecognizer?.stopListening()
            speechRecognizer?.cancel()
        } catch (_: Exception) { }
    }

    private fun restartListeningWithDelay() {
        if (!isListening) return
        handler.postDelayed({ speechRecognizer?.startListening(recognizerIntent) }, 400)
    }

    private fun triggerSos(triggerWord: String) {
        Log.d("VoiceSOS", "SOS triggered by wake word: $triggerWord")
        fetchLocation { location ->
            val lat = location?.latitude
            val lng = location?.longitude
            val mapsLink = if (lat != null && lng != null) {
                "https://maps.google.com/?q=$lat,$lng"
            } else {
                "Location unavailable"
            }

            Log.d("VoiceSOS", "Location: lat=$lat, lng=$lng, mapsLink=$mapsLink")
            Log.d("VoiceSOS", "Contacts to notify: ${contacts.size}")
            
            val smsSent = sendSmsToContacts(mapsLink)
            vibrate()

            VoiceSosChannelHolder.notifySosTriggered(
                triggerWord,
                lat,
                lng,
                System.currentTimeMillis(),
                if (smsSent) "sent" else "failed"
            )
        }
    }

    private fun fetchLocation(callback: (Location?) -> Unit) {
        try {
            fusedLocationClient.lastLocation
                .addOnSuccessListener { loc ->
                    if (loc != null) {
                        callback(loc)
                    } else {
                        fusedLocationClient.getCurrentLocation(
                            com.google.android.gms.location.Priority.PRIORITY_HIGH_ACCURACY,
                            null
                        ).addOnSuccessListener { freshLoc ->
                            callback(freshLoc)
                        }.addOnFailureListener { callback(null) }
                    }
                }
                .addOnFailureListener { callback(null) }
        } catch (e: SecurityException) {
            Log.e("VoiceSOS", "Location permission missing: $e")
            callback(null)
        }
    }

    private fun sendSmsToContacts(mapsLink: String): Boolean {
        if (contacts.isEmpty()) {
            Log.w("VoiceSOS", "No contacts to send SMS to")
            sendResultNotification("No active SIM found. Cannot send SMS.")
            return false
        }

        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            Log.e("VoiceSOS", "SMS permission not granted")
            sendResultNotification("SMS failed. Check SIM status or number format.")
            return false
        }

        val (smsManager, subId) = resolveSmsManager() ?: run {
            sendResultNotification("No active SIM found. Cannot send SMS.")
            return false
        }

        Log.d("VoiceSOS", "Sending SMS using SIM ID: $subId")

        val message = "🚨 EMERGENCY ALERT 🚨\n\nI need help immediately.\n\nMy live location: $mapsLink"

        var successCount = 0
        var failCount = 0
        var anyFailure = false

        contacts.forEach { number ->
            try {
                val cleanNumber = sanitizeNumber(number)
                if (cleanNumber.isEmpty()) {
                    Log.w("VoiceSOS", "Invalid phone number: $number")
                    failCount++
                    anyFailure = true
                    return@forEach
                }

                Log.d("VoiceSOS", "Target number: $cleanNumber")

                val parts = smsManager.divideMessage(message)
                if (parts.size == 1) {
                    smsManager.sendTextMessage(cleanNumber, null, message, null, null)
                } else {
                    smsManager.sendMultipartTextMessage(cleanNumber, null, parts, null, null)
                }

                successCount++
                Log.i("VoiceSOS", "SMS sent successfully to: $cleanNumber")
            } catch (e: SecurityException) {
                Log.e("VoiceSOS", "SMS failed: ${e.message}")
                failCount++
                anyFailure = true
            } catch (e: IllegalArgumentException) {
                Log.e("VoiceSOS", "SMS failed: ${e.message}")
                failCount++
                anyFailure = true
            } catch (e: Exception) {
                Log.e("VoiceSOS", "SMS failed: ${e.message}")
                failCount++
                anyFailure = true
            }
        }

        Log.i("VoiceSOS", "SMS sending complete: $successCount sent, $failCount failed")

        if (successCount > 0 && !anyFailure) {
            sendResultNotification("Emergency SMS sent to $successCount contact(s)")
            return true
        } else {
            sendResultNotification("SMS failed. Check SIM status or number format.")
            return false
        }
    }

    private fun resolveSmsManager(): Pair<SmsManager, Int>? {
        return try {
            val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val activeSubs = subscriptionManager.activeSubscriptionInfoList
            if (activeSubs == null || activeSubs.isEmpty()) {
                Log.e("VoiceSOS", "No active SIM found.")
                null
            } else {
                val defaultSubId = SubscriptionManager.getDefaultSmsSubscriptionId()
                val chosenSub = activeSubs.firstOrNull { it.subscriptionId == defaultSubId }
                    ?: activeSubs.first()
                val manager = SmsManager.getSmsManagerForSubscriptionId(chosenSub.subscriptionId)
                Log.d("VoiceSOS", "Using subscriptionId=${chosenSub.subscriptionId}")
                Pair(manager, chosenSub.subscriptionId)
            }
        } catch (e: Exception) {
            Log.e("VoiceSOS", "Failed to resolve SMS manager: ${e.message}")
            null
        }
    }

    private fun sanitizeNumber(number: String): String {
        var clean = number.replace(Regex("[\\s\\-()]+"), "")
        clean = clean.replace(Regex("[^+0-9]"), "")
        if (!clean.startsWith("+") && clean.length == 10) {
            clean = "+91$clean"
        }
        return clean
    }

    private fun vibrate() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                vibratorManager.defaultVibrator.vibrate(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator.vibrate(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE))
                } else {
                    @Suppress("DEPRECATION")
                    vibrator.vibrate(500)
                }
            }
        } catch (_: Exception) { }
    }

    private fun sendResultNotification(message: String = "Emergency message sent to trusted contacts") {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val notification = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("SOS Alert")
            .setContentText(message)
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .build()
        manager.notify(NOTIFICATION_ID + 1, notification)
    }
}

