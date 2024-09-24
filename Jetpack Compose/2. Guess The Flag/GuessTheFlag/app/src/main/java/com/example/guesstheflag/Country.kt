package com.example.guesstheflag

data class Country(val name: String, val resourceID: Int) {
    val flagDescription: String
        get ()  {
            when(resourceID) {
                R.drawable.estonia -> return ""
                R.drawable.uk -> return ""
                else -> return ""
            }
        }
}