import 'package:flutter/material.dart';
import 'package:project/controller/gift_controller.dart';

class EditGiftPage extends StatefulWidget {
  final Map<String, dynamic> gift;

  const EditGiftPage({super.key, required this.gift});

  @override
  _EditGiftPageState createState() => _EditGiftPageState();
}

class _EditGiftPageState extends State<EditGiftPage> {

  GiftController giftController = GiftController();

  @override
  void initState() {
    super.initState();
    giftController.editNameController = TextEditingController(text: widget.gift["name"]);
    giftController.editCategoryController = TextEditingController(text: widget.gift["category"]);
    giftController.editDescriptionController = TextEditingController(text: widget.gift["description"]);
    giftController.editPriceController = TextEditingController(text: widget.gift["price"].toString());

  }

  void _saveGift() {
    if (giftController.editFormKey.currentState!.validate()) {

      final updatedGift = {
        "name": giftController.editNameController.text,
        "category": giftController.editCategoryController.text,
        "description": giftController.editDescriptionController.text,
        "price": double.parse(giftController.editPriceController.text),
        "status":  widget.gift['status'],
        "pledged": widget.gift['pledged'],
      };

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
                key: giftController.editFormKey,
                child: Column(
                  children: [
                    // Gift Name Input
                    TextFormField(
                      controller: giftController.editNameController,
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

                    // Category Input
                    TextFormField(
                      controller: giftController.editCategoryController,
                      decoration: const InputDecoration(
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

                    TextFormField(
                      controller: giftController.editDescriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        hintText: "Enter the gift description",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: giftController.editPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Price",
                        hintText: "Enter the gift price",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monetization_on_sharp),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Dropdown for Status Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Status:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 20), // Spacing between label and value
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            widget.gift['status'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Pledged:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: widget.gift['pledged'] == true,
                          onChanged: null, // Disable interaction
                        ),
                        Text(
                          widget.gift['pledged'] == true ? "Yes" : "No",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Save Button
                    ElevatedButton(
                      onPressed: _saveGift,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
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