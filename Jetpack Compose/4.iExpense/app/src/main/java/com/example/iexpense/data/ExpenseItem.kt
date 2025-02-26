package com.example.iexpense.data

import androidx.compose.runtime.Immutable
import kotlinx.serialization.Serializable
import java.text.NumberFormat
import java.util.Locale
import java.util.UUID

@Immutable
@Serializable
data class ExpenseItem(
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val type: ExpenseType = ExpenseType.PERSONAL,
    val amount: Float
) {
    val formattedAmount: String
        get() {
            val locale = Locale.getDefault()
            val formatter = NumberFormat.getCurrencyInstance(locale)

            return formatter.format(amount)
        }

    val formattedType: String
        get() = type.displayName
}

enum class ExpenseType {
    PERSONAL, BUSINESS;

    val displayName = name.lowercase().replaceFirstChar { it.uppercase() }
}