import 'package:local_storage/database/constant/database_fiel.dart';
import 'package:local_storage/database/model/catagory_model.dart';
import 'package:local_storage/database/model/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {
  Future<Database> initDataBase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'userdatabase.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE $tableName($fId INTEGER PRIMARY KEY, $fName TEXT, $fQty INTEGER , $fPrice TEXT ,$fImage TEXT,$fcatagory TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> addProduct(Product product) async {
    var db = await initDataBase();
    await db.insert(tableName, product.productModelToJson());
    print('object was added');
  }

  Future<List<Product>> getProductList() async {
    var db = await initDataBase();
    List<Map<String, dynamic>> result = await db.query(tableName);
    return result.map((e) => Product.productModelFromJson(e)).toList();
  }

  Future<void> deleteProduct(int id) async {
    var db = await initDataBase();
    await db.delete(tableName, where: '$fId=?', whereArgs: [id]);
  }

  Future<void> updateProduct(Product product) async {
    var db = await initDataBase();
    await db.update(tableName, product.productModelToJson(),
        where: '$fId=?', whereArgs: [product.id]);
  }

  Future<Database> initDataBaseCatagory() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'userdatabasepro.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE $tableCatagorynName($fCatagoryID INTEGER PRIMARY KEY, $fCatagoryName TEXT,$fCatagoryImage TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> addCatagory(CatagoryModel catagoryModel) async {
    var db = await initDataBaseCatagory();
    await db.insert(tableCatagorynName, catagoryModel.catagoryToJson());
  }

  Future<List<CatagoryModel>> getCatagoryList() async {
    var db = await initDataBaseCatagory();
    List<Map<String, dynamic>> result = await db.query(tableCatagorynName);
    return result.map((e) => CatagoryModel.catagoryFromJson(e)).toList();
  }

  Future<void> deleteCatagory(int catagoryId) async {
    var db = await initDataBaseCatagory();
    await db.delete(tableCatagorynName,
        where: '$fCatagoryID=?', whereArgs: [catagoryId]);
  }

  Future<void> updateCatagory(CatagoryModel catagoryModel) async {
    var db = await initDataBaseCatagory();
    await db.update(tableCatagorynName, catagoryModel.catagoryToJson(),
        where: '$fCatagoryID=?', whereArgs: [catagoryModel.catagoryId]);
  }
}
