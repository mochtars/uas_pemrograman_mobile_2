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

  static Future<void> updateWisata(String id, Map<String, dynamic> data) {
    return _wisataCollection.doc(id).update(data);
  }

  static Future<void> deleteWisata(String id) async {
    // Hapus subcollection ratings dulu
    final ratings =
        await _wisataCollection.doc(id).collection('ratings').get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in ratings.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    // Hapus dokumen wisata
    return _wisataCollection.doc(id).delete();
  }

  static Stream<List<Wisata>> getMyWisata(String uid) {
    return _wisataCollection
        .where('createdByUid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Wisata.fromJson(data);
      }).toList();
    });
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

  // ===== USER PROFILE =====

  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  static Future<void> updateUserProfile(
      String uid, Map<String, dynamic> data) {
    return _usersCollection.doc(uid).set(data, SetOptions(merge: true));
  }

  static Future<void> updateLastSeenWisataCount(String uid, int count) {
    return _usersCollection
        .doc(uid)
        .set({'lastSeenWisataCount': count}, SetOptions(merge: true));
  }

  static Stream<Map<String, dynamic>?> getUserProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return doc.data() as Map<String, dynamic>?;
    });
  }

  // ===== FAVORITES =====

  static Future<void> toggleFavorite(String uid, String wisataId) async {
    final docRef = _usersCollection
        .doc(uid)
        .collection('favorites')
        .doc(wisataId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({'addedAt': FieldValue.serverTimestamp()});
    }
  }

  static Stream<Set<String>> getFavoriteIds(String uid) {
    return _usersCollection
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  // ===== RATINGS =====

  static Future<void> rateWisata(
      String wisataId, String uid, double rating) async {
    await _wisataCollection
        .doc(wisataId)
        .collection('ratings')
        .doc(uid)
        .set({'rating': rating});

    // Hitung ulang rata-rata dan update dokumen wisata
    final ratingsSnapshot =
        await _wisataCollection.doc(wisataId).collection('ratings').get();
    if (ratingsSnapshot.docs.isNotEmpty) {
      double total = 0;
      for (final doc in ratingsSnapshot.docs) {
        total += (doc.data()['rating'] as num?)?.toDouble() ?? 0;
      }
      final average = total / ratingsSnapshot.docs.length;
      await _wisataCollection.doc(wisataId).update({
        'rating': double.parse(average.toStringAsFixed(1)),
      });
    }
  }

  static Stream<double?> getUserRating(String wisataId, String uid) {
    return _wisataCollection
        .doc(wisataId)
        .collection('ratings')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return (doc.data()?['rating'] as num?)?.toDouble();
    });
  }

  static Stream<double> getAverageRating(String wisataId) {
    return _wisataCollection
        .doc(wisataId)
        .collection('ratings')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return 0.0;
      double total = 0;
      for (final doc in snapshot.docs) {
        total += (doc.data()['rating'] as num?)?.toDouble() ?? 0;
      }
      return total / snapshot.docs.length;
    });
  }
}
