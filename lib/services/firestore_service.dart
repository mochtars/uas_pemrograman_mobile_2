import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wisata.dart';
import '../data/wisata_data.dart';

class FirestoreService {
  static final CollectionReference _wisataCollection =
      FirebaseFirestore.instance.collection('wisata');

  static Stream<List<Wisata>> getWisata() {
    return _wisataCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Wisata.fromJson(data);
      }).toList();
    });
  }

  static Future<void> addWisata(Wisata wisata) {
    return _wisataCollection.add(wisata.toJson());
  }

  static Future<void> seedData() async {
    final snapshot = await _wisataCollection.limit(1).get();
    if (snapshot.docs.isEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      for (final wisata in wisataList) {
        batch.set(_wisataCollection.doc(), wisata.toJson());
      }
      await batch.commit();
    }
  }
}
