import 'dart:io';
import 'package:flutter/material.dart';
import '../controller/friend_controller.dart';

class FriendDetailsScreen extends StatefulWidget {
  final int friendId;
  final int currentUserId;
  final Map<String, dynamic> friend;

  const FriendDetailsScreen({super.key,required this.friend, required this.friendId, required this.currentUserId});

  @override
  _FriendDetailsState createState() => _FriendDetailsState();
}


class _FriendDetailsState extends State<FriendDetailsScreen> {

  final FriendController friendController = FriendController();


  @override
  void initState(){
    super.initState();
    friendController.friendId = widget.friendId;
    friendController.currentUserId = widget.currentUserId;
    friendController.friend = widget.friend;
    _getUserName();
    _getGifts();
  }

  Widget _displayImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(
        Icons.card_giftcard, // Default icon if imagePath is null
        size: 30,
        color: Colors.white,
      );
    }

    final File imageFile = File(imagePath);

    if (imageFile.existsSync()) {
      return Image.file(
        imageFile,
        fit: BoxFit.cover, // Ensures the image covers the circular area
        width: 60, // Match the CircleAvatar's diameter
        height: 60,
      );
    } else {
      return const Icon(
        Icons.broken_image, // Fallback icon if the file does not exist
        size: 30,
        color: Colors.white,
      );
    }
  }


  Future<void> _getGifts() async {
    friendController.gifts = await friendController.getUserGifts(friendController.friendId);
    setState((){
      friendController.userGifts = friendController.gifts;
    });
  }

  void _getUserName() async{
    friendController.userName = await friendController.getUserName(friendController.currentUserId) as String;
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
              height: 350,
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
                              backgroundImage: AssetImage('assets/profile_pictures/${friendController.friendId}.jpg'),
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
                                friendController.friend['name'],
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
                    value: friendController.friend['phone'],
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(
                    icon: Icons.event,
                    label: "Upcoming Events",
                    value: friendController.friend['events'] > 0
                        ? "${friendController.friend['events']} Event(s)"
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
                    "${friendController.friend['name']}'s Gifts",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...friendController.userGifts.map((gift) {
                    // Determine the card color based on the status
                    Color cardColor;
                    switch (gift['status']) {
                      case 'Pledged':
                        cardColor = Colors.green[100]!;
                        break;
                      case 'Purchased':
                        cardColor = Colors.red[100]!;
                        break;
                      default:
                        cardColor = Colors.grey[200]!;
                    }

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: cardColor, // Set background color based on status
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color.fromRGBO(143, 148, 251, .6),
                                child: ClipOval(
                                  child: _displayImage(gift['image_path']!),
                                ),
                              ),
                              title: Text(
                                gift["name"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              subtitle: Text(
                                "For Event: ${gift['event_name']}\nCategory: ${gift['category']}\nDescription: ${gift['description']}\nPrice: ${gift['price']}\nStatus: ${gift['status']}",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Row for the switches
                            if (gift['status'] != 'Purchased') // Disable switches if gift is Purchased
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Pledge Switch with Label
                                  Row(
                                    children: [
                                      const Text("Pledge: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Switch(
                                        value: gift['status'] == 'Pledged',
                                        onChanged: (bool pledged) async {
                                          if (pledged) {
                                            // Mark as pledged
                                            await friendController.storeNotification(friendController.friendId.toString(), "${friendController.userName} pledged your gift ${gift['name']}");
                                            await friendController.updateGiftStatusFirebase(int.parse(gift['id']!), 'Pledged', int.parse(gift['event_id']!), true, friendController.userName);
                                            await friendController.updateGiftStatusDB(int.parse(gift['id']!), 'Pledged', true);
                                            setState(() {
                                              _getGifts();
                                            });
                                          } else {
                                            // Mark as available
                                            await friendController.updateGiftStatusFirebase(int.parse(gift['id']!), 'Available', int.parse(gift['event_id']!),false, "");
                                            await friendController.updateGiftStatusDB(int.parse(gift['id']!), 'Available', false);
                                            setState(() {
                                              _getGifts();
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  // Purchase Switch with Label
                                  Row(
                                    children: [
                                      const Text("Purchase: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Switch(
                                        value: gift['status'] == 'Purchased',
                                        onChanged: (bool purchased) async {
                                          if (gift['status'] == 'Pledged') {
                                            if (purchased) {
                                              // Mark as purchased
                                              await friendController.updateGiftStatusFirebase(int.parse(gift['id']!), 'Purchased', int.parse(gift['event_id']!), true, friendController.userName);
                                              await friendController.updateGiftStatusDB(int.parse(gift['id']!), 'Purchased', true);
                                              setState(() {
                                                _getGifts();
                                              });
                                            } else {
                                              // Mark as pledged (if they uncheck purchase)
                                              await friendController.updateGiftStatusFirebase(int.parse(gift['id']!), 'Pledged', int.parse(gift['event_id']!), true, friendController.userName);
                                              await friendController.updateGiftStatusDB(int.parse(gift['id']!), 'Pledged', true);
                                              setState(() {
                                                _getGifts();
                                              });
                                            }
                                          } else {
                                            // Show message that they must pledge before purchasing
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("You must pledge the gift before purchasing it.")),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              const Text(
                                "This gift is purchased",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 60),
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