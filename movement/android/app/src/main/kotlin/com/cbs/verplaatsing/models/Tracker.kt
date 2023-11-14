package com.cbs.verplaatsing.models

import com.google.gson.annotations.SerializedName

data class Tracker(
        @SerializedName("lon") var lon: Double,
        @SerializedName("lat") var lat: Double,
        @SerializedName("date") var date: Long,
        @SerializedName("altitude") var altitude: Double,
        @SerializedName("sensorType") var sensorType: String,
        @SerializedName("bearing") var bearing: Float,
        @SerializedName("accuracy") var accuracy: Float,
        @SerializedName("speed") var speed: Float,
        @SerializedName("providers") var providers: String
)