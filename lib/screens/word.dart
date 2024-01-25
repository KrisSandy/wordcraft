import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:wordcraft/models/word.dart';
import 'package:wordcraft/services/user.dart';
import 'package:wordcraft/services/word.dart';

class WordPage extends StatefulWidget {
  const WordPage({
    super.key,
    required this.word,
    this.displayActions = false,
  });

  final String word;
  final bool displayActions;

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  final _wordService = WordService();
  final _userService = UserService();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Word>(
      future: _wordService.getWord(widget.word),
      builder: (BuildContext context, AsyncSnapshot<Word> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Word not found')),
            );
          });
          Navigator.pop(context);
          return Container();
        } else {
          Word word = snapshot.data!;
          final wordDict = word.dictionary[0];
          Phonetic phoneticWithAudio;
          if (wordDict.phonetics.isEmpty) {
            phoneticWithAudio = Phonetic(text: '');
          } else {
            phoneticWithAudio = wordDict.phonetics.firstWhere(
              (phonetic) =>
                  phonetic.audio != null && phonetic.audio!.isNotEmpty,
              orElse: () => wordDict.phonetics[0], // Default value
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(capitalize(word.word)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          capitalize(word.word),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (phoneticWithAudio.audio != null &&
                          phoneticWithAudio.audio!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {
                            final player = AudioPlayer();
                            player.play(UrlSource(phoneticWithAudio.audio!));
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FutureBuilder<String>(
                            future: _wordService.getImageUrl(word.word),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Container();
                              } else {
                                return Center(
                                  child: SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: Image.network(snapshot.data!),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Meaning',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...wordDict.meanings.map((meaning) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${meaning.partOfSpeech}:',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ...meaning.definitions.map((definition) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const Text(
                                          '\u2022',
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.55,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                definition.definition,
                                                textAlign: TextAlign.left,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  height: 1.55,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              definition.example != null &&
                                                      definition
                                                          .example!.isNotEmpty
                                                  ? Text(
                                                      "Example: ${definition.example}",
                                                      textAlign: TextAlign.left,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    )
                                                  : Container(),
                                              const SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.displayActions)
                        FilledButton.tonal(
                          onPressed: () {
                            _userService.setWordToKnown(word.word);
                            Navigator.pop(context);
                          },
                          child: const Text('Mastered'),
                        ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
