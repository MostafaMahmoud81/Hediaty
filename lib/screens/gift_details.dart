import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GiftDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? gift; // Existing gift details (optional)

  const GiftDetailsPage({Key? key, this.gift}) : super(key: key);

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  String _status = "Available";
  File? _giftImage; // For storing the uploaded image
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing gift details if provided
    _nameController = TextEditingController(text: widget.gift?["name"] ?? "");
    _descriptionController = TextEditingController(text: widget.gift?["description"] ?? "");
    _categoryController = TextEditingController(text: widget.gift?["category"] ?? "");
    _priceController = TextEditingController(text: widget.gift?["price"] ?? "");
    _status = widget.gift?["status"] ?? "Available";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _giftImage = File(image.path);
      });
    }
  }

  void _saveGiftDetails() {
    if (_formKey.currentState!.validate()) {
      if (_status == "Pledged" && widget.gift != null) {
        // Prevent modifying a pledged gift
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pledged gifts cannot be modified.")),
        );
        return;
      }

      // Collect updated gift details
      final updatedGift = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "category": _categoryController.text,
        "price": _priceController.text,
        "status": _status,
        "image": _giftImage?.path ?? widget.gift?["image"], // Use existing image if no new one is selected
      };

      Navigator.pop(context, updatedGift); // Return updated gift details
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
                      "Gift Details",
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
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Gift Name Input
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
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

                    // Description Input
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Enter a description",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Category Input
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        hintText: "Enter the category",
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

                    // Price Input
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: "Price",
                        hintText: "Enter the price",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Image Upload
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                          ),
                          onPressed: _pickImage,
                          child: const Text(
                            "Upload Image",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _giftImage != null
                            ? Image.file(
                          _giftImage!,
                          width: 50,
                          height: 50,
                        )
                            : widget.gift?["image"] != null
                            ? Image.file(
                          File(widget.gift!["image"]),
                          width: 50,
                          height: 50,
                        )
                            : const Text("No image selected"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Status Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status:"),
                        DropdownButton<String>(
                          value: _status,
                          items: ["Available", "Pledged"]
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (widget.gift != null && widget.gift!["status"] == "Pledged") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Pledged gifts cannot be modified.")),
                              );
                            } else {
                              setState(() {
                                _status = value!;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _saveGiftDetails,
                      child: const Text(
                        "Save Gift",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(143, 148, 251, 1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
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
}
