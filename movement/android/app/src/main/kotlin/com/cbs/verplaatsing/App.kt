package com.cbs.verplaatsing

import android.annotation.TargetApi
import android.app.Application
import android.os.Build
import com.cbs.verplaatsing.detector.LifecycleDetector

class App : Application() {
    @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(LifecycleDetector.activityLifecycleCallbacks)
    }
}