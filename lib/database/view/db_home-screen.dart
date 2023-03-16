import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_storage/database/connection/db_connection.dart';
import 'package:local_storage/database/model/catagory_model.dart';
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
  List<CatagoryModel> listCatagory = [];
  getDataFromDB() async {
    db = DBConnection();
    await db.getProductList().then((value) {
      setState(() {
        listProduct = value;
      });
    });
  }

  getCatagoryFromDB() async {
    await db.getCatagoryList().then((value) {
      setState(() {
        listCatagory = value;
      });
    });
  }

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromDB();
    getCatagoryFromDB();
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
              getCatagoryFromDB();
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
              subtitle: Text(product.catagory.toString()),
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
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: listCatagory
                    .map((item) => DropdownMenuItem<String>(
                          value: item.catagoryName,
                          child: Text(
                            item.catagoryName ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 160,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.redAccent,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.yellow,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  padding: null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.redAccent,
                  ),
                  elevation: 8,
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
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
                    catagory: selectedValue),
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
    selectedValue = product.catagory;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: 500,
        width: 500,
        child: ListView(
          children: [
            DropdownButton2(
                items: List.generate(
                    listCatagory.length,
                    (index) => DropdownMenuItem(
                        child: Text(
                            listCatagory[index].catagoryName.toString())))),
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
