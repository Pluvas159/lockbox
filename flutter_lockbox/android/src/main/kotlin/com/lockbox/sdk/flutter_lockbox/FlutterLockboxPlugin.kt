package com.lockbox.sdk.flutter_lockbox

import android.content.Context
import com.lockbox.sdk.core.Lockbox
import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * FlutterLockboxPlugin
 * Bridges Flutter Pigeon calls to the native Android Core Lockbox library.
 */
class FlutterLockboxPlugin : FlutterPlugin, LockboxHostApi {

    private var context: Context? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        LockboxHostApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = null
        LockboxHostApi.setUp(binding.binaryMessenger, null)
    }

    // --- LockboxHostApi Implementation ---

    override fun saveSecureString(key: String, value: String): Boolean {
        val currentContext = context ?: return false
        return try {
            Lockbox.instance.saveSecureString(currentContext, key, value)
            true
        } catch (e: Exception) {
            false
        }
    }

    override fun getSecureString(key: String): String? {
        val currentContext = context ?: return null
        return try {
            Lockbox.instance.getSecureString(currentContext, key)
        } catch (e: Exception) {
            null
        }
    }

    override fun deleteSecureString(key: String): Boolean {
        val currentContext = context ?: return false
        return try {
            Lockbox.instance.deleteSecureString(currentContext, key)
            true
        } catch (e: Exception) {
            false
        }
    }
}
