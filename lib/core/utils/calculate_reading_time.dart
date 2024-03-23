int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;

  final readingTime = wordCount / 225;

  return readingTime.ceil();
}


// here we are counting the total time to read a particular blogs
// split(RegExp(r'\s+')) it split content when find blank space and new lines