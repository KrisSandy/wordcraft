import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordcraft/models/user.dart';
import 'package:wordcraft/services/auth.dart';
import 'package:wordcraft/services/word.dart';
import 'package:wordcraft/utils/utils.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _userRef;
  late final WordService _wordService;
  final StreamController<User> _userController = StreamController<User>();

  UserService() {
    _userRef = _firestore.collection('users').withConverter<User>(
        fromFirestore: (snapshots, _) => User.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (user, _) => user.toJson());
    _wordService = WordService();
  }

  Stream<User> getUser() {
    final authUser = AuthService.user;

    if (authUser == null) {
      _userController.addError(Exception('User not found'));
    } else {
      _userRef.doc(authUser.email).snapshots().listen((snapshot) async {
        if (!snapshot.exists || snapshot.data() == null) {
          final wordList = await _wordService.getDocIds();
          final learn = Utils.getRandomWords(wordList, 6);
          Utils.removeWords(wordList, learn);

          User user = User(
            email: authUser.email,
            displayName: authUser.displayName,
            photoURL: authUser.photoURL,
            learn: learn,
            known: [],
            unknown: wordList,
          );

          await _userRef.doc(user.email).set(user);
          _userController.add(user);
        } else {
          User user = snapshot.data()! as User;
          _userController.add(user);
        }
      });
    }

    return _userController.stream;
  }

  Future<void> setWordToKnown(String word) async {
    final authUser = AuthService.user;

    await _userRef.doc(authUser!.email).update({
      'known': FieldValue.arrayUnion([word]),
    });

    await _userRef.doc(authUser.email).update({
      'learn': FieldValue.arrayRemove([word]),
    });
  }

  Future<List<String>> getNewWordsToLearn() async {
    final authUser = AuthService.user;

    final snapshot = await _userRef.doc(authUser!.email).get();
    final user = snapshot.data()! as User;

    final learn = Utils.getRandomWords(user.unknown!, 6);

    await _userRef.doc(authUser.email).update({
      'learn': FieldValue.arrayUnion(learn),
    });

    await _userRef.doc(authUser.email).update({
      'unknown': FieldValue.arrayRemove(learn),
    });

    return learn;
  }
}
