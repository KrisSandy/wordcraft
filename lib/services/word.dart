import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wordcraft/models/word.dart';

class WordService {
  final _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  late final CollectionReference _wordsRef;

  WordService() {
    _wordsRef = _firestore.collection('gre').withConverter<Word>(
        fromFirestore: (snapshots, _) => Word.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (word, _) => word.toJson());
  }

  Future<Word> getWord(String word) async {
    final snapshot = await _wordsRef.doc(word).get();
    if (!snapshot.exists) {
      throw Exception('Word not found');
    }
    return snapshot.data()! as Word;
  }

  Future<List<String>> getDocIds() async {
    final snapshot = await _wordsRef.get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<String> getImageUrl(String word) async {
    // Get a reference to the image file
    final pathRef = _storageRef.child('images/$word.png');

    // Get the download URL
    String downloadUrl = await pathRef.getDownloadURL();

    return downloadUrl;
  }
}
