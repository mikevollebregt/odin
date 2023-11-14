package com.cbs.verplaatsing.services

import android.Manifest
import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.*
import android.os.*
import android.provider.Settings
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.cbs.verplaatsing.MainActivity
import com.cbs.verplaatsing.R
import com.cbs.verplaatsing.detector.LifecycleDetector
import com.cbs.verplaatsing.models.Device
import com.cbs.verplaatsing.models.Tracker
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.gson.Gson
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain

class LocationService : Service(), LifecycleDetector.Listener {
    private val LOCATION_CHANNEL = "com.example.flutter/location_info"
    private val SYNC_CHANNEL = "com.example.flutter/sync"
    private val SHARED_PREFERENCES_NAME = "com.cbs.movement"

    private val DEVICE_CHANNEL = "com.example.flutter/device_info"
    private val foregroundNotificationId: Int = (System.currentTimeMillis() % 10000).toInt()
    private var mEngine: FlutterEngine? = null
    private val foregroundNotification by lazy {
        NotificationCompat.Builder(this, foregroundNotificationChannelId)
                .setSmallIcon(R.drawable.ic_baseline_location_on_24)
                .setPriority(NotificationCompat.PRIORITY_MIN)
                .setSound(null)
                .setContentTitle("CBS achtergrond service")
                .build()
    }

