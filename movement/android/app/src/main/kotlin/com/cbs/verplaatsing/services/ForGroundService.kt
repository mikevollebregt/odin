package com.cbs.verplaatsing.services

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.cbs.verplaatsing.MainActivity
import com.cbs.verplaatsing.R

class ForGroundService : Service() {
    companion object {
        val CHANNEL_ID = "1956"
        val notificationId = 252
        var cnt = 0

    }

    var locationListener: LocationListener? = null
    var locationManager: LocationManager? = null
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onCreate() {
        // Start up the thread running the service
        createCh()
        startForeground(notificationId, NotificationCompat.Builder(this, CHANNEL_ID).build())


    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {

        // If we get killed, after returning from here, restart
        //Main Thread
        showNotification("Service is Running")
        doWork()
        return START_NOT_STICKY
    }

    fun doWork() {
        getLocation() {
            Toast.makeText(MainActivity.This!!.applicationContext, "location", Toast.LENGTH_SHORT).show()
            showNotification(it)
        }
    }

    override fun onDestroy() {
        Log.v("ForService", "Service Is Dead")
        RemoveUpdates()
        showNotification("Service is Destroyed restart app .")
        stopForeground(true)


    }

    //Create Notification Channel ID .

    @SuppressLint("InlinedApi")
    private fun showNotification(msg: String) {
//        val stopintent = Intent(this, MyBroadcastReceiver::class.java).apply {
//            ACTION_SNOOZE
//            putExtra(EXTRA_NOTIFICATION_ID, 0)
//        }

//        val stoppendingintent: PendingIntent =
//                PendingIntent.getBroadcast(this, 0, stopintent, 0)

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("My notification")
                .setContentText(msg)
                .setStyle(
                        NotificationCompat.BigTextStyle()
                                .bigText(msg)
                )
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
//                .addAction(
//                        R.mipmap.ic_launcher_round, "StopService",
//                        stoppendingintent
//                )

        with(NotificationManagerCompat.from(this)) {
            // notificationId is a unique int for each notification that you must define
            notify(notificationId, builder.build())
        }
    }

    fun Context.getLocation(onResult: (String) -> Unit = {}) {
        val context = this
        locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager?

        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                Toast.makeText(MainActivity.This!!.applicationContext, "location", Toast.LENGTH_SHORT).show()
                location.let {
                    onResult("cntrefresh {${++cnt}} lat-> ${it.latitude} , lng ${it.longitude} ")
                    //send Location To Activity and then send it to Parse Location Function......

                }
            }

            override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {
                //   Timber.tag(MyTag).v("on Status Changed $provider  $status")
            }

            override fun onProviderEnabled(provider: String) {
                //  Timber.tag(MyTag).v("on Provider Enabled $provider")
            }

            override fun onProviderDisabled(provider: String) {
                //   Timber.tag(MyTag).v("on Provider Disabled $provider")
            }
        }// location Listner
        try {
            locationManager?.let {
                if (it.isProviderEnabled(LocationManager.GPS_PROVIDER) && it.isProviderEnabled(LocationManager.NETWORK_PROVIDER))
                    it.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000, 0f, locationListener as LocationListener)
                else {
                    //fail.value = Failure.GPSError
                    onResult("Gps Error")

                }

            }
        } catch (ex: SecurityException) {
            //  fail.value = Failure.SecurityError
            onResult("Permission")

        }
    }

    private fun RemoveUpdates() {
        locationListener?.let {
            locationManager?.removeUpdates(it)

        }
    }

    fun createCh() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel
            val name = "randname"
            val descriptionText = "dumdum"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val mChannel = NotificationChannel(CHANNEL_ID, name, importance)
            mChannel.description = descriptionText
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
        }
    }

}