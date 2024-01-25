import 'package:flutter/material.dart';
import 'package:wordcraft/screens/word.dart';

class WordList extends StatelessWidget {
  const WordList({
    super.key,
    required this.words,
  });

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: words.length,
      padding: const EdgeInsets.all(8),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.withOpacity(0.5),
      ),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            words[index],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7)),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordPage(word: words[index]),
              ),
            );
          },
        );
      },
    );
  }
}
