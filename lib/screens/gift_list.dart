import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project/controller/gift_controller.dart';
import 'package:project/screens/add_gift.dart';
import 'edit_gift.dart';


class GiftListPage extends StatefulWidget {

  final int eventId;
  final String eventName;

  const GiftListPage({super.key, required this.eventName, required this.eventId});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {

  GiftController giftController = GiftController();

  @override
  void initState(){
    super.initState();
    giftController.eventId = widget.eventId;
    giftController.eventName = widget.eventName;
    _getGifts();
    giftController.filteredGifts = giftController.gifts;
  }

  @override
  void dispose() {
    giftController.searchController.dispose();
    super.dispose();
  }

  Future<void> _getGifts() async {
    giftController.gifts = await giftController.getEventGifts(giftController.eventId);
    setState((){
      giftController.filteredGifts = giftController.gifts;
    });
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

  void _sortGifts(String criteria) {
    setState(() {
      giftController.sortCriteria = criteria;

      if (criteria == "Name") {
        giftController.gifts.sort((a, b) => a["name"]!.compareTo(b["name"]!));
      } else if (criteria == "Category") {
        giftController.gifts.sort((a, b) => a["category"]!.compareTo(b["category"]!));
      } else if (criteria == "Status") {
        Map<String, int> statusOrder = {
          "Available": 1,
          "Pledged": 2,
          "Purchased": 3,
        };
        giftController.gifts.sort((a, b) => statusOrder[a["status"]!]!.compareTo(statusOrder[b["status"]!]!));
      }
    });
  }

  void _filterGifts(String query) {
    query.toLowerCase();
    setState(() {
      giftController.filteredGifts = giftController.gifts.where((gift) {
        String name = gift['name']!.toLowerCase();
        String category = gift['category']!.toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    });
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hedieaty",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${widget.eventName} Event Gifts List",
                      style: const TextStyle(
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: DropdownButton<String>(
                value: giftController.sortCriteria,
                items: ["Name", "Category", "Status"]
                    .map((criteria) => DropdownMenuItem(
                  value: criteria,
                  child: Text(criteria),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) _sortGifts(value);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async{
                      final newGift = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddGiftPage(),
                        ),
                      );
            
                      if (newGift != null) {
                        giftController.addGift(newGift, giftController.eventId);
                        setState(() {
                          _getGifts();
                        });
                      }
                    }, // Navigate to add new gift page
                    child: const Text(
                      "Add New Gift",
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
                    onPressed: () async{
                      giftController.userId = await giftController.getUserIdByEventId(giftController.eventId);
                      await giftController.storeGiftsToFirebase(giftController.gifts, giftController.userId, giftController.eventName);
                    },
                    child: const Text(
                      "Sync Gifts",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: giftController.searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Search Gifts',
                    prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(143, 148, 251, 1)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ),
                  onChanged:  (String value) {
                    _filterGifts(value);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: giftController.filteredGifts.map((gift) {
                  // Check if the gift is editable based on pledged status and completion status
                  bool isEditable = (gift["status"] != "Purchased");
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(143, 148, 251, .6),
                        child: ClipOval(
                          child: _displayImage(gift['image_path']),
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
                        "Category: ${gift["category"]}\nStatus: ${gift["status"]}\nDescription: ${gift["description"]}\nPrice: ${gift["price"]}\nPledged: ${gift["pledged"]}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      // Only show the PopupMenuButton if the gift is editable
                      trailing: isEditable
                          ? PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            final updatedGift = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditGiftPage(gift: gift),
                              ),
                            );

                            if (updatedGift != null) {
                              giftController.editGift(gift['id'], updatedGift);
                              setState(() {
                                _getGifts();
                              });
                            }
                          } else if (value == 'delete') {
                            await giftController.deleteGift(gift['id']);
                            setState(() {
                              _getGifts();
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ],
                      )
                          : null, // Hide the 3 dots (PopupMenuButton) if not editable
                      onTap: () async {
                        if (isEditable) {
                          final updatedGift = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditGiftPage(gift: gift),
                            ),
                          );

                          if (updatedGift != null) {
                            giftController.editGift(gift['id'], updatedGift);
                            setState(() {
                              _getGifts();
                            });
                          }
                        }
                      },
                    ),
                  );
                }).toList(),
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
}







