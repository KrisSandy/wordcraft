import 'dart:math';

class Utils {
  static List<String> getRandomWords(List<String> words, int count) {
    final random = Random();
    return List<String>.generate(
        count, (_) => words[random.nextInt(words.length)]);
  }

  static void removeWords(List<String> words, List<String> wordsToRemove) {
    words.removeWhere((word) => wordsToRemove.contains(word));
  }

  static String capitalizeFirstWord(String word) {
    word = word[0].toUpperCase() + word.substring(1);
    return word;
  }

  static List<String> mergeAndSortLists(List<List<String>> listOfLists) {
    final mergedList = listOfLists.expand((list) => list).toList();
    mergedList.sort((a, b) => a.compareTo(b));
    return mergedList;
  }
}
