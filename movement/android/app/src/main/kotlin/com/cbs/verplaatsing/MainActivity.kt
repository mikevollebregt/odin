package com.cbs.verplaatsing

import android.Manifest.permission.ACCESS_COARSE_LOCATION
import android.Manifest.permission.ACCESS_FINE_LOCATION
import android.annotation.SuppressLint
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.os.BatteryManager
import android.os.Build
import com.google.gson.Gson
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import com.cbs.verplaatsing.models.Device
import com.cbs.verplaatsing.services.LocationService
import com.cbs.verplaatsing.App
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val DEVICE_CHANNEL = "com.example.flutter/device_info"
    private val LOCATION_CHANNEL = "com.example.flutter/location_info"
    private val FOREGROUNDSERVICE_CHANNEL = "com.example.flutter/foreground_service"
    private val SHARED_PREFERENCES_SENSOR = "com.cbs.sensor"
    private val KEY_COMPLETED = "KEY_COMPLETED"
    private var mCallback = 0L

    companion object {
        var mFlutterEngine: FlutterEngine? = null
        var This: MainActivity? = null
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        This = this
        mFlutterEngine = flutterEngine

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_CHANNEL).setMethodCallHandler { call, result ->

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
                "getPermission" -> {
                    if (ActivityCompat.checkSelfPermission(this, ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                        makeRequest()
                    }
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FOREGROUNDSERVICE_CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "startForegroundService") {
                if (ActivityCompat.checkSelfPermission(this, ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    makeRequest()
                } else {
                    This = this
                    val serviceIntent = Intent(this, LocationService::class.java)
                    startForegroundService(serviceIntent)
                }
            } else if (call.method == "stopForegroundService") {
                val stopIntent = Intent(this, LocationService::class.java)
                stopIntent.action = LocationService.ACTION_STOP_FOREGROUND_SERVICE
                startForegroundService(stopIntent)
            } else if (call.method == "isForegroundServiceRunning") {
                val isRunning = isServiceRunningInForeground(context, LocationService::class.java)
                result.success(isRunning)
            } else if (call.method == "stopFused") {
                val stopIntent = Intent(this, LocationService::class.java)
                stopIntent.action = LocationService.ACTION_STOP_FUSED
                startForegroundService(stopIntent)
                result.success(true)
            } else if (call.method == "stopBalanced") {
                val stopIntent = Intent(this, LocationService::class.java)
                stopIntent.action = LocationService.ACTION_STOP_BALANCED
                startForegroundService(stopIntent)
                result.success(true)
            } else if (call.method == "stopNormal") {
                val stopIntent = Intent(this, LocationService::class.java)
                stopIntent.action = LocationService.ACTION_STOP_NORMAL
                startForegroundService(stopIntent)
                result.success(true)
            } else if (call.method == "useNormal") {
                val stopIntent = Intent(this, LocationService::class.java)
                stopIntent.action = LocationService.USE_NORMAL
                startForegroundService(stopIntent)
                result.success(true)
            }else if (call.method == "useFused") {
                val stopIntent = Intent(this, LocationService::class.java)
                stopIntent.action = LocationService.USE_FUSED
                startForegroundService(stopIntent)
                result.success(true)
            }else if (call.method == "useBalanced") {
                val stopIntent = Intent(this, LocationService::class.java)
                stopIntent.action = LocationService.USE_BALANCED
                startForegroundService(stopIntent)
                result.success(true)
            }else if (call.method == "weekCompleted") {
                // val stopIntent = Intent(this, LocationService::class.java)
                // stopIntent.action = LocationService.ACTION_STOP_FOREGROUND_SERVICE
                // startForegroundService(stopIntent)
                val prefs = getSharedPreferences(SHARED_PREFERENCES_SENSOR, Context.MODE_PRIVATE)
                prefs.edit().putBoolean(KEY_COMPLETED, true).apply()
                result.success(true)
            }else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example/app_retain").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "sendToBackground") {
                    moveTaskToBack(true)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example/background_service").setMethodCallHandler { method, result ->
            if (method.method == "startService") {
                if (ActivityCompat.checkSelfPermission(this, ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                    mCallback = method.arguments as Long
                    makeRequest()
                } else {
                    This = this
                    val callBack =  method.arguments as Long
                    LocationService.startService(this@MainActivity, callBack)
                    result.success(null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun getCurrentBatteryLevel(): Int {
        val bm = applicationContext.getSystemService(BATTERY_SERVICE) as BatteryManager
        return bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun getLastKnownLocation(): DoubleArray {
        val locationManager: LocationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
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

    private fun isServiceRunningInForeground(context: Context, serviceClass: Class<*>): Boolean {
        val manager: ActivityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return service.foreground
            }
        }
        return false
    }

    @SuppressLint("HardwareIds")
    private fun getDeviceInfo(): String {
        val device = Device(Build.DEVICE, System.getProperty("os.version").toString(), Build.PRODUCT, Build.MODEL, Build.BRAND, Build.ID, "0000", Build.VERSION.SDK_INT.toString())

        return Gson().toJson(device)
    }

    private fun makeRequest() {
        ActivityCompat.requestPermissions(this,
                arrayOf(ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION),
                PackageManager.PERMISSION_GRANTED)
    }

}
