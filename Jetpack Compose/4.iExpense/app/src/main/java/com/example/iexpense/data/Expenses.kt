package com.example.iexpense.data

import androidx.compose.runtime.mutableStateListOf
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.serialization.SerializationException
import kotlinx.serialization.json.Json

class Expenses(
    private val dataStore: DataStore<Preferences>
): ViewModel() {
    private var _items = mutableStateListOf<ExpenseItem>()
    val items = _items

    init {
        viewModelScope.launch {
            val data = dataStore.data.first()

            try {
                val itemsString = data[DataStoreKeys.ITEMS] ?: return@launch
                val items: List<ExpenseItem> = Json.decodeFromString(itemsString)
                _items.addAll(items)
            } catch (e: SerializationException) {
                println(e.message)
            }
        }
    }

    fun addExpenseItem(expenseItem: ExpenseItem) {
        items.add(expenseItem)

        saveToDataStore()
    }

    fun removeItem(item: ExpenseItem) {
        _items.remove(item)

        saveToDataStore()
    }

    private fun saveToDataStore() {
        viewModelScope.launch {
            dataStore.edit {
                val encoded = Json.encodeToString(items.toList())
                it[DataStoreKeys.ITEMS] = encoded
            }
        }
    }
}


