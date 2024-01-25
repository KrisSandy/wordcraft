import 'package:flutter/material.dart';
import 'package:wordcraft/screens/word.dart';
import 'package:wordcraft/utils/utils.dart';

class Learn extends StatefulWidget {
  const Learn({super.key, required this.words});

  final List<String> words;

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: widget.words.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordPage(
                  word: widget.words[index],
                  displayActions: true,
                ),
              ),
            ).then((_) => setState(() {
                  widget.words.removeAt(index);
                }));
          },
          child: Card(
            child: Center(
              child: Text(
                Utils.capitalizeFirstWord(widget.words[index]),
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7)),
              ),
            ),
          ),
        );
      },
    );
  }
}
