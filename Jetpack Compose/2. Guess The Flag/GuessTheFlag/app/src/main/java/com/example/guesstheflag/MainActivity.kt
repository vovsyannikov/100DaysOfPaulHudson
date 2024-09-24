package com.example.guesstheflag

import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Clear
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.guesstheflag.ui.theme.GuessTheFlagTheme
import kotlinx.coroutines.launch
import kotlin.random.Random
import kotlin.random.nextInt

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            Content()
        }
    }

    @Preview
    @Composable
    fun Content() {
        var countries by remember {
            mutableStateOf(
                listOf(
                    Country("Estonia", R.drawable.estonia),
                    Country("France", R.drawable.france),
                    Country("Germany", R.drawable.germany),
                    Country("Ireland", R.drawable.ireland),
                    Country("Italy", R.drawable.italy),
                    Country("Monaco", R.drawable.monaco),
                    Country("Nigeria", R.drawable.nigeria),
                    Country("Poland", R.drawable.poland),
                    Country("Russia", R.drawable.russia),
                    Country("Spain", R.drawable.spain),
                    Country("UK", R.drawable.uk),
                    Country("US", R.drawable.us)
                ).shuffled()
            )
        }

        var correct by remember { mutableIntStateOf(Random.nextInt(0..2)) }
        var question by remember { mutableIntStateOf(0) }
        var score by remember { mutableIntStateOf(0) }

        var dialogTitle by remember { mutableStateOf("") }
        var dialogMessage by remember { mutableStateOf("") }
        var isShowingDialog by remember { mutableStateOf(false) }
        var gameEnded by remember { mutableStateOf(false) }

        val maxQuestions = 8
        val toggleDialog = { isShowingDialog = !isShowingDialog }

        val updateGame = {
            countries = countries.shuffled()
            correct = Random.nextInt(0..2)
        }

        val clicked: (Int) -> Unit = click@{ index ->
            question++

            if (index == correct) {
                score++
            } else {
                dialogTitle = "Wrong!"
                dialogMessage = "You clicked the flag of ${countries[index].name}"
                toggleDialog()
            }

            if (question == maxQuestions) {
                dialogTitle = "Game Over"
                dialogMessage = "Your score was: $score\nWould you like to start over?"
                gameEnded = true
                toggleDialog()
                return@click
            }

            updateGame()
        }
        val restart = {
            question = 0
            score = 0
            gameEnded = false

            updateGame()
            isShowingDialog = false
        }

        GuessTheFlagTheme {
            Scaffold() { innerPadding ->
                val colorScheme = MaterialTheme.colorScheme
                val textStyle = MaterialTheme.typography

                BoxWithConstraints(
                    contentAlignment = Alignment.TopCenter,
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(innerPadding)
                        .background(colorScheme.primaryContainer)
                ) {

                    val circleColor = colorScheme.primary
                    Canvas(modifier = Modifier) {
                        drawCircle(
                            circleColor,
                            radius = maxHeight.value + 150f,
                        )
                    }

                    Column(
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.fillMaxSize()
                    ) {
                        Text(
                            "Tap the flag of:",
                            color = colorScheme.onPrimary,
                            style = textStyle.bodyLarge,
                            fontWeight = FontWeight.ExtraBold
                        )

                        Text(
                            countries[correct].name,
                            color = colorScheme.onPrimary,
                            style = textStyle.headlineLarge,
                            fontWeight = FontWeight.SemiBold,
                            modifier = Modifier.padding(bottom = 30.dp)
                        )

                        Column(verticalArrangement = Arrangement.spacedBy(30.dp)) {
                            for (i in 0..2) {
                                CountryFlag(countries[i]) { clicked(i) }
                            }
                        }
                    }

                    ScoreLabel(
                        score,
                        modifier = Modifier
                            .fillMaxHeight()
                            .padding(bottom = 30.dp)
                    )
                }

                if (isShowingDialog) {
                    AlertDialog(
                        title = { Text(text = dialogTitle) },
                        text = { Text(text = dialogMessage) },
                        icon = {
                            if (gameEnded) Icons.Default.Star else Icons.Filled.Warning
                        },
                        onDismissRequest = { toggleDialog() },
                        confirmButton = {
                            Button(onClick = {
                                if (gameEnded) restart()
                                else {
                                    updateGame()
                                    toggleDialog()
                                }
                            }) {
                                Text(if (gameEnded) "Restart" else "OK")
                            }
                        },
                        dismissButton = {
                            if (gameEnded) {
                                OutlinedButton(onClick = { toggleDialog() }) {
                                    Text("Cancel")
                                }
                            }
                        }
                    )
                }
            }
        }
    }

    @Composable
    fun ScoreLabel(
        score: Int,
        modifier: Modifier = Modifier
    ) {
        Column(
            verticalArrangement = Arrangement.Bottom,
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = modifier
        ) {
            Text(
                "Score:",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onPrimaryContainer
            )

            Text(
                score.toString(),
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onPrimaryContainer
            )
        }
    }

    @Composable
    private fun CountryFlag(
        country: Country,
        onClick: () -> Unit,
    ) {
        val flagShape = RoundedCornerShape(percent = 50)
        Image(
            contentDescription = country.flagDescription,
            painter = painterResource(country.resourceID),
            modifier = Modifier
                .shadow(5.dp, shape = flagShape)
                .border(2.dp, Color.White, flagShape)
                .clickable { onClick() }
        )
    }
}