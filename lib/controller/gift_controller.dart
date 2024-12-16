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
    await firebaseService.storeGiftsToFirebase(gifts, userId, eventName);
  }




}