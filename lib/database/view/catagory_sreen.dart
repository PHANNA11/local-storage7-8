import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_storage/database/connection/db_connection.dart';
import 'package:local_storage/database/model/catagory_model.dart';

class CatagoryScreen extends StatefulWidget {
  const CatagoryScreen({Key? key}) : super(key: key);

  @override
  State<CatagoryScreen> createState() => _CatagoryScreenState();
}

class _CatagoryScreenState extends State<CatagoryScreen> {
  File? imageFile;
  TextEditingController catagoryController = TextEditingController();
  List<CatagoryModel> listCatagory = [];
  getCatagoryFromDB() async {
    await DBConnection().getCatagoryList().then((value) {
      setState(() {
        listCatagory = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCatagoryFromDB();
  }

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
        itemCount: listCatagory.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 239, 235, 222),
            child: ListTile(
              leading: Image(
                  image: FileImage(
                      File(listCatagory[index].catagoryImage.toString()))),
              title: Text(
                listCatagory[index].catagoryName.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
        ElevatedButton(
            onPressed: () async {
              await DBConnection()
                  .addCatagory(CatagoryModel(
                      catagoryId: DateTime.now().millisecond,
                      catagoryName: catagoryController.text,
                      catagoryImage: imageFile!.path))
                  .whenComplete(() {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  getCatagoryFromDB();
                  Navigator.pop(context);
                });
              });
            },
            child: const Text('add'))
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
