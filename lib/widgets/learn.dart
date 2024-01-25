import 'package:flutter/material.dart';
import 'package:wordcraft/screens/word.dart';
import 'package:wordcraft/services/user.dart';
import 'package:wordcraft/utils/utils.dart';

class Learn extends StatefulWidget {
  Learn({super.key, required this.words});

  final List<String> words;
  final _userService = UserService();

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hurray! You have learnt all the words! 🎉🎉',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                List<String> newWords =
                    await widget._userService.getNewWordsToLearn();
                setState(() {
                  widget.words.clear();
                  widget.words.addAll(newWords);
                });
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 5.0),
                  Text('Get new words'),
                ],
              ),
            ),
          ],
        ),
      );
    }

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
            );
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
