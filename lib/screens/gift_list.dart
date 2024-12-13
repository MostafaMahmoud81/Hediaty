import 'package:flutter/material.dart';
import 'package:project/screens/gift_details.dart';

// class GiftListPage extends StatefulWidget {
//   final String eventName;
//   final List<Map<String, String>> gifts;
//
//   GiftListPage({required this.eventName, required this.gifts});
//
//   @override
//   _GiftListPageState createState() => _GiftListPageState();
// }

class GiftListPage extends StatefulWidget {
  final List<Map<String, dynamic>> gifts; // List of gifts
  final String eventName;

  const GiftListPage({Key? key, required this.gifts, required this.eventName}) : super(key: key);

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  String _sortCriteria = "Name"; // Default sort criteria

  void _sortGifts(String criteria) {
    setState(() {
      _sortCriteria = criteria;

      if (criteria == "Name") {
        widget.gifts.sort((a, b) => a["name"]!.compareTo(b["name"]!));
      } else if (criteria == "Category") {
        widget.gifts.sort((a, b) => a["category"]!.compareTo(b["category"]!));
      } else if (criteria == "Status") {
        Map<String, int> statusOrder = {
          "Pending": 1,
          "Completed": 2,
        };
        widget.gifts.sort((a, b) => statusOrder[a["status"]!]!.compareTo(statusOrder[b["status"]!]!));
      }
    });
  }

  void _editGift(Map<String, dynamic> gift) async {
    final updatedGift = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGiftPage(gift: gift),
      ),
    );

    if (updatedGift != null) {
      setState(() {
        final index = widget.gifts.indexOf(gift);
        widget.gifts[index] = updatedGift;
      });
    }
  }

  void _deleteGift(Map<String, dynamic> gift) {
    setState(() {
      widget.gifts.remove(gift);
    });
  }

  void _addGift() async {
    final newGift = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGiftPage(),
      ),
    );

    if (newGift != null) {
      setState(() {
        widget.gifts.add(newGift);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
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
                      "${widget.eventName} Gifts List",
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: DropdownButton<String>(
                value: _sortCriteria,
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: widget.gifts.map((gift) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color.fromRGBO(143, 148, 251, .6),
                        child: Icon(
                          Icons.ac_unit_outlined,
                          color: Colors.white,
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
                        "Category: ${gift["category"]}\nStatus: ${gift["status"]}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editGift(gift); // Navigate to edit page
                          } else if (value == 'delete') {
                            _deleteGift(gift); // Delete gift
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text("Edit"),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final updatedGift = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiftDetailsPage(gift: gift), // Navigate to details page
                          ),
                        );

                        if (updatedGift != null) {
                          setState(() {
                            final index = widget.gifts.indexOf(gift);
                            widget.gifts[index] = updatedGift;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
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
                onPressed: _addGift, // Navigate to add new gift page
                child: const Text(
                  "Add New Gift",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Back to the event list
                },
                child: const Text(
                  "Back to Event List",
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



class AddGiftPage extends StatefulWidget {
  const AddGiftPage({super.key});

  @override
  _AddGiftPageState createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String _status = "Pending";
  String _pledged = "No";

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  void _addGift() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      final newGift = {
        "name": _nameController.text,
        "category": _categoryController.text,
        "status": _status,
        "pledged": _pledged,
      };

      // Pop and return the new gift to the GiftListPage
      Navigator.pop(context, newGift);
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
                      "Add a New Gift",
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
                    // Gift Name Input with validation and placeholder
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Gift Name",
                        hintText: "Enter the gift name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.card_giftcard),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the gift name';
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
                        hintText: "Enter the gift category",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the category';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Dropdown for Status Selection
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: ["Pending", "Completed"]
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pledged:"),
                        Switch(
                          value: _pledged == "Yes",
                          onChanged: (value) {
                            setState(() {
                              _pledged = value ? "Yes" : "No";
                            });
                          },
                        ),
                        Text(_pledged),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _addGift,
                      child: const Text(
                        "Add Gift",
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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


class EditGiftPage extends StatefulWidget {
  final Map<String, dynamic> gift;

  EditGiftPage({required this.gift});

  @override
  _EditGiftPageState createState() => _EditGiftPageState();
}

class _EditGiftPageState extends State<EditGiftPage> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  String _status = "Pending";
  String _pledged = "No";

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.gift["name"]);
    _categoryController = TextEditingController(text: widget.gift["category"]);
    _status = widget.gift["status"] ?? "Pending";
    _pledged = widget.gift["pledged"] ?? "No";
  }

  void _saveGift() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      final updatedGift = {
        "name": _nameController.text,
        "category": _categoryController.text,
        "status": _status,
        "pledged": _pledged,
      };

      // Pop and return the updated gift to the previous page
      Navigator.pop(context, updatedGift);
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
                      "Edit Gift",
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
            // Form Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Gift Name Input
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Gift Name",
                        hintText: "Enter the gift name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.card_giftcard),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the gift name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Category Input
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: "Category",
                        hintText: "Enter the gift category",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Dropdown for Status Selection
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: ["Pending", "Completed"]
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pledged Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Pledged:"),
                        Switch(
                          value: _pledged == "Yes",
                          onChanged: (value) {
                            setState(() {
                              _pledged = value ? "Yes" : "No";
                            });
                          },
                        ),
                        Text(_pledged),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    ElevatedButton(
                      onPressed: _saveGift,
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Back Button
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(143, 148, 251, 1),
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

