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


  Future<void> storeGiftsToFirebase(List<Map<String, dynamic>> gifts, int userId, String eventName) async {
    final CollectionReference giftsCollection =
    FirebaseFirestore.instance.collection('gifts');

    for (var gift in gifts) {
      try {
        // Generate a unique document ID using gift_id and event_id
        String documentId = '${gift['id']}_${gift['event_id']}';

        // Add or update the gift document
        await giftsCollection.doc(documentId).set({
          'id': gift['id'], // Required
          'name': gift['name'], // Required
          'description': gift['description'], // Optional
          'category': gift['category'], // Optional
          'price': gift['price'], // Optional
          'status': gift['status'], // Optional
          'event_id': gift['event_id'], // Required
          'pledged': gift['pledged'], // Default is 0
          'user_id': userId,
          'event_name': eventName,
        });
      } catch (e) {
        print('Failed to add/update gift: ${gift['name']} - $e');
      }
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
      };
    }).toList();

    return gifts;

  }

  Future<void> updateGiftStatus(int giftId, String newStatus, int eventId, bool pledged) async {
    await FirebaseFirestore.instance.collection('gifts').doc("${giftId}_$eventId").update({
      'status': newStatus,
      'pledged': pledged,
    });
  }

}