package me.royrao.supportFiles.extensions

fun String.isNumeric() : Boolean {
    val regex = """^(-)?[0-9]*((\.)[0-9]+)?$""".toRegex()
    return if (this.isBlank()) false else regex.matches(this)
}