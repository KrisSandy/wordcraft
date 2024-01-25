import 'package:flutter/material.dart';
import 'package:wordcraft/models/user.dart';
import 'package:wordcraft/screens/login.dart';
import 'package:wordcraft/services/auth.dart';
import 'package:wordcraft/services/user.dart';
import 'package:wordcraft/utils/utils.dart';
import 'package:wordcraft/widgets/learn.dart';
import 'package:wordcraft/widgets/word_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final _UserService = UserService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _UserService.getUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final user = snapshot.data!;
            final learnWords = user.learn ?? [];
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Home'),
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withOpacity(0.7),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            Text(
                              'Word Craft',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Sign out'),
                        onTap: () async {
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
                    ],
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: () {
                      switch (_selectedIndex) {
                        case 0:
                          return Learn(words: learnWords);
                        case 1:
                          return WordList(words: user.known!);
                        case 2:
                          return WordList(
                              words: Utils.mergeAndSortLists(
                                  [user.learn!, user.known!, user.unknown!]));
                        default:
                          return const Text('Learn');
                      }
                    }(),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school),
                      label: 'Learn',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.star),
                      label: 'Mastered',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      label: 'Library',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ));
          }
        });
  }
}
