import 'package:flutter/material.dart';
import 'package:project/controller/gift_controller.dart';

import 'edit_gift.dart';

class PledgedGiftsPage extends StatefulWidget {
  final int userId;
  const PledgedGiftsPage({super.key, required this.userId});

  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {

  late int userId;
  GiftController giftController = GiftController();
  List<Map<String, dynamic>> pledgedGifts = [];

  // List<Map<String, dynamic>> pledgedGifts = [
  //   {
  //     "name": "Toy Car",
  //     "friend": "John Doe",
  //     "dueDate": "2024-12-25",
  //     "status": "Pending",
  //   },
  //   {
  //     "name": "Laptop",
  //     "friend": "Jane Smith",
  //     "dueDate": "2025-01-10",
  //     "status": "Pending",
  //   },
  //   {
  //     "name": "Watch",
  //     "friend": "Alice Johnson",
  //     "dueDate": "2024-11-30",
  //     "status": "Completed",
  //   },
  // ];


  @override
  void initState(){
    super.initState();
    userId = widget.userId;
    _getGifts(userId);
  }

  void _getGifts(int userId) async{
    List<Map<String, dynamic>> gifts = await giftController.getPledgedGifts(userId);
    setState((){
      pledgedGifts = gifts;
    });
  }

  void _modifyGift(Map<String, dynamic> gift) {
    // Navigate to the gift details page to modify the pledge
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGiftPage(gift: gift),
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
                      "My Pledged Gifts",
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Column(
                children: pledgedGifts.isNotEmpty
                    ? pledgedGifts.map((gift) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(
                        gift["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pledged by: ${gift["pledged_by"]}"),
                          Text("Due Date: ${gift["due_date"]}"),
                          Text("Status: ${gift["status"]}"),
                        ],
                      ),
                      trailing: gift["status"] != "Purchased"
                          ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _modifyGift(gift),
                      )
                          : null,
                      onTap: gift["status"] != "Purchased"
                          ? () => _modifyGift(gift)
                          : null,
                    ),
                  );
                }).toList()
                    : [
                  const Center(
                    child: Text(
                      "No pledged gifts found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
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
