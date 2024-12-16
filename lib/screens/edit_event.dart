import 'package:flutter/material.dart';
import 'package:project/controller/event_controller.dart';

class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> event;

  EditEventPage({required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {

  final EventController eventController = EventController();


  @override
  void initState() {
    super.initState();
    eventController.editNameController = TextEditingController(text: widget.event["name"]);
    eventController.editCategoryController = TextEditingController(text: widget.event["category"]);
    eventController.editLocationController = TextEditingController(text: widget.event["location"]);
    eventController.editDateController = TextEditingController(text: widget.event["date"]);
    eventController.editDescriptionController = TextEditingController(text: widget.event["description"]);
    eventController.editStatus = widget.event["status"]!;
  }

  void _editEvent() {
    if (eventController.editFormKey.currentState!.validate()) {
      final editedEvent = {
        "name": eventController.editNameController.text,
        "category": eventController.editCategoryController.text,
        "location": eventController.editLocationController.text,
        "description": eventController.editDescriptionController.text,
        "date": eventController.editDateController.text,
        "status": eventController.editStatus,
      };

      Navigator.pop(context, editedEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hedieaty",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Edit Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: eventController.editFormKey,
                child: Column(
                  children: [
                    // Event Name Input with validation and placeholder
                    TextFormField(
                      controller: eventController.editNameController,
                      decoration: const InputDecoration(
                        labelText: "Event Name",
                        hintText: "Enter the event name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.event),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Category Input with validation and placeholder
                    TextFormField(
                      controller: eventController.editCategoryController,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        hintText: "Enter the event category",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: eventController.editDateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Date",
                        hintText: "Enter the event date",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            eventController.editStatus = eventController.evaluateDateStatus(pickedDate);
                          });
                          eventController.editDateController.text =
                            pickedDate.toIso8601String().split('T')[0];
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    TextFormField(
                      controller: eventController.editLocationController,
                      decoration: const InputDecoration(
                        labelText: "Location",
                        hintText: "Enter the event location",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: eventController.editDescriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Enter the event description",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.text_snippet),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Status Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Status:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 20), // Spacing between label and value
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            eventController.editStatus,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Save Changes Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _editEvent,
                      child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);  // Navigate back to the previous screen
        },
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}
