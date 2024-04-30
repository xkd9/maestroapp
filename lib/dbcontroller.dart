import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DB {
  static Future<List<String>> getAllUrls() async{
    return [
      "https://www.instagram.com/reel/C5nwnXnuRwT/?utm_source=ig_web_copy_link",
      "https://www.instagram.com/reel/C5qpyO7vfAR/?utm_source=ig_web_copy_link",
      "https://www.instagram.com/reel/C57zwPUpUNl/?utm_source=ig_web_copy_link",
      "https://www.instagram.com/reel/C5vNdUEJqQw/?utm_source=ig_web_copy_link",
      "https://www.instagram.com/reel/C55ZWRopBWh/?utm_source=ig_web_copy_link",
      ];
  }
  static Future<bool> Save(String url, String category) async{
    try {
      var uuid = Uuid();
      String id = uuid.v1();
      final firestoreInstance = FirebaseFirestore.instance;
      final CollectionReference collection = firestoreInstance.collection('items');
      await collection.doc(id).set( {
          "id": id,
          "userId": uuid.v1(),
          "url": url,
          "category": category
        }
      );
    } catch (e) {
      print('Error adding document to Firestore: $e');
      return false;
    }
    return true;
  }
}