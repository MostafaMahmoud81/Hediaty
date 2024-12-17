import 'package:flutter/cupertino.dart';
import 'package:project/model/event_model.dart';
import 'package:project/services/firebase_service.dart';
import '../model/gift_model.dart';
import '../model/shared_prefrence.dart';


class GiftController {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late TextEditingController editNameController;
  late TextEditingController editCategoryController;
  late TextEditingController editDescriptionController;
  late TextEditingController editPriceController;

  FirebaseService firebaseService = FirebaseService();

  EventModel eventModel = EventModel();


  final editFormKey = GlobalKey<FormState>();

  final formKey = GlobalKey<FormState>();

  GiftModel giftModel = GiftModel();
  final SharedPrefrence sharedPrefrence = SharedPrefrence();

  Future<List<Map<String, dynamic>>> getEventGifts(int id) async {
    List<Map<String, dynamic>> events = await giftModel.getGiftsForEvent(id);
    return events;
  }

  void addGift(Map<String, dynamic> newGift, int eventId) async {
    await giftModel.addGift(newGift, eventId);
  }

  void editGift(int giftId, Map<String, dynamic> updatedGift) async {
    await giftModel.updateGift(giftId, updatedGift);
  }

  Future<bool> deleteGift(int id) async {
    int isDeleted = await giftModel.deleteGift(id);
    if(isDeleted != -1) {
      return true;
    }
    return false;
  }

  Future<int> getUserIdByEventId(int eventId) async {
    int id = await eventModel.getUserIdByEventId(eventId);
    return id;
  }

  Future<void> storeGiftsToFirebase(List<Map<String, dynamic>> gifts, int userId, String eventName) async{
    await firebaseService.syncGiftsWithFirebase(gifts, userId, eventName);
  }


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