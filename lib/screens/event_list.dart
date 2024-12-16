import 'package:flutter/material.dart';
import 'package:project/controller/event_controller.dart';
import 'package:project/screens/gift_list.dart';
import 'add_event.dart';
import 'edit_event.dart';

class EventListPage extends StatefulWidget {
  final int id;
  const EventListPage({super.key, required this.id});

  @override
  _EventListPageState createState() => _EventListPageState();
}


class _EventListPageState extends State<EventListPage> {
  late int userId;
  String _sortCriteria = "Name";
  final EventController eventController = EventController();
  List<Map<String, dynamic>> events = [];

  @override
  void initState(){
    super.initState();
    userId = widget.id;
    _getEvents();
  }

  Future<void> _getEvents() async {
    List<Map<String, dynamic>> getEvents = await eventController.getUserEvents(userId);
    setState((){
      events = getEvents;
    });
  }

  void _sortEvents(String criteria) {
    setState(() {
      _sortCriteria = criteria;

      if (criteria == "Name") {
        events.sort((a, b) => a["name"]!.compareTo(b["name"]!));
      } else if (criteria == "Category") {
        events.sort((a, b) => a["category"]!.compareTo(b["category"]!));
      } else if (criteria == "Status") {
        Map<String, int> statusOrder = {
          "Upcoming": 1,
          "Current": 2,
          "Past": 3,
        };
        events.sort((a, b) => statusOrder[a["status"]!]!.compareTo(statusOrder[b["status"]!]!));
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
                      "Events List",
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
                      backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final newEvent = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddEventPage()),
                      );

                      if (newEvent != null) {
                        eventController.addEvent(newEvent, userId);
                        setState(() {
                          _getEvents();
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
                children: events.map((event) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
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
                        "Category: ${event["category"]}\nStatus: ${event["status"]} \nDate: ${event["date"]} \nLocation: ${event["location"]} \nDescription: ${event["description"]}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiftListPage(
                              eventId: event['id'],
                              eventName: event['name'], // Pass the event name
                            ),
                          ),
                        );
                      },
                      trailing: event['status'] == 'Past'
                          ? null // Hide trailing menu if event status is "past"
                          : PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == "Edit") {
                            final editedEvent = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEventPage(event: event),
                              ),
                            );

                            if (editedEvent != null) {
                              eventController.editEvent(event['id'], editedEvent);
                              setState(() {
                                _getEvents();
                              });
                            }
                          } else if (value == "Delete") {
                            await eventController.deleteEvent(event['id']);
                            setState(() {
                              _getEvents();
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

            const SizedBox(height: 60),
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