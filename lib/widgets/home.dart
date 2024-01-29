import 'package:flutter/material.dart';
import 'package:wordcraft/models/user.dart';
import 'package:wordcraft/services/word.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.user});

  final User user;
  final _wordService = WordService.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _wordService.getWords(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
                width: 50.0, height: 50.0, child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final wordList = snapshot.data as List<String>;
          return Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL ?? ''),
                  radius: 30.0,
                ),
                const SizedBox(height: 10.0),
                Text(
                  user.displayName ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 30.0),
                Card(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Your progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: SizedBox(
                            height: 10.0,
                            child: LinearProgressIndicator(
                              value: user.known!.length / wordList.length,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${user.known!.length} / ${wordList.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
