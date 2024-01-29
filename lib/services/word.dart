import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wordcraft/models/word.dart';

class WordService {
  final _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  late final CollectionReference _wordsRef;
  final List<String> _wordList = [];

  WordService._privateConstructor() {
    _wordsRef = _firestore.collection('gre').withConverter<Word>(
        fromFirestore: (snapshots, _) => Word.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (word, _) => word.toJson());
  }

  static final WordService instance = WordService._privateConstructor();

  Future<Word> getWord(String word) async {
    final snapshot = await _wordsRef.doc(word).get();
    if (!snapshot.exists) {
      throw Exception('Word not found');
    }
    return snapshot.data()! as Word;
  }

  Future<List<String>> getWords() async {
    if (_wordList.isNotEmpty) {
      return _wordList;
    }

    final snapshot = await _wordsRef.get();
    if (snapshot.docs.isEmpty) {
      throw Exception('Words not found');
    }

    _wordList.addAll(snapshot.docs.map((doc) => doc.id).toList());
    return _wordList;
  }

  Future<String> getImageUrl(String word) async {
    // Get a reference to the image file
    final pathRef = _storageRef.child('images/$word.png');

    // Get the download URL
    String downloadUrl = await pathRef.getDownloadURL();

    return downloadUrl;
  }
}
