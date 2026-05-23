package com.lockbox.sdk.core

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Android Secure Storage Core (Lockbox).
 * Protects string data using AES-GCM-NoPadding backed by the Android KeyStore.
 */
class Lockbox private constructor() {

    companion object {
        private const val PROVIDER = "AndroidKeyStore"
        private const val KEY_ALIAS = "LockboxMasterKey"
        private const val TRANSFORMATION = "AES/GCM/NoPadding"
        private const val PREFS_NAME = "LockboxPrefs"
        private const val IV_SIZE_BITS = 128

        val instance: Lockbox by lazy { Lockbox() }
    }

    private val keyStore: KeyStore = KeyStore.getInstance(PROVIDER).apply { load(null) }

    private fun getOrCreateSecretKey(): SecretKey {
        if (keyStore.containsAlias(KEY_ALIAS)) {
            val entry = keyStore.getEntry(KEY_ALIAS, null) as? KeyStore.SecretKeyEntry
            if (entry != null) {
                return entry.secretKey
            }
        }

        val keyGenerator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, PROVIDER)
        val spec = KeyGenParameterSpec.Builder(
            KEY_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .build()

        keyGenerator.init(spec)
        return keyGenerator.generateKey()
    }

    /**
     * Encrypts and stores a string value under the given key.
     */
    fun saveSecureString(context: Context, key: String, value: String) {
        val secretKey = getOrCreateSecretKey()
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, secretKey)
        
        val iv = cipher.iv
        val encryptedBytes = cipher.doFinal(value.toByteArray(Charsets.UTF_8))

        val ivBase64 = Base64.encodeToString(iv, Base64.NO_WRAP)
        val encryptedBase64 = Base64.encodeToString(encryptedBytes, Base64.NO_WRAP)
        
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit()
            .putString("${key}_iv", ivBase64)
            .putString("${key}_val", encryptedBase64)
            .apply()
    }

    /**
     * Retrieves and decrypts a stored string value. Returns null if key is not found.
     */
    fun getSecureString(context: Context, key: String): String? {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val ivBase64 = prefs.getString("${key}_iv", null) ?: return null
        val encryptedBase64 = prefs.getString("${key}_val", null) ?: return null

        val iv = Base64.decode(ivBase64, Base64.NO_WRAP)
        val encryptedBytes = Base64.decode(encryptedBase64, Base64.NO_WRAP)

        val secretKey = getOrCreateSecretKey()
        val cipher = Cipher.getInstance(TRANSFORMATION)
        val spec = GCMParameterSpec(IV_SIZE_BITS, iv)
        cipher.init(Cipher.DECRYPT_MODE, secretKey, spec)

        val decryptedBytes = cipher.doFinal(encryptedBytes)
        return String(decryptedBytes, Charsets.UTF_8)
    }

    /**
     * Deletes stored secure credentials.
     */
    fun deleteSecureString(context: Context, key: String) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        prefs.edit()
            .remove("${key}_iv")
            .remove("${key}_val")
            .apply()
    }
}
