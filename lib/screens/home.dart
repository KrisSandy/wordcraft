import 'package:flutter/material.dart';
import 'package:wordcraft/models/user.dart';
import 'package:wordcraft/screens/login.dart';
import 'package:wordcraft/services/auth.dart';
import 'package:wordcraft/services/user.dart';
import 'package:wordcraft/services/word.dart';
import 'package:wordcraft/widgets/home.dart';
import 'package:wordcraft/widgets/learn.dart';
import 'package:wordcraft/widgets/word_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _selectedIndex = 0;
  final _userService = UserService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: _userService.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
                width: 50.0, height: 50.0, child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final user = snapshot.data!;
          final learnWords = user.learn ?? [];
          return Scaffold(
            appBar: AppBar(
                title: const SizedBox(
                  child: Text(""),
                ),
                actions: <Widget>[
                  if (_selectedIndex == 0)
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await AuthService.signOut();
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                    ),
                ]
                // toolbarHeight: 100,
                // backgroundColor: Colors.deepOrange.withOpacity(0.7),
                ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: () {
                  switch (_selectedIndex) {
                    case 0:
                      return Home(user: user);
                    case 1:
                      return Learn(words: learnWords);
                    case 2:
                      return FutureBuilder<List<String>>(
                        future: WordService.instance.getWords(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator()),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final words = {
                              for (var word in snapshot.data!) word: 1
                            };

                            for (var word in user.known ?? []) {
                              words[word] = 2;
                            }

                            for (var word in user.learn ?? []) {
                              words[word] = 3;
                            }

                            return WordList(
                                words: words.entries
                                    .map(
                                        (e) => ListWord(e.key, status: e.value))
                                    .toList());
                          }
                        },
                      );
                  }
                }(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Learn',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Library',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
