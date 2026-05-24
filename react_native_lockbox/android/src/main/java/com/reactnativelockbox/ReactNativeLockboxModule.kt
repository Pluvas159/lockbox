package com.reactnativelockbox

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Promise
import com.lockbox.sdk.core.Lockbox

class ReactNativeLockboxModule(reactContext: ReactApplicationContext) :
  NativeReactNativeLockboxSpec(reactContext) {

  override fun saveSecureString(key: String, value: String, promise: Promise) {
    try {
      Lockbox.instance.saveSecureString(reactApplicationContext, key, value)
      promise.resolve(true)
    } catch (e: Exception) {
      promise.resolve(false)
    }
  }

  override fun getSecureString(key: String, promise: Promise) {
    try {
      val value = Lockbox.instance.getSecureString(reactApplicationContext, key)
      promise.resolve(value)
    } catch (e: Exception) {
      promise.resolve(null)
    }
  }

  override fun deleteSecureString(key: String, promise: Promise) {
    try {
      Lockbox.instance.deleteSecureString(reactApplicationContext, key)
      promise.resolve(true)
    } catch (e: Exception) {
      promise.resolve(false)
    }
  }

  companion object {
    const val NAME = NativeReactNativeLockboxSpec.NAME
  }
}
