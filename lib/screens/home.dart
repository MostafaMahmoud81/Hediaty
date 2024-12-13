import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:project/screens/event_list.dart';
import 'package:project/screens/profile.dart';
import 'package:project/screens/login.dart';
import '../controller/home_controller.dart';
import '../controller/profile_controller.dart';


class HomePage extends StatefulWidget {
  final int id;

  const HomePage({super.key, required this.id});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late int userId;
  late int friendId;
  final HomeController homeController = HomeController();

  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> filteredFriends = [];

  @override
  void initState(){
    super.initState();
    userId = widget.id;
    _getFriends();
    filteredFriends = friends;
  }

  @override
  void dispose() {
    homeController.searchController.dispose();
    homeController.phoneController.dispose();
    super.dispose();
  }

  Future<void> _getFriends() async {
    friends = await homeController.getFriends(userId);
    setState((){
      filteredFriends = friends;
    });
  }

  void _filterFriends(String query) {
    query.toLowerCase();
    setState(() {
      filteredFriends = friends.where((friend) {
        String name = friend['name']!.toLowerCase();
        String phone = friend['phone']!;
        return name.contains(query) || phone.contains(query);
      }).toList();
    });
  }

  void _addFriend(String phoneNumber) async {
    int? friendId = await homeController.userModel.getUserIdByPhone(phoneNumber);

    if (friendId != null) {
      Future<int> result = homeController.addFriend(userId, friendId);
      if(result.toString() != (-1).toString()) {
        _getFriends();
        filteredFriends = friends;
      }
      else{
        _showSnackbar(context, 'Friend could not be added. Please check the phone number.');
      }
    } else {
      _showSnackbar(context, 'Friend could not be added. Please check the phone number.');
    }
    setState((){
      filteredFriends = friends;
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
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
                                "Home",
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
                    ),
                  ),
                ],
              ),
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1800),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between buttons
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventListPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Create Your Own Event/List",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add Friend Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: homeController.phoneController,
                            decoration: InputDecoration(
                              hintText: "Enter Phone Number",
                              prefixIcon: const Icon(Icons.phone, color: Color.fromRGBO(143, 148, 251, 1)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (homeController.phoneController.text.isNotEmpty) {
                              _addFriend(homeController.phoneController.text);
                            }
                          },
                          child: const Text("Add",
                            style: TextStyle(
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Friends List Section (unchanged)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Friends List",
                        style: TextStyle(
                          fontSize: 16, // Same font size as list items
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                    child: Align(
                    alignment: Alignment.centerLeft,
                      child: TextField(
                      controller: homeController.searchController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Search Friends',
                        prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(143, 148, 251, 1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                        ),
                      ),
                      onChanged:  (String value) {
                        _filterFriends(value);
                        },
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = filteredFriends[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('assets/profile_pictures/${friend['friendId']}.jpg'),
                              child: friend['events'] > 0
                                  ? CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '${friend['events']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              )
                                  : null,
                            ),
                            title: Text(
                              friend['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            subtitle: Text(
                              friend['events'] > 0
                                  ? "Upcoming Events: ${friend['events']}"
                                  : "No Upcoming Events",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward,
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsScreen(friend: friend, id: friend['friendId']),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        child: const Icon(Icons.person, color: Colors.white,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(id: userId),
            ),
          );
        },
      ),
    );
  }
}

class UserDetailsScreen extends StatefulWidget {
  final int id;
  final Map<String, dynamic> friend;

  const UserDetailsScreen({super.key,required this.friend, required this.id});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}


class _UserDetailsState extends State<UserDetailsScreen> {

  final ProfileController profileController = ProfileController();

  late Map<String, dynamic> friend;
  late String userName = "";
  late int id;
  late List<Map<String, String>> gifts = [];
  late List<Map<String, String>> userGifts = [];

  @override
  void initState(){
    super.initState();
    id = widget.id;
    friend = widget.friend;
    _getGifts();
    _getUserName();
  }

  Future<void> _getGifts() async {
    gifts = await profileController.getUserGifts(id);
    setState((){
      userGifts = gifts;
    });
  }

  void _getUserName() async{
    userName = await profileController.getUserName(id) as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/light-1.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/light-2.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/clock.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 25),
                            CircleAvatar(
                              radius: 75,
                              backgroundImage: AssetImage('assets/profile_pictures/$id.jpg'),
                            ),
                            const SizedBox(height: 10),
                            // Friend's Name in Colored Box
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(143, 148, 251, 1), // Theme color
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                friend['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details Section
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    icon: Icons.phone,
                    label: "Phone",
                    value: friend['phone'],
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: Icons.event,
                    label: "Upcoming Events",
                    value: friend['events'] > 0
                        ? "${friend['events']} Event(s)"
                        : "No Upcoming Events",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$userName's Gifts",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...userGifts.map((gift) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromRGBO(143, 148, 251, .6),
                          child: Icon(
                            Icons.account_tree_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          gift["giftName"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        subtitle: Text(
                          "For Event: ${gift["event"]}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            // Back Button
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
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color.fromRGBO(143, 148, 251, 1)),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            "$label: $value",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
