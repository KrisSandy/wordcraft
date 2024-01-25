import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordcraft/models/word.dart';

class WordStore {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _wordsRef;

  WordStore() {
    _wordsRef = _firestore.collection('gre').withConverter<Word>(
        fromFirestore: (snapshots, _) => Word.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (word, _) => word.toJson());
  }

  Future<void> add(Word word) async {
    await _wordsRef.doc(word.word).set(word);
  }

  Future<void> update(Word word) async {
    await _wordsRef.doc(word.word).update(word.toJson());
  }

  Stream<QuerySnapshot> getWords(int status) {
    return _wordsRef.where('status', isEqualTo: status).snapshots();
  }

  Future<void> delete(String word) async {
    await _wordsRef.doc(word).delete();
  }

  Future<Word> getWord(String word) async {
    final snapshot = await _wordsRef.where('word', isEqualTo: word).get();
    if (snapshot.docs.isEmpty) {
      return Word(word: word);
    }
    return Word(
      word: snapshot.docs.first['word'],
    );
  }
}
