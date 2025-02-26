package com.example.wordscramble

import android.content.Context
import kotlinx.coroutines.CoroutineScope

data class DataLoader(val scope: CoroutineScope, val context: Context) {
    fun loadData(file: String, onSuccess: (String) -> Unit, onFailure: () -> Unit) {
        scope
            .runCatching {
                val inputStream = context.assets.open(file)
                val size = inputStream.available()
                val buffer = ByteArray(size)
                inputStream.read(buffer)
                String(buffer)
            }
            .onSuccess { onSuccess(it) }
            .onFailure { onFailure() }
    }
}