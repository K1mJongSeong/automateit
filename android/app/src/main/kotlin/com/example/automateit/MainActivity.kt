package com.example.automateit

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.content.pm.PackageManager
import android.app.ActivityManager
import android.os.Bundle
import androidx.work.PeriodicWorkRequest
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit
import android.content.BroadcastReceiver
import android.content.Context
import android.content.IntentFilter

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/launchYoutube"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        registerReceiver(bootReceiver, IntentFilter(Intent.ACTION_BOOT_COMPLETED))
        scheduleWork()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "launchYoutube") {
                launchYoutubeApp()
                result.success("Youtube app launched!")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun launchYoutubeApp() {
        if (!isAppRunning("com.drforest")) {
            val intent = packageManager.getLaunchIntentForPackage("com.drforest")
            if (intent != null) {
                startActivity(intent)
            }
        }
    }

    private fun isAppRunning(packageName: String): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningAppProcesses = manager.runningAppProcesses ?: return false

        for (processInfo in runningAppProcesses) {
            if (processInfo.processName == packageName) return true
        }
        return false
    }

    private val bootReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
                scheduleWork()
            }
        }
    }

    override fun onDestroy() {
        unregisterReceiver(bootReceiver)
        super.onDestroy()
    }

    private fun scheduleWork() {
        val workRequest = PeriodicWorkRequest.Builder(YoutubeWorker::class.java, 15, TimeUnit.MINUTES)
                .build()

        WorkManager.getInstance(this).enqueue(workRequest)
    }
}
