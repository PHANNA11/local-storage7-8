import 'package:flutter/material.dart';
import 'package:local_storage/database/connection/db_connection.dart';
import 'package:local_storage/database/model/product_model.dart';

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
          IconButton(
              onPressed: () async {
                getDataFromDB();
              },
              icon: const Icon(Icons.refresh))
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
    return Card(
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: ListTile(
          leading: const SizedBox(
            height: 60,
            width: 60,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://imgs.search.brave.com/B45IN-UUkwqK6Ps9GoDyi5TaUMCWWxgdnoPKJTyhOPk/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly9mbG9y/aXBhZm9vZGRlbGl2/ZXJ5LmNvbS5ici93/cC1jb250ZW50L3Vw/bG9hZHMvMjAyMS8w/NC9jb2NhLWNvbGEt/Mi1saXRyb3M0ODc1/XzAuanBn'),
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
    );
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
                  .addProduct(Product(
                      id: DateTime.now().millisecond,
                      name: nameController.text,
                      qty: int.parse(qtyController.text),
                      price: double.parse(priceController.text)))
                  .whenComplete(() {
                getDataFromDB();
              });
            },
            child: const Text('add'))
      ],
      title: const Text('From Product'),
    );
  }
}
