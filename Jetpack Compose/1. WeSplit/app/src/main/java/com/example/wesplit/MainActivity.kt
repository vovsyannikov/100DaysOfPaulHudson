package com.example.wesplit

import android.icu.text.DecimalFormat
import android.icu.util.Currency
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.Button
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ElevatedFilterChip
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.InputChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.wesplit.ui.theme.WeSplitTheme
import java.math.RoundingMode.*
import java.util.Locale

@OptIn(ExperimentalMaterial3Api::class)
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            WeSplitTheme {
                Scaffold(
                    topBar = {
                        TopAppBar(
                            title = { Text("WeSplit", fontWeight = FontWeight.Bold) }
                        )
                    }
                ) { innerPadding ->
                    ContentView(modifier = Modifier.padding(innerPadding))
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ContentView(modifier: Modifier = Modifier) {
    var checkAmountString by remember { mutableStateOf("") }
    var numberOfPeople by remember { mutableIntStateOf(4) }
    var tipPercentage by remember { mutableIntStateOf(20) }

    var choosingNumberOfPeople by remember { mutableStateOf(false) }

    val tipPercentages = listOf(10, 15, 20, 25, 0)

    val currency = Currency.getInstance(Locale.getDefault())

    val checkAmount = checkAmountString.replace(',', '.').toDoubleOrNull() ?: 0.0
    val peopleCount = numberOfPeople.toDouble()
    val tipSelection = tipPercentage.toDouble()
    val tipValue = checkAmount / 100 * tipSelection
    val grandTotal = checkAmount + tipValue
    val totalPerPerson = grandTotal / peopleCount
    val decimalFormatter = DecimalFormat("#.##")
    decimalFormatter.currency = currency
    decimalFormatter.roundingMode = DOWN.ordinal
    val finalValue = decimalFormatter.format(totalPerPerson)

    Column(
        verticalArrangement = Arrangement.spacedBy(15.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = modifier
            .fillMaxSize()
            .padding(horizontal = 15.dp)
    ) {
        TextField(
            checkAmountString,
            onValueChange = { checkAmountString = it },
            label = { Text("Amount") },
            leadingIcon = { Text(currency.symbol) },
            maxLines = 1,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
            modifier = Modifier
                .fillMaxWidth()
        )

        ExposedDropdownMenuBox(
            choosingNumberOfPeople,
            onExpandedChange = { choosingNumberOfPeople = it }
        ) {
            OutlinedTextField(
                "$numberOfPeople people",
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = choosingNumberOfPeople) },
                colors = ExposedDropdownMenuDefaults.textFieldColors(),
                readOnly = true,
                label = { Text("Number of people") },
                onValueChange = {},
                modifier = Modifier
                    .menuAnchor()
                    .fillMaxWidth()
            )

            ExposedDropdownMenu(expanded = choosingNumberOfPeople,
                onDismissRequest = { choosingNumberOfPeople = false }) {
                for (i in 2..<100) {
                    DropdownMenuItem(
                        text = { Text("$i people") },
                        leadingIcon = {
                            if (i == numberOfPeople) {
                                Icon(Icons.Default.Check, contentDescription = "Selected $i")
                            }
                        },
                        onClick = {
                            choosingNumberOfPeople = false
                            numberOfPeople = i
                        }
                    )
                }
            }
        }

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 30.dp)
        ) {
            Text("How much do you want to tip?")

            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier
                    .fillMaxWidth()
            ) {
                for (percentage in tipPercentages) {
                    ElevatedFilterChip(
                        selected = percentage == tipPercentage,
                        onClick = {
                            tipPercentage = percentage
                        },
                        label = { Text("${percentage}%") }
                    )
                }
            }
        }

        Column(
            modifier = Modifier
                .fillMaxWidth()
        ) {
            Text(
                "Final amount:",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold
            )

            Row{
                Text(
                    "$grandTotal ${currency.symbol} / $numberOfPeople = ",
                    style = MaterialTheme.typography.headlineSmall,
                    color = Color.LightGray,
                    fontStyle = FontStyle.Italic
                )

                Text(
                    "$finalValue ${currency.symbol}",
                    style = MaterialTheme.typography.headlineSmall
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Preview
@Composable
fun WeSplitPreview() {
    WeSplitTheme {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("WeSplit", fontWeight = FontWeight.Bold) }
                )
            }
        ) { innerPadding ->
            ContentView(modifier = Modifier.padding(innerPadding))
        }
    }
}