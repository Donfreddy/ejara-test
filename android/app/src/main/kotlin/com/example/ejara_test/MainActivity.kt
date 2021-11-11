package com.example.ejara_test

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.Log

import com.pusher.pushnotifications.PushNotifications;
import com.pusher.pushnotifications.PushNotificationsInstance


class MainActivity: FlutterActivity() {
  private val channel = "ejara_test"

  private  var instance: PushNotificationsInstance? = null
  private  var instanceId: String? = null

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
      call, result ->
      // Note: this method is invoked on the main thread.
      if(call.method !== "start" && instance == null) {
        result.error("no_instance", "You should must call .start() before anything", null)
        return@setMethodCallHandler
      }

      // Handle method calls 
      when (call.method) {
        "start" -> this.start(result, call.argument<String>("instanceId"))
        "stop" -> this.stop(result)
        "addDeviceInterest" -> this.addDeviceInterest(result, call.arguments<String>())
        "removeDeviceInterest" -> this.removeDeviceInterest(result, call.arguments<String>())
        "getDeviceInterests" -> this.getDeviceInterests(result)
        "setDeviceInterests" -> this.setDeviceInterests(result, call.arguments<List<String>>())
        "clearDeviceInterests" -> this.clearDeviceInterests(result)
        "clearAllState" -> this.clearAllState(result)
        else -> {
          result.notImplemented()
        }
      }
    }
  }

  // Start the push notifications instance
  private fun start(result: Result, newInstanceId: String) {
    try {
      if (instance == null) {
        instance = PushNotifications.start(context, newInstanceId)
        instanceId = newInstanceId
      } else if (instanceId != newInstanceId) {
        return result.error(null, "You should use this library as a Singleton", null)
      }

      Log.i(this.toString(), "Start $newInstanceId")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  // Stop the push notifications instance
  private fun stop(result: Result) {
    try {
      instance?.stop()
      Log.i(this.toString(), "Stop")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  // Add a device interest to the push notifications instance
  private fun addDeviceInterest(result: Result, interest: String) {
    try {
      instance?.addDeviceInterest(interest)
      Log.i(this.toString(), "AddInterest: $interest")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  // Remove a device interest from the push notifications instance
  private fun removeDeviceInterest(result: Result, interest: String) {
    try {
      instance?.removeDeviceInterest(interest)
      Log.i(this.toString(), "RemoveInterest: $interest")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  // Get list of device interests from the push notifications instance
  private fun getDeviceInterests(result: Result) {
    try {
      val interests = instance?.getDeviceInterests();
      Log.i(this.toString(), "GetInterests: ${interests.toString()}")

      result.success(interests?.toList())
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  // Set device interest from the push notifications instance
  private fun setDeviceInterests(result: Result, interests: List<String>) {
    try {
      instance?.setDeviceInterests(interests.toSet());
      Log.i(this.toString(), "SetInterests: ${interests.toString()}")

      result.success(interests.toList())
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  // Clear device interests from the push notifications instance
  private fun clearDeviceInterests(result: Result) {
    try {
      instance?.clearDeviceInterests()
      Log.i(this.toString(), "ClearInterests")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }

  // Clear all device interests from the push notifications instance
  private fun clearAllState(result: Result) {
    try {
      instance?.clearAllState()
      Log.i(this.toString(), "ClearAllState")

      result.success(null)
    } catch (e : Exception) {
      result.error(null, e.message, null)
    }
  }
}
