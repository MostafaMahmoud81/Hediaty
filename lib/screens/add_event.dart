import 'package:flutter/material.dart';


class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String _status = "Upcoming";

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  void _addEvent() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      final newEvent = {
        "name": _nameController.text,
        "category": _categoryController.text,
        "status": _status,
      };

      // Pop and return the new event to the EventListPage
      Navigator.pop(context, newEvent);
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
              height: 250,
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
                      "Add a New Event",
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
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Event Name Input with validation and placeholder
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
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
                    SizedBox(height: 20),

                    // Category Input with validation and placeholder
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
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
                    SizedBox(height: 20),

                    // Status Dropdown
                    DropdownButton<String>(
                      value: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                      items: ["Upcoming", "Current", "Past"]
                          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                          .toList(),
                    ),
                    SizedBox(height: 20),

                    // Add Event Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _addEvent,
                      child: Text("Add Event", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(143, 148, 251, 1), // Background theme color
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context); // Navigate back to the previous screen
                            },
                            iconSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}