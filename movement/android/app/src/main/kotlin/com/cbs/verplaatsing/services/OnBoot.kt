package com.cbs.verplaatsing.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.content.ContextCompat.startForegroundService

class OnBoot : BroadcastReceiver() {

    private val SHARED_PREFERENCES_SENSOR = "com.cbs.sensor"
    private val KEY_COMPLETED = "KEY_COMPLETED"
    private val TAG = "OnReceive"

    override fun onReceive(context: Context, intent: Intent) {
        val prefs = context.getSharedPreferences(SHARED_PREFERENCES_SENSOR, Context.MODE_PRIVATE)
        val completed = prefs.getBoolean(KEY_COMPLETED, false)

        if (Intent.ACTION_BOOT_COMPLETED == intent.action)
        {
            if(!completed){
                Log.v(TAG, "Start LocationService")

                val serviceIntent = Intent(context, LocationService::class.java)
                serviceIntent.action = LocationService.ON_BOOT
                startForegroundService( context, serviceIntent)
            }
        }
        

    }

}