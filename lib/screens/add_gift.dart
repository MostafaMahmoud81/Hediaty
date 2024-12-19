import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/controller/gift_controller.dart';


class AddGiftPage extends StatefulWidget {

  const AddGiftPage({super.key});

  @override
  _AddGiftPageState createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {

  GiftController giftController = GiftController();


  void _addGift() {

    if (giftController.formKey.currentState!.validate()) {

      final newGift = {
        "name": giftController.nameController.text,
        "category": giftController.categoryController.text,
        "description": giftController.descriptionController.text,
        "price": giftController.priceController.text,
        "status": "Available",
        "pledged": false,
        "image_path": giftController.imagePath,
      };

      Navigator.pop(context, newGift);
    }
  }

  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);


    if (image != null) {
      final imagePath = image.path;
      setState(() {
        giftController.giftImage = File(imagePath);
      });
      return imagePath;
    }
    return null;
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
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: giftController.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                          ),
                          onPressed:() async =>  giftController.imagePath = (await _pickImage())!,
                          child: const Text(
                            "Upload Image",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        giftController.giftImage != null
                            ? Image.file(
                          giftController.giftImage!,
                          width: 50,
                          height: 50,
                        ) :
                        const Text("No image selected"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: giftController.nameController,
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

                    TextFormField(
                      controller: giftController.categoryController,
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
                      controller: giftController.descriptionController,
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
                      controller: giftController.priceController,
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
                          child: const Text(
                            "Available",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(height: 20),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Pledged:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: false,
                          onChanged: null, // Disable interaction
                        ),
                        Text(
                          "No",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _addGift,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Add Gift",
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
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