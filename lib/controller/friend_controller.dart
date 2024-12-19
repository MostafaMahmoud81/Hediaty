import '../model/gift_model.dart';
import '../model/user_model.dart';
import '../services/firebase_service.dart';
import '../services/notification.dart';

class FriendController {

  late Map<String, dynamic> friend;
  late String userName = "";
  late String eventName = "";
  late int friendId;
  late int currentUserId;
  late List<Map<String, String>> gifts = [];
  late List<Map<String, String>> userGifts = [];


  final UserModel userModel = UserModel();
  final GiftModel giftModel = GiftModel();
  FirebaseService firebaseService = FirebaseService();


  Future<String?> getUserName(int id) async {
    String? userName = await userModel.getNameByUserId(id);
    if(userName != null) {
      return userName;
    }
    else{
      return null;
    }
  }

  Future<List<Map<String, String>>> getUserGifts(int id) async {
    List<Map<String, String>> gifts = await firebaseService.getGiftsByUserId(id);
    return gifts;
  }

  Future<void> updateGiftStatusDB(int giftId, String status, bool pledged) async{
    await giftModel.updateGiftStatus(giftId, status, pledged);
  }

  Future<void> updateGiftStatusFirebase(int giftId, String status, int eventId, bool pledged, String friendName) async{
    await firebaseService.updateGiftStatus(giftId, status, eventId, pledged, friendName);
  }

  Future<void> storeNotification(String userId, String message) async {
    await LocalNotification.saveNotificationForUser(userId, message);
  }
}