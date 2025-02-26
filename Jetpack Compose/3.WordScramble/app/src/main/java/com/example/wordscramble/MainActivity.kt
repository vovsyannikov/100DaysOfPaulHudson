package com.example.wordscramble

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.rounded.Refresh
import androidx.compose.material.icons.rounded.Warning
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.runtime.toMutableStateList
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.wordscramble.ui.theme.BigWord
import com.example.wordscramble.ui.theme.MediumWord
import com.example.wordscramble.ui.theme.SmallWord
import com.example.wordscramble.ui.theme.WordScrambleTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            WordScrambleTheme {
                ContentView()
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ContentView() {
    var allWords = remember { mutableStateListOf<String>() }
    var rootWord by remember { mutableStateOf("") }
    var newWord by remember { mutableStateOf("") }
    val usedWords = remember { mutableStateListOf<String>() }

    var showError by remember { mutableStateOf(false) }
    var errorTitle by remember { mutableStateOf("") }
    var errorText by remember { mutableStateOf("") }

    //region Actions
    fun isWord(word: String): Boolean = word.count() > 1
    fun isOriginal(word: String): Boolean = !usedWords.contains(word)
    fun isPossible(word: String): Boolean {
        var tempWord = rootWord

        for (letter in word) {
            val letterIndex = tempWord.indexOf(letter)
            if (letterIndex == -1) return false

            tempWord = StringBuilder(tempWord).deleteCharAt(letterIndex).toString()
        }

        return true
    }

    fun wordError(title: String, text: String) {
        errorTitle = title
        errorText = text
        showError = true
    }

    fun addNewWord() {
        val answer = newWord.lowercase().trim()

        if (!isWord(answer)) {
            wordError("Too short", "Find a word at least 2 letters long")
            return
        }

        if (!isOriginal(answer)) {
            wordError("Word already used", "Be more original!")
            return
        }

        if (!isPossible(answer)) {
            wordError("Word not possible", "You can't spell '$answer' from $rootWord")
            return
        }

        usedWords.add(0, answer)
        newWord = ""
    }

    fun restartGame() {
        rootWord = allWords.random()
        usedWords.clear()
    }
    //endregion

    val colorScheme = MaterialTheme.colorScheme

    val context = LocalContext.current
    LaunchedEffect(true) {
        DataLoader(this, context)
            .loadData(
                "start.txt",
                onSuccess = {
                    allWords = it.split("\n").toMutableStateList()
                    rootWord = allWords.random()
                },
                onFailure = {
                    rootWord = "No words Found"
                }
            )
    }

    // region MainView
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(rootWord, fontWeight = FontWeight.Bold) },
                actions = {
                    TextButton(onClick = ::restartGame) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.spacedBy(10.dp)
                        ) {
                            Icon(Icons.Rounded.Refresh, contentDescription = "Refresh")
                            Text("Refresh")
                        }
                    }
                }
            )
        }
    ) { innerPadding ->
        Column(
            verticalArrangement = Arrangement.spacedBy(30.dp, alignment = Alignment.CenterVertically),
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 15.dp)
        ) {
            TextField(
                newWord,
                placeholder = { Text("Enter new word", color = Color.Gray) },
                trailingIcon = {
                    IconButton(onClick = ::addNewWord) {
                        Icon(Icons.Default.Add, contentDescription = "Add")
                    }
                },
                keyboardActions = KeyboardActions(onDone = { addNewWord() }),
                keyboardOptions = KeyboardOptions(
                    imeAction = ImeAction.Done
                ),
                maxLines = 1,
                onValueChange = { newWord = it },
                modifier = Modifier
                    .fillMaxWidth()
                    .shadow(10.dp)
            )

            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(15.dp),
                modifier = Modifier
                    .fillMaxSize()
            ) {
                items(usedWords, key = { it }) { word ->
                    val color = when (word.length) {
                        in 2..3 -> SmallWord
                        in 4..5 -> MediumWord
                        else -> BigWord
                    }

                    Card(
                        elevation = CardDefaults.elevatedCardElevation(defaultElevation = 5.dp),
                        colors = CardDefaults.cardColors(
                            containerColor = color,
                        ),
                        modifier = Modifier
                            .fillMaxWidth()
                            .animateItem()
                    ) {
                        Row(
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier
                                .fillMaxSize()
                                .padding(horizontal = 15.dp, vertical = 10.dp)
                        ) {
                            Text(
                                word,
                                textAlign = TextAlign.Start,
                                fontWeight = FontWeight.SemiBold,
                                color = colorScheme.onPrimaryContainer
                            )

                            Text(
                                word.count().toString(),
                                fontWeight = FontWeight.Bold,
                                color = colorScheme.onPrimaryContainer,
                                modifier = Modifier
                                    .border(
                                        2.dp,
                                        color = colorScheme.onPrimaryContainer,
                                        shape = CircleShape
                                    )
                                    .padding(horizontal = 7.dp)
                            )
                        }
                    }
                }
            }
        }
        // endregion

        //region Alert
        if (showError) {
            AlertDialog(
                title = { Text(errorTitle) },
                text = { Text(errorText) },
                onDismissRequest = { showError = false },
                containerColor = colorScheme.errorContainer,
                titleContentColor = colorScheme.onErrorContainer,
                textContentColor = colorScheme.onErrorContainer,
                iconContentColor = colorScheme.error,
                icon = { Icon(Icons.Rounded.Warning, contentDescription = null) },
                confirmButton = {
                    Button(
                        onClick = { showError = false },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = colorScheme.error,
                            contentColor = colorScheme.onError
                        ),
                        content = {
                            Text("Ok")
                        }
                    )
                }
            )
        }
        //endregion
    }
}

@Preview
@Composable
fun GreetingPreview() {
    WordScrambleTheme {
        ContentView()
    }
}