import 'package:project/model/event_model.dart';
import 'package:project/services/firebase_service.dart';


class PledgedGiftsController {

  late int userId;
  List<Map<String, dynamic>> pledgedGifts = [];

  EventModel eventModel = EventModel();

  FirebaseService firebaseService = FirebaseService();

  Future<List<Map<String, String>>> getPledgedGifts(int userId) async {

    // Step 1: Fetch all gifts for the user from Firestore
    List<Map<String, String>> gifts = await firebaseService.getPledgedGiftsByUserId(userId);

    // Step 2: Iterate through the gifts and add the event_date for each
    for (var gift in gifts) {
      String eventId = gift['event_id']!;

      // Fetch the event date from the SQLite database
      String eventDate = await eventModel.getEventDateById(int.parse(eventId));
      gift['due_date'] = eventDate; // Add event_date to the gift data

    }
    return gifts; // Return the combined list

  }

}