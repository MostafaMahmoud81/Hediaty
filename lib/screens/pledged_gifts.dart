import 'package:flutter/material.dart';
import 'package:project/screens/gift_list.dart';

class PledgedGiftsPage extends StatefulWidget {
  @override
  _PledgedGiftsPageState createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  List<Map<String, dynamic>> pledgedGifts = [
    {
      "name": "Toy Car",
      "friend": "John Doe",
      "dueDate": "2024-12-25",
      "status": "Pending",
    },
    {
      "name": "Laptop",
      "friend": "Jane Smith",
      "dueDate": "2025-01-10",
      "status": "Pending",
    },
    {
      "name": "Watch",
      "friend": "Alice Johnson",
      "dueDate": "2024-11-30",
      "status": "Completed",
    },
  ];

  void _modifyGift(Map<String, dynamic> gift) {
    // Navigate to the gift details page to modify the pledge
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGiftPage(gift: gift),
      ),
    );
  }

  // void _removeGift(Map<String, dynamic> gift) {
  //   setState(() {
  //     pledgedGifts.remove(gift);
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Gift pledge removed successfully!")),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pledged Gifts"),
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
      ),
      body: ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                  Text("Pledged by: ${gift["friend"]}"),
                  Text("Due Date: ${gift["dueDate"]}"),
                  Text("Status: ${gift["status"]}"),
                ],
              ),
              trailing: gift["status"] == "Pending"
                  ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _modifyGift(gift),
              )
                  : null,
              onTap: gift["status"] == "Pending"
                  ? () => _modifyGift(gift)
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        onPressed: () {
          // Handle adding new pledged gifts or navigate to another page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