    private val fusedLocationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult) {
            val location = locationResult.lastLocation
            val tracker = Tracker(location.longitude, location.latitude, location.time, location.altitude, "fused", location.bearing, location.accuracy, location.speed, "fused")
            val json = Gson().toJson(tracker)

            if (mEngine != null) {
                MethodChannel(mEngine!!.dartExecutor.binaryMessenger, LOCATION_CHANNEL).invokeMethod("save", json)
            }
        }
    }

    private val balancedLocationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult) {
            val location = locationResult.lastLocation
            val tracker = Tracker(location.longitude, location.latitude, location.time, location.altitude, "balanced", location.bearing, location.accuracy, location.speed, "balanced")
            val json = Gson().toJson(tracker)

            if (mEngine != null) {
                MethodChannel(mEngine!!.dartExecutor.binaryMessenger, LOCATION_CHANNEL).invokeMethod("save", json)
            }
        }
    }

    private val locationListener = object : LocationListener{
        override fun onLocationChanged(location: Location) {
            val tracker = Tracker(
                location.longitude,
                location.latitude,
                location.time,
                location.altitude,
                "normal",
                location.bearing,
                location.accuracy,
                location.speed,
                location.provider
            )
            val json = Gson().toJson(tracker)

            if (mEngine != null) {
                MethodChannel(
                    mEngine!!.dartExecutor.binaryMessenger,
                    LOCATION_CHANNEL
                ).invokeMethod("save", json)
            }
        }
    }

    private val foregroundNotificationChannelName by lazy {
        getString(R.string.hello_first_fragment)
    }

    private val foregroundNotificationChannelDescription by lazy {
        getString(R.string.hello_first_fragment)
    }

    private val foregroundNotificationChannelId by lazy {
        "ForegroundServiceSample.NotificationChannel".also {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager).apply {
                    if (getNotificationChannel(it) == null) {
                        createNotificationChannel(
                                NotificationChannel(
                                        it,
                                        foregroundNotificationChannelName,
                                        NotificationManager.IMPORTANCE_MIN
                                ).also {
                                    it.description = foregroundNotificationChannelDescription
                                    it.lockscreenVisibility = NotificationCompat.VISIBILITY_PRIVATE
                                    it.vibrationPattern = null
                                    it.setSound(null, null)
                                    it.setShowBadge(false)
                                })
                    }
                }
            }
        }
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        if (intent != null) {
            val action = intent.action
            if (action == ACTION_STOP_FOREGROUND_SERVICE) {
                stopForegroundService()
                return START_STICKY
            }

            if(action == ACTION_STOP_FUSED) {
                stopFusedLocationProvider()
                return START_STICKY
            }

            if(action == ACTION_STOP_BALANCED) {
                stopBalancedLocationProvider()
                return START_STICKY
            }

            if(action == ACTION_STOP_NORMAL) {
                stopNormalLocationProvider()
                return START_STICKY
            }

            if(action == USE_NORMAL) {
                useNormalLocationProvider()
                return START_STICKY
            }

            if(action == USE_FUSED) {
                useFusedLocationProvider()
                return START_STICKY
            }

            if(action == USE_BALANCED) {
                useBalancedLocationProvider()
                return START_STICKY
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(foregroundNotificationId, foregroundNotification)
        }

        LifecycleDetector.listener = this
        mEngine = MainActivity.mFlutterEngine


        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return START_STICKY
        }

        startLocationService()

        intent?.getLongExtra(KEY_CALLBACK_RAW_HANDLE, -1)?.let { callbackRawHandle ->
            if (callbackRawHandle != -1L) setCallbackRawHandle(callbackRawHandle)
        }


        if (!LifecycleDetector.isActivityRunning) {
            startFlutterNativeView()
        }

        if(intent?.action == ON_BOOT) {
            val prefs = getSharedPreferences(SHARED_PREFERENCES_SENSOR, Context.MODE_PRIVATE)
            val sensor = prefs.getString(KEY_SENSOR, "")

            if(sensor == "fused") {
                useFusedLocationProvider()
            } else if(sensor == "balanced") {
                useBalancedLocationProvider()
            } else if(sensor == "normal") {
                useNormalLocationProvider()
            }

            
        }

        return START_STICKY
    }


    private fun useFusedLocationProvider() {
        stopBalancedLocationProvider()
        stopNormalLocationProvider()

        val prefs = getSharedPreferences(SHARED_PREFERENCES_SENSOR, Context.MODE_PRIVATE)
        prefs.edit().putString(KEY_SENSOR, "fused").apply()
    }

    private fun useBalancedLocationProvider() {
        stopFusedLocationProvider()
        stopNormalLocationProvider()

        val prefs = getSharedPreferences(SHARED_PREFERENCES_SENSOR, Context.MODE_PRIVATE)
        prefs.edit().putString(KEY_SENSOR, "balanced").apply()
    }

    private fun useNormalLocationProvider() {
        stopBalancedLocationProvider()
        stopFusedLocationProvider()

        val prefs = getSharedPreferences(SHARED_PREFERENCES_SENSOR, Context.MODE_PRIVATE)
        prefs.edit().putString(KEY_SENSOR, "normal").apply()
    }

    private fun stopFusedLocationProvider() {
        val mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        mFusedLocationClient.removeLocationUpdates(fusedLocationCallback)
    }

    private fun stopBalancedLocationProvider() {
        val mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        mFusedLocationClient.removeLocationUpdates(balancedLocationCallback)
    }

    private fun stopNormalLocationProvider() {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        locationManager.removeUpdates(locationListener)
    }

    private fun startCustomHighGoogleLocationService() {
        val mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        val locationRequest = LocationRequest()
        locationRequest.interval = 30000 // two minute interval

        locationRequest.fastestInterval = 30000
        locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY

        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
            == PackageManager.PERMISSION_GRANTED
        ) {

            mFusedLocationClient.requestLocationUpdates(
                locationRequest,
                fusedLocationCallback,
                Looper.myLooper()!!
            )
        }
    }

    private fun startCustomBalancedhGoogleLocationService() {
        val mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        val locationRequest = LocationRequest()
        locationRequest.interval = 30000 // two minute interval

        locationRequest.fastestInterval = 30000
        locationRequest.priority = LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY

        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
            == PackageManager.PERMISSION_GRANTED
        ) {
            mFusedLocationClient.requestLocationUpdates(
                locationRequest,
                balancedLocationCallback,
                Looper.myLooper()!!
            )
        }
    }

    private fun startNormalLocationService() {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            locationManager.requestLocationUpdates(
                LocationManager.NETWORK_PROVIDER,
                1,
                1f,
                locationListener
            )

            locationManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                1,
                1f,
                locationListener
            )
        }
    }

    private fun startGoogleLocationService() {
        val fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        val locationHandler = Handler()
        val locationRunnable: Runnable = object : Runnable {
            @SuppressLint("MissingPermission")
            @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
            override fun run() {
                fusedLocationClient.lastLocation.addOnSuccessListener { location : Location? ->
                    if(location == null) {
                        if (mEngine != null) {
                            MethodChannel(mEngine!!.dartExecutor.binaryMessenger, LOCATION_CHANNEL).invokeMethod("log", "fused location not found")
                        }
                        return@addOnSuccessListener
                    }

                    val tracker = Tracker(location.longitude, location.latitude, location.time, location.altitude, "google", location.bearing, location.accuracy, location.speed, location.provider)

                    val json = Gson().toJson(tracker)

                    if (mEngine != null) {
                        MethodChannel(mEngine!!.dartExecutor.binaryMessenger, LOCATION_CHANNEL).invokeMethod("save", json)
                    }
                }

                locationHandler.postDelayed(this, 1000 * 60)
            }
        }

        locationHandler.postDelayed(locationRunnable, 1000 * 60)
    }

    private fun startLocationService() {
        if(checkGMS()) {
            startCustomHighGoogleLocationService()
            startCustomBalancedhGoogleLocationService()
            startNormalLocationService()
        }
    }

    private fun checkGMS():Boolean {
        val gApi = GoogleApiAvailability.getInstance()
        val resultCode = gApi.isGooglePlayServicesAvailable(this)
        return resultCode ==
                com.google.android.gms.common.ConnectionResult.SUCCESS
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }


    private fun stopForegroundService() {
        stopForeground(true)
        stopSelf()
    }

    override fun onFlutterActivityCreated() {
        stopFlutterNativeView()
    }

    override fun onFlutterActivityDestroyed() {
        startFlutterNativeView()
    }

    private fun startFlutterNativeView() {
        Log.i("BackgroundService", "Starting FlutterEngine")
        initCallBackHandle()
    }

    private fun initCallBackHandle() {
        mEngine = FlutterEngine(this).also { engine ->

            engine.dartExecutor.executeDartCallback(
                    DartExecutor.DartCallback(
                            assets,
                            FlutterMain.findAppBundlePath(),
                            FlutterCallbackInformation.lookupCallbackInformation(getCallbackRawHandle()!!)
                    )
            )

            MethodChannel(engine.dartExecutor.binaryMessenger, DEVICE_CHANNEL).setMethodCallHandler { call, result ->

                when (call.method) {
                    "getDeviceInfo" -> {
                        result.success(getDeviceInfo())
                    }
                    "getBatteryLevel" -> {
                        result.success(getCurrentBatteryLevel())
                    }
                    "getCurrentLocation" -> {
                        result.success(getLastKnownLocation())
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }
    }

    @SuppressLint("HardwareIds")
    private fun getDeviceInfo(): String {
        val secureId: String = Settings.Secure.getString(this.contentResolver,
                Settings.Secure.ANDROID_ID)
        val device = Device(Build.DEVICE, System.getProperty("os.version").toString(), Build.PRODUCT, Build.MODEL, Build.BRAND, Build.ID, secureId, Build.VERSION.SDK_INT.toString())

        return Gson().toJson(device)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun getCurrentBatteryLevel(): Int {
        val bm = applicationContext.getSystemService(BATTERY_SERVICE) as BatteryManager
        return bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun getLastKnownLocation(): DoubleArray {
        val locationManager: LocationManager = applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val providers: List<String> = locationManager.getProviders(true)
        var location: Location? = null
        for (i in providers.size - 1 downTo 0) {
            location= locationManager.getLastKnownLocation(providers[i])
            if (location != null)
                break
        }

        val gps = DoubleArray(2)
        return if (location != null) {
            gps[0] = location.latitude
            gps[1] = location.longitude
            gps
        }else {
            gps
        }
    }

    private fun stopFlutterNativeView() {
        Log.i("BackgroundService", "Stopping FlutterEngine")
//        mEngine?.destroy()
//        mEngine = null
    }

    private fun getCallbackRawHandle(): Long? {
        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        val callbackRawHandle = prefs.getLong(KEY_CALLBACK_RAW_HANDLE, -1)
        return if (callbackRawHandle != -1L) callbackRawHandle else null
    }

    private fun setCallbackRawHandle(handle: Long) {
        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        prefs.edit().putLong(KEY_CALLBACK_RAW_HANDLE, handle).apply()
    }

    companion object {
        private const val KEY_CALLBACK_RAW_HANDLE = "callbackRawHandle"
        const val KEY_SENSOR = "usedSensor"

        const val SHARED_PREFERENCES_SENSOR = "com.cbs.sensor"

        //private const val KEY_SYNCING_CALLBACK_RAW_HANDLE = "callbackRawHandle"
        val ACTION_START_FOREGROUND_SERVICE = "ACTION_START_FOREGROUND_SERVICE"
        val ACTION_STOP_FOREGROUND_SERVICE = "ACTION_STOP_FOREGROUND_SERVICE"

        val ACTION_STOP_FUSED = "ACTION_STOP_FUSED"
        val ACTION_STOP_BALANCED = "ACTION_STOP_BALANCED"
        val ACTION_STOP_NORMAL = "ACTION_STOP_NORMAL"

        val USE_FUSED = "USE_FUSED"
        val USE_BALANCED = "USE_BALANCED"
        val USE_NORMAL = "USE_NORMAL"

        val ON_BOOT = "ON_BOOT"

        fun startService(context: Context, callBack: Long) {
            val intent = Intent(context, LocationService::class.java).apply {
                putExtra(KEY_CALLBACK_RAW_HANDLE, callBack)
            }

            ContextCompat.startForegroundService(context, intent)
        }
    }
}