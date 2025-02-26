package com.example.iexpense

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.ElevatedFilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.example.iexpense.data.ExpenseItem
import com.example.iexpense.data.ExpenseType
import com.example.iexpense.data.Expenses
import java.text.NumberFormat

@Composable
fun AddView(
    expenses: Expenses,
    onAddExpenseItem: () -> Unit,
    modifier: Modifier = Modifier
) {
    var name by remember { mutableStateOf("") }
    var type by remember { mutableStateOf(ExpenseType.PERSONAL) }
    var amount by remember { mutableStateOf("") }

    Column(
        verticalArrangement = Arrangement.spacedBy(30.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = modifier
            .padding(horizontal = 16.dp)
            .padding(bottom = 30.dp)
    ) {
        Text(
            "Add new expense",
            style = MaterialTheme.typography.titleMedium
        )

        TextField(
            value = name,
            label = { Text("Name") },
            onValueChange = { name = it },
            modifier = Modifier
                .fillMaxWidth()
        )

        Card {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(15.dp)
            ) {
                Text("Expense type")
                Row(
                    horizontalArrangement = Arrangement.spacedBy(10.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                ) {
                    ExpenseType.entries.forEach {
                        ElevatedFilterChip(
                            selected = type == it,
                            label = { Text(it.displayName) },
                            onClick = { type = it },
                            colors = FilterChipDefaults.elevatedFilterChipColors(
                                selectedContainerColor = MaterialTheme.colorScheme.primary,
                                selectedLabelColor = MaterialTheme.colorScheme.onPrimary
                            )
                        )
                    }
                }
            }
        }

        TextField(
            value = amount,
            onValueChange = { amount = it },
            label = { Text("Amount") },
            leadingIcon = {
                Text(NumberFormat.getCurrencyInstance().currency?.symbol ?: "$")
            },
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Decimal
            ),
            modifier = Modifier.fillMaxWidth()
        )

        Button(
            onClick = {
                val expensesItem = ExpenseItem(
                    name = name,
                    type = type,
                    amount = amount.toFloatOrNull() ?: 0f
                )

                expenses.addExpenseItem(expensesItem)

                onAddExpenseItem()
            }
        ) {
            Text("Save")
        }
    }
}