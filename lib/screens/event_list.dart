import 'package:flutter/material.dart';
import 'package:project/screens/gift_list.dart';

import 'add_event.dart';
import 'edit_event.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}


class _EventListPageState extends State<EventListPage> {
  String _sortCriteria = "Name"; // Default sort criteria
  final List<Map<String, dynamic>> _events = [
    {
      "name": "Birthday Party",
      "category": "Personal",
      "status": "Upcoming",
      "gifts": [
        {"name": "Watch", "category": "Accessory", "status": "Pending"},
        {"name": "Toy Car", "category": "Kids", "status": "Completed"}
      ]
    },
    {
      "name": "Wedding Anniversary",
      "category": "Family",
      "status": "Current",
      "gifts": [
        {"name": "Dinner Set", "category": "Home", "status": "Pending"},
      ]
    },
    {
      "name": "Conference",
      "category": "Work",
      "status": "Past",
      "gifts": [
        {"name": "Notebook", "category": "Stationery", "status": "Completed"},
      ]
    },
    {
      "name": "Team Outing",
      "category": "Work",
      "status": "Upcoming",
      "gifts": [
        {"name": "T-Shirt", "category": "Apparel", "status": "Pending"},
      ]
    },
    {
      "name": "Reunion",
      "category": "Friends",
      "status": "Past",
      "gifts": [
        {"name": "Photo Frame", "category": "Home", "status": "Completed"},
      ]
    },
  ];

  void _sortEvents(String criteria) {
    setState(() {
      _sortCriteria = criteria;

      if (criteria == "Name") {
        _events.sort((a, b) => a["name"]!.compareTo(b["name"]!));
      } else if (criteria == "Category") {
        _events.sort((a, b) => a["category"]!.compareTo(b["category"]!));
      } else if (criteria == "Status") {
        Map<String, int> statusOrder = {
          "Upcoming": 1,
          "Current": 2,
          "Past": 3,
        };
        _events.sort((a, b) => statusOrder[a["status"]!]!.compareTo(statusOrder[b["status"]!]!));
      }
    });
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
                      "Event List",
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
            // Sort and Add Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _sortCriteria,
                    items: ["Name", "Category", "Status"]
                        .map((criteria) => DropdownMenuItem(
                      value: criteria,
                      child: Text(criteria),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) _sortEvents(value);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final newEvent = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddEventPage()),
                      );

                      if (newEvent != null) {
                        setState(() {
                          _events.add(newEvent);
                        });
                      }
                    },
                    child: const Text(
                      "Add Event",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Event List
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: _events.map((event) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color.fromRGBO(143, 148, 251, .6),
                        child: Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        event["name"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      subtitle: Text(
                        "Category: ${event["category"]}\nStatus: ${event["status"]}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () async {
                        // Navigate to GiftListPage when an event is tapped
                        final List<Map<String, String>> gifts = List<Map<String, String>>.from(event["gifts"]);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiftListPage(
                              gifts: gifts,
                              eventName: event["name"]!, // Pass the event name
                            ),
                          ),
                        );
                      },
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == "Edit") {
                            final editedEvent = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEventPage(event: event),
                              ),
                            );

                            if (editedEvent != null) {
                              setState(() {
                                int index = _events.indexOf(event);
                                _events[index] = editedEvent;
                              });
                            }
                          } else if (value == "Delete") {
                            setState(() {
                              _events.remove(event);
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "Edit",
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: "Delete",
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Back to Home Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigate back to the home page
                  Navigator.pop(context);
                },
                child: const Text(
                  "Back to Home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}