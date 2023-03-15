import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_storage/database/connection/db_connection.dart';
import 'package:local_storage/database/model/product_model.dart';
import 'package:local_storage/database/view/catagory_sreen.dart';

class DBHomeScreen extends StatefulWidget {
  const DBHomeScreen({Key? key}) : super(key: key);
  @override
  State<DBHomeScreen> createState() => _DBHomeScreenState();
}

class _DBHomeScreenState extends State<DBHomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  late DBConnection db;
  File? imageFile;
  //late Future<List<Product>> listProduct;
  List<Product> listProduct = [];
  getDataFromDB() async {
    db = DBConnection();
    await db.getProductList().then((value) {
      setState(() {
        listProduct = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' DATABASE'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CatagoryScreen(),
                  ));
            },
            child: Chip(
                backgroundColor: const Color.fromARGB(255, 34, 82, 122),
                label: Row(
                  children: const [
                    Icon(Icons.menu_outlined),
                    Text(' Catagory ')
                  ],
                )),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          return buildProductCard(listProduct[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return buildAddProduct();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                await DBConnection()
                    .deleteProduct(product.id!)
                    .whenComplete(() {
                  getDataFromDB();
                });
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              // An action can be bigger than the others.

              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return buildUpdateProduct(product);
                  },
                );
              },
              backgroundColor: const Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.edit_note,
              label: 'Edit',
            ),
          ],
        ),
        child: Card(
          child: SizedBox(
            height: 70,
            width: double.infinity,
            child: ListTile(
              leading: SizedBox(
                height: 60,
                width: 60,
                child: product.image == null
                    ? const FlutterLogo()
                    : Image(
                        fit: BoxFit.cover,
                        image: FileImage(File(product.image.toString())),
                      ),
              ),
              title: Row(
                children: [
                  Expanded(child: Text(product.name.toString())),
                  Expanded(
                      child: Text(
                    '\$ ${product.price}',
                    style: const TextStyle(color: Colors.red),
                  )),
                ],
              ),
              subtitle: const Text('softdrink'),
              trailing: const Icon(Icons.west_sharp),
            ),
          ),
        ));
  }

  Widget buildAddProduct() {
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
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: 'procut Name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: qtyController,
                decoration: const InputDecoration(
                    hintText: 'procut Qty', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(
                    hintText: 'procut price', border: OutlineInputBorder()),
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
                  .addProduct(
                Product(
                  image: imageFile!.path,
                  id: DateTime.now().millisecond,
                  name: nameController.text,
                  qty: int.parse(qtyController.text),
                  price: priceController.text,
                ),
              )
                  .whenComplete(() {
                getDataFromDB();
              });
            },
            child: const Text('add'))
      ],
      title: const Text('From Product'),
    );
  }

  Widget buildUpdateProduct(Product product) {
    nameController.text = product.name!;
    qtyController.text = product.qty.toString();
    priceController.text = product.price.toString();
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
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: 'procut Name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: qtyController,
                decoration: const InputDecoration(
                    hintText: 'procut Qty', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: priceController,
                decoration: const InputDecoration(
                    hintText: 'procut price', border: OutlineInputBorder()),
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
                  .updateProduct(Product(
                      id: product.id,
                      name: nameController.text,
                      qty: int.parse(qtyController.text),
                      price: priceController.text,
                      image: imageFile!.path))
                  .whenComplete(() {
                getDataFromDB();
              });
            },
            child: const Text('Update'))
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
