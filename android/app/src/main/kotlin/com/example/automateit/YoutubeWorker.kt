package com.example.automateit

import android.content.Context
import android.content.Intent
import androidx.work.Worker
import androidx.work.WorkerParameters

class YoutubeWorker(appContext: Context, workerParams: WorkerParameters)
    : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        // 유튜브 앱 실행 로직
        val manager = applicationContext.packageManager
        var intent = manager.getLaunchIntentForPackage("com.drforest")

        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            applicationContext.startActivity(intent)
        }

        return Result.success()
    }
}
