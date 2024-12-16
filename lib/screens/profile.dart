import 'package:flutter/material.dart';
import 'package:project/controller/profile_controller.dart';
import 'package:project/screens/pledged_gifts.dart';

import 'event_list.dart';



class ProfilePage extends StatefulWidget {
  final int id;

  const ProfilePage({super.key, required this.id});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final ProfileController profileController = ProfileController();

  bool _isNotificationsEnabled = true;

  late int userId;
  late String userName = "";
  late String userEmail = "";
  late List<Map<String, String>> events = [];
  late List<Map<String, String>> createdEvents = [];
  late List<Map<String, String>> gifts = [];
  late List<Map<String, String>> pledgedGifts = [];
  Map<String, String> userData = {};

  @override
  void initState(){
    super.initState();
    userId = widget.id;
    _getUserName();
    _getEmail();
    _getEvents();
    _getGifts();
    _fetchUserData();
    _loadNotificationPreference();
  }


  void _loadNotificationPreference() async {
    bool isEnabled = await profileController.loadNotificationPreference(userId);
    setState(() {
      _isNotificationsEnabled = isEnabled;
    });
  }

  Future<void> _saveNotificationPreference(bool isEnabled) async {
    profileController.saveNotificationPreference(isEnabled, userId);
  }

  Future<void> _getEvents() async {
    events = await profileController.getEvents(userId);
    setState((){
      createdEvents = events;
    });
  }

  Future<void> _getGifts() async {
    gifts = await profileController.getPledgedGifts(userId);
    setState((){
      pledgedGifts = gifts;
    });
  }

  void _getUserName() async{
    userName = await profileController.getUserName(userId) as String;
  }

  void _getEmail() async{
    userEmail = await profileController.getEmail(userId) as String;
  }

  _fetchUserData() async {
    userData = await profileController.getUserData(userId);
    setState(() {
      profileController.nameController.text = userData['name'] ?? '';
      profileController.phoneController.text = userData['phone'] ?? '';
    });
  }

  _updateUserData() async {
    int result = await profileController.updateUserData(userId);
    profileController.isEditingName = false;
    profileController.isEditingPhone = false;
    if (result > 0) {
      setState(() {
        _getUserName();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Personal information updated successfully')),
      );
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update personal information')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section (User Information)
            Container(
              height: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      userName, // Display user name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: AssetImage('assets/profile_pictures/$userId.jpg'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding to the left and right
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Label for name
                        Expanded(
                          child: Text(
                            profileController.nameController.text.isEmpty
                                ? "Name"
                                : profileController.nameController.text,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        // Edit icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            setState(() {
                              // Enable the text field for editing
                              profileController.isEditingName = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (profileController.isEditingName)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: profileController.nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            profileController.isEditingName = false;
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add padding to the left and right
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            profileController.phoneController.text.isEmpty
                                ? "Phone Number"
                                : profileController.phoneController.text,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        // Edit icon
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            setState(() {
                              // Enable the text field for editing
                              profileController.isEditingPhone = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (profileController.isEditingPhone)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: profileController.phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            profileController.isEditingPhone = false;
                          });
                        },
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Update Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _updateUserData,
                      child: const Text(
                        "Update Personal Information",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Enable Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Switch(
                    value: _isNotificationsEnabled,
                    onChanged: (bool newValue) {
                      setState(() {
                        _isNotificationsEnabled = newValue;
                      });
                      _saveNotificationPreference(newValue);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventListPage(id: userId),
                    ),
                  );
                },
                child: const Text(
                  "My Events",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PledgedGiftsPage(),
                    ),
                  );
                },
                child: const Text(
                  "My Pledged Gifts",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
