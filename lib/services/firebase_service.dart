import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }


  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }


  Future<void> syncGiftsWithFirebase(
      List<Map<String, dynamic>> localGifts, int userId, String eventName) async {
    final CollectionReference giftsCollection =
    FirebaseFirestore.instance.collection('gifts');

    try {
      // Fetch all gifts for the current user and event from Firestore
      QuerySnapshot firestoreGiftsSnapshot = await giftsCollection
          .where('user_id', isEqualTo: userId)
          .where('event_name', isEqualTo: eventName)
          .get();

      // Convert Firestore documents to a map for easy comparison
      final Map<String, Map<String, dynamic>> firestoreGifts = {
        for (var doc in firestoreGiftsSnapshot.docs)
          doc.id: doc.data() as Map<String, dynamic>
      };

      // Create a set of document IDs from local gifts
      final Set<String> localGiftIds = localGifts
          .map((gift) => '${gift['id']}_${gift['event_id']}')
          .toSet();

      // Delete gifts from Firestore that are not in the local list
      for (String docId in firestoreGifts.keys) {
        if (!localGiftIds.contains(docId)) {
          await giftsCollection.doc(docId).delete();
        }
      }

      // Add or update local gifts in Firestore
      for (var gift in localGifts) {
        String documentId = '${gift['id']}_${gift['event_id']}';
        await giftsCollection.doc(documentId).set({
          'id': gift['id'],
          'name': gift['name'],
          'description': gift['description'],
          'category': gift['category'],
          'price': gift['price'],
          'status': gift['status'],
          'event_id': gift['event_id'],
          'pledged': gift['pledged'],
          'user_id': userId,
          'event_name': eventName,
          'pledged_by': '',
        });
      }
    } catch (e) {
      print('Failed to sync gifts with Firestore: $e');
    }
  }



  Future<List<Map<String, String>>> getGiftsByUserId(int userId) async {
    final CollectionReference giftsCollection =
    FirebaseFirestore.instance.collection('gifts');

    // Query the gifts collection to find documents with the given user_id
    final QuerySnapshot querySnapshot = await giftsCollection
        .where('user_id', isEqualTo: userId)
        .get();

    // Map the results into a list of maps with all values as strings
    final List<Map<String, String>> gifts = querySnapshot.docs.map((doc) {
      return {
        'id': doc['id'].toString(),
        'name': doc['name'].toString(),
        'description': doc['description']?.toString() ?? '',
        'category': doc['category']?.toString() ?? '',
        'price': doc['price']?.toString() ?? '',
        'status': doc['status']?.toString() ?? '',
        'event_id': doc['event_id'].toString(),
        'pledged': (doc['pledged'] == true).toString(), // Convert boolean to string
        'user_id': doc['user_id'].toString(),
        'event_name': doc['event_name'].toString(),
        'pledged_by': doc['pledged_by'].toString(),
      };
    }).toList();

    return gifts;

  }

  Future<List<Map<String, String>>> getPledgedGiftsByUserId(int userId) async {
    final CollectionReference giftsCollection =
    FirebaseFirestore.instance.collection('gifts');

    // Query the gifts collection to find documents with the given user_id
    final QuerySnapshot querySnapshot = await giftsCollection
        .where('user_id', isEqualTo: userId)
        .where('pledged', isEqualTo: true) // Filter for pledged gifts
        .get();

    // Map the results into a list of maps with all values as strings
    final List<Map<String, String>> pledgedGifts = querySnapshot.docs.map((doc) {
      return {
        'id': doc['id'].toString(),
        'name': doc['name'].toString(),
        'description': doc['description']?.toString() ?? '',
        'category': doc['category']?.toString() ?? '',
        'price': doc['price']?.toString() ?? '',
        'status': doc['status']?.toString() ?? '',
        'event_id': doc['event_id'].toString(),
        'pledged': (doc['pledged'] == true).toString(), // Convert boolean to string
        'user_id': doc['user_id'].toString(),
        'event_name': doc['event_name'].toString(),
        'pledged_by': doc['pledged_by'].toString(),
      };
    }).toList();

    return pledgedGifts;
  }


  Future<void> updateGiftStatus(int giftId, String newStatus, int eventId, bool pledged, String friendName) async {
    await FirebaseFirestore.instance.collection('gifts').doc("${giftId}_$eventId").update({
      'status': newStatus,
      'pledged': pledged,
      'pledged_by': friendName,
    });
  }

}