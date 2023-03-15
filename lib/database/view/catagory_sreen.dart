import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CatagoryScreen extends StatefulWidget {
  const CatagoryScreen({Key? key}) : super(key: key);

  @override
  State<CatagoryScreen> createState() => _CatagoryScreenState();
}

class _CatagoryScreenState extends State<CatagoryScreen> {
  File? imageFile;
  TextEditingController catagoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catagory'),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => buildAddCatagory(),
              );
            },
            child: Chip(
                backgroundColor: const Color.fromARGB(255, 34, 82, 122),
                label: Row(
                  children: const [Icon(Icons.add), Text(' add ')],
                )),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return const Card(
            color: Color.fromARGB(255, 239, 235, 222),
            child: ListTile(
              title: Text(
                'Soft drink',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAddCatagory() {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: 500,
        width: 500,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: catagoryController,
                decoration: const InputDecoration(
                    hintText: 'procut Name', border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 200,
              width: 200,
              //color: Colors.red,
              child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              cameraImage();
                            },
                            icon: const Icon(Icons.camera_alt)),
                        IconButton(
                            onPressed: () {
                              gallaryImage();
                            },
                            icon: const Icon(Icons.image)),
                      ],
                    ),
                    imageFile == null
                        ? const SizedBox()
                        : SizedBox(
                            height: 150,
                            width: 300,
                            child: Image(
                                fit: BoxFit.cover,
                                image: FileImage(File(imageFile!.path))))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('cancel')),
        ElevatedButton(onPressed: () async {}, child: const Text('add'))
      ],
      title: const Text('From Product'),
    );
  }

  void gallaryImage() async {
    var fileData = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(fileData!.path);
    });
  }

  void cameraImage() async {
    var fileData = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 300);
    setState(() {
      imageFile = File(fileData!.path);
    });
  }
}
