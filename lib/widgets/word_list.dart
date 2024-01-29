import 'package:flutter/material.dart';
import 'package:wordcraft/screens/word.dart';

class ListWord {
  final String word;
  final int status;

  ListWord(this.word, {this.status = 0});

  static void sort(List<ListWord> words) {
    words.sort((a, b) => a.word.compareTo(b.word));
  }

  @override
  String toString() {
    return 'Word: $word, Status: $status';
  }
}

class WordList extends StatefulWidget {
  const WordList({
    super.key,
    required this.words,
  });

  final List<ListWord> words;

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  String searchQuery = "";
  List<ListWord> filteredWords = [];

  @override
  Widget build(BuildContext context) {
    filteredWords = widget.words
        .where((word) => word.word.startsWith(searchQuery))
        .toList();
    ListWord.sort(filteredWords);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: filteredWords.length,
            padding: const EdgeInsets.all(8),
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.withOpacity(0.5),
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  filteredWords[index].word,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7)),
                ),
                trailing: Builder(
                  builder: (BuildContext context) {
                    switch (filteredWords[index].status) {
                      case 2:
                        return const Icon(Icons.check, color: Colors.green);
                      case 3:
                        return const Icon(Icons.trip_origin,
                            color: Colors.orange);
                      default:
                        return const SizedBox(width: 0, height: 0);
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WordPage(word: filteredWords[index].word),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
