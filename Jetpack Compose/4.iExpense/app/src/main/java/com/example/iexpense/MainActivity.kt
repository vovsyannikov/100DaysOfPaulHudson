@file:OptIn(ExperimentalMaterial3Api::class)

package com.example.iexpense

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Add
import androidx.compose.material.icons.outlined.Delete
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxState
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.Stable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.datastore.preferences.preferencesDataStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.iexpense.data.ExpenseItem
import com.example.iexpense.data.Expenses
import com.example.iexpense.ui.theme.Delete
import com.example.iexpense.ui.theme.IExpenseTheme
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@Suppress("UNCHECKED_CAST")
class MainActivity : ComponentActivity() {
    private val dataStore by preferencesDataStore("Expenses")

    private val expenses by viewModels<Expenses>(
        factoryProducer = {
            object : ViewModelProvider.Factory {
                override fun <T : ViewModel> create(modelClass: Class<T>): T {
                    return Expenses(dataStore) as T
                }
            }
        }
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            MainView()
        }
    }

    @Stable
    private fun removeExpenseItem(expenseItem: ExpenseItem) = expenses.removeItem(expenseItem)

    @Preview
    @Composable
    fun MainView() {
        var bottomSheetOpen by remember { mutableStateOf(false) }
        val bottomSheetState = rememberModalBottomSheetState(
            skipPartiallyExpanded = true
        )
        val scope = rememberCoroutineScope()

        IExpenseTheme {
            Scaffold(
                topBar = {
                    TopAppBar(
                        title = {
                            Text(
                                "iExpense",
                                style = MaterialTheme.typography.headlineMedium,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    )
                },
                floatingActionButton = {
                    FloatingActionButton(
                        onClick = { bottomSheetOpen = true },
                        content = { Icon(Icons.Outlined.Add, contentDescription = "Add expense") }
                    )
                }
            ) { innerPadding ->
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(innerPadding)
                ) {
                    items(expenses.items, key = { it.id }) {item ->
                        ExpenseItemView(item)
                    }
                }

                if (bottomSheetOpen) {
                    ModalBottomSheet(
                        sheetState = bottomSheetState,
                        onDismissRequest = { bottomSheetOpen = false }
                    ) {
                        AddView(
                            expenses,
                            onAddExpenseItem = {
                                scope.launch {
                                    bottomSheetState.hide()
                                    delay(300)
                                    bottomSheetOpen = false
                                }
                            }
                        )
                    }
                }
            }
        }
    }

    @Composable
    fun ExpenseItemView(item: ExpenseItem) {
        var isRemoved by remember { mutableStateOf(false) }
        val animationDuration = 500
        val swipeToDismissBoxState = rememberSwipeToDismissBoxState(
            positionalThreshold = { it * 0.25f },
            confirmValueChange = {
                if (it == SwipeToDismissBoxValue.EndToStart) {
                    isRemoved = true
                    true
                } else false
            }
        )

        LaunchedEffect(isRemoved) {
            if (isRemoved) {
                delay(animationDuration.toLong())
                removeExpenseItem(item)
            }
        }

        AnimatedVisibility(
            !isRemoved,
            exit =
            shrinkVertically(
                animationSpec = tween(animationDuration),
                shrinkTowards = Alignment.Top
            ) + fadeOut()
        ) {
            SwipeToDismissBox(
                state = swipeToDismissBoxState,
                enableDismissFromStartToEnd = false,
                backgroundContent = {
                    DeleteBackground(swipeToDismissBoxState)
                },
                content = {
                    ListItem(
                        headlineContent = { Text(item.name, fontWeight = FontWeight.SemiBold) },
                        supportingContent = { Text(item.formattedType) },
                        trailingContent = { Text(item.formattedAmount) }
                    )
                }
            )
        }

        HorizontalDivider(Modifier.fillMaxWidth())
    }

    @Composable
    fun DeleteBackground(swipeState: SwipeToDismissBoxState) {
        val color = when (swipeState.dismissDirection) {
            SwipeToDismissBoxValue.EndToStart -> Color.Delete
            else -> Color.Transparent
        }

        Box(
            contentAlignment = Alignment.CenterEnd,
            modifier = Modifier
                .fillMaxSize()
                .background(color)
                .padding(16.dp)
        ) {
            Icon(
                imageVector = Icons.Outlined.Delete,
                tint = Color.White,
                contentDescription = "Delete expense item"
            )
        }
    }
}