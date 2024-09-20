package com.example.wesplit

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.FilterChip
import androidx.compose.material3.InputChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
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

    @Preview(showBackground = true, showSystemUi = true)
    @Composable
    fun ContentView() {
        var checkAmountString by remember { mutableStateOf("") }
        val checkAmount = checkAmountString.let {
            if (checkAmountString.isEmpty()) 0f else checkAmountString
                .replace(",", ".")
                .toFloat()
        }
        var people by remember { mutableIntStateOf(4) }
        var tipPercentage by remember { mutableIntStateOf(10) }

        val tipAmount = checkAmount / 100 * tipPercentage
        val totalAmount = (checkAmount + tipAmount)

        val perPersonAmount = totalAmount / people

        WeSplitTheme {
            Scaffold(
                topBar = {
                    Text(
                        "Делись",
                        style = MaterialTheme.typography.headlineLarge,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier
                            .padding(start = 16.dp, top = 50.dp, bottom = 16.dp)
                    )
                }
            ) { scaffoldPadding ->
                Column(
                    verticalArrangement = Arrangement.spacedBy(30.dp),
                    modifier = Modifier
                        .padding(scaffoldPadding)
                        .padding(horizontal = 16.dp)
                ) {
                    TextField(
                        checkAmountString,
                        label = { Text("Сумма") },
                        prefix = { Text("₽") },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
                        onValueChange = { checkAmountString = it },
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(bottom = 10.dp)
                    )

                    PeopleAmountMenu(people, onChanged = { people = it })
                    PercentageSelector(tipPercentage, onClick = { tipPercentage = it })

                    SumLabel("Общая сумма", totalAmount)
                    SumLabel("Сумма с человека", perPersonAmount)

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
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            DescriptionLabel("Количество человек")

            Box {
                Button(toggleDropdown) {
                    Text("$people")
                }

                DropdownMenu(
                    expanded = peopleDropdownOpen,
                    onDismissRequest = toggleDropdown,
                    modifier = Modifier.height((dropDownItemHeight.toFloat() * 7.5f).dp)
                ) {
                    for (i in 2..100) {
                        DropdownMenuItem(
                            text = { Text(i.toString()) },
                            contentPadding = PaddingValues(vertical = 0.dp, horizontal = 10.dp),
                            onClick = {
                                onChanged(i)
                                toggleDropdown()
                            },
                            modifier = Modifier
                                .height(dropDownItemHeight.dp)
                        )
                    }
                }
            }
        }
    }

    @Composable
    fun PercentageSelector(selectedPercentage: Int, onClick: (Int) -> Unit) {
        var customPercentage by remember { mutableIntStateOf(-1) }
        var percentageDropDownOpen by remember { mutableStateOf(false) }
        val availablePercentages = listOf(5, 10, 15, 20, 0)
        val toggleDropDown = { percentageDropDownOpen = !percentageDropDownOpen }
        val percentageDropDownItemHeight = 40.dp

        Column(
            verticalArrangement = Arrangement.spacedBy(10.dp),
            modifier = Modifier.fillMaxWidth()
        ) {
            DescriptionLabel("Сколько оставить на чай?")

            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                for (percentage in availablePercentages) {
                    FilterChip(
                        label = { Text("${percentage}%") },
                        selected = selectedPercentage == percentage && customPercentage < 0,
                        onClick = {
                            customPercentage = -1
                            onClick(percentage)
                        }
                    )
                }
                Box {
                    InputChip(
                        selected = selectedPercentage == customPercentage,
                        onClick = { toggleDropDown() },
                        label = {
                            if (customPercentage == -1) Text("Свой") else Text("$customPercentage%")
                        }
                    )
                    DropdownMenu(
                        expanded = percentageDropDownOpen,
                        onDismissRequest = { toggleDropDown() },
                        modifier = Modifier
                            .height(percentageDropDownItemHeight * 7)
                    ) {
                        for (percent in 1..100) {
                            DropdownMenuItem(
                                text = { Text("$percent%") },
                                modifier = Modifier.height(percentageDropDownItemHeight),
                                onClick = {
                                    customPercentage = percent
                                    toggleDropDown()
                                    onClick(customPercentage)
                                }
                            )
                        }
                    }
                }
            }
        }
    }

    @Composable
    fun DescriptionLabel(
        text: String,
        style: TextStyle = MaterialTheme.typography.labelMedium,
        fontWeight: FontWeight = FontWeight.SemiBold,
        color: Color = Color.Gray
    ) {
        Text(
            text,
            style = style,
            fontWeight = fontWeight,
            color = color
        )
    }

    @Composable
    fun SumLabel(description: String, value: Float, modifier: Modifier = Modifier) {
        Column(verticalArrangement = Arrangement.spacedBy(10.dp), modifier = modifier) {
            DescriptionLabel(description)

            Row(verticalAlignment = Alignment.Bottom) {
                Text(
                    value.toString(),
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(end = 5.dp)
                )
                Text("₽", color = Color.Gray)
            }
        }
    }
}