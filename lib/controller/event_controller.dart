import 'package:flutter/cupertino.dart';
import '../model/event_model.dart';


class EventController {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String status = "Current";

  final formKey = GlobalKey<FormState>();

  late TextEditingController editNameController;
  late TextEditingController editCategoryController;
  late String editStatus;
  late TextEditingController editLocationController;
  late TextEditingController editDescriptionController;
  late TextEditingController editDateController;

  final editFormKey = GlobalKey<FormState>();

  final EventModel eventModel = EventModel();

  Future<List<Map<String, dynamic>>> getUserEvents(int id) async {
    List<Map<String, dynamic>> events = await eventModel.getEventsWithGifts(id);
    return events;
  }

  void addEvent(Map<String, dynamic> newEvent, int id) async {
    await eventModel.addEvent(newEvent, id);
  }

  void editEvent(int eventId, Map<String, dynamic> updatedEvent) async {
    await eventModel.updateEvent(eventId, updatedEvent);
  }

  Future<bool> deleteEvent(int id) async {
    int isDeleted = await eventModel.deleteEvent(id);
    if(isDeleted != -1) {
      return true;
    }
    return false;
  }

  String evaluateDateStatus(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // Removes time for comparison
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));

    if (date.isBefore(today)) {
      return 'Past';
    } else if (date.isAtSameMomentAs(today) ||
        date.isAtSameMomentAs(tomorrow) ||
        date.isAtSameMomentAs(dayAfterTomorrow)) {
      return 'Current';
    } else {
      return 'Upcoming';
    }
  }




}