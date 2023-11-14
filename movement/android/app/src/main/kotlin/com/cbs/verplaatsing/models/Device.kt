package com.cbs.verplaatsing.models

import com.google.gson.annotations.SerializedName

data class Device(
        @SerializedName("Device") val device: String,
        @SerializedName("Version") val version: String,
        @SerializedName("Product") val product: String,
        @SerializedName("DeviceModel") val model: String,
        @SerializedName("Brand") val brand: String,
        @SerializedName("AndroidId") val androidId: String,
        @SerializedName("SecureId") val secureId: String,
        @SerializedName("SDK") val sdk: String
)