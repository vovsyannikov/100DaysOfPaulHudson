package com.example.wesplit

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.BottomAppBarDefaults
import androidx.compose.material3.Button
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.wesplit.ui.theme.WeSplitTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            ContentView()
        }
    }

    @OptIn(ExperimentalMaterial3Api::class)
    @Preview(showBackground = true, showSystemUi = true)
    @Composable
    fun ContentView() {
        var checkAmount by remember { mutableFloatStateOf(0f) }
        var people by remember { mutableIntStateOf(4) }
        var tipPercentage by remember { mutableIntStateOf(10) }

        val tipAmount = checkAmount / 100 * tipPercentage
        val totalAmount = (checkAmount + tipAmount)

        val perPersonAmount = totalAmount / people.toFloat()

        WeSplitTheme {
            Scaffold(
                topBar = {
                    TopAppBar(
                        title = {
                            Text(
                                "WeSplit",
                                style = MaterialTheme.typography.headlineLarge,
                                fontWeight = FontWeight.Bold,
                                modifier = Modifier.padding(20.dp)
                            )
                        }
                    )
                },
                bottomBar = {
                    BottomAppBar {
                        Column {
                            Text(
                                "Per Person: $perPersonAmount",
                                style = MaterialTheme.typography.titleLarge,
                                fontWeight = FontWeight.SemiBold
                            )
                            Text("Total amount is $totalAmount")
                        }
                    }
                }
            ) { scaffoldPadding ->
                Column(
                    verticalArrangement = Arrangement.Center,
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier
                        .padding(scaffoldPadding)
                        .padding(horizontal = 20.dp)
                ) {
                    TextField(
                        checkAmount.toString(),
                        label = { Text("Check amount") },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
                        onValueChange = { checkAmount = it.toFloat() },
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(bottom = 10.dp)
                    )

                    PeopleAmountMenu(people = people, onChanged = { people = it })
                    HorizontalDivider(modifier = Modifier.padding(vertical = 10.dp))
                    PercentageSelector(tipPercentage, onClick = { tipPercentage = it })
                }
            }
        }
    }

    @Composable
    fun PeopleAmountMenu(people: Int, onChanged: (Int) -> Unit) {
        var peopleDropdownOpen by remember { mutableStateOf(false) }
        val toggleDropdown = { peopleDropdownOpen = !peopleDropdownOpen }
        val dropDownItemHeight = 40

        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                "Amount of people",
                style = MaterialTheme.typography.labelMedium,
                color = Color.Gray
            )

            Box {
                Button(toggleDropdown) {
                    Text("$people people")
                }

                DropdownMenu(
                    expanded = peopleDropdownOpen,
                    onDismissRequest = toggleDropdown,
                    modifier = Modifier.height((dropDownItemHeight.toFloat() * 7f).dp)
                ) {
                    for (i in 2..100) {
                        DropdownMenuItem(
                            text = { Text(i.toString()) },
                            onClick = {
                                onChanged(i)
                                toggleDropdown()
                            },
                            modifier = Modifier.height(dropDownItemHeight.dp)
                        )
                    }
                }
            }
        }
    }

    @Composable
    fun PercentageSelector(selectedPercentage: Int, onClick: (Int) -> Unit) {
        val availablePercentages = listOf(5, 10, 15, 20, 0)

        Column(
            horizontalAlignment = Alignment.Start,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                "How much money would you like to tip?",
                style = MaterialTheme.typography.labelLarge,
                color = Color.Gray
            )

            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                for (percentage in availablePercentages) {
                    FilterChip(
                        label = {
                            Text(
                                "${percentage}%",
                                style = MaterialTheme.typography.bodyMedium
                            )
                        },
                        selected = selectedPercentage == percentage,
                        onClick = { onClick(percentage) },
                        modifier = Modifier.padding(horizontal = 5.dp, vertical = 10.dp)
                    )
                }
            }
        }
    }
}