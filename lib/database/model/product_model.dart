// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:local_storage/database/constant/database_fiel.dart';

class Product {
  int? id;
  String? name;
  int? qty;
  double? price;
  Product({this.id, this.name, this.qty, this.price});
  // for set data to  Database
  Map<String, dynamic> productModelToJson() {
    return {fId: id, fName: name, fQty: qty, fPrice: price};
  }
// for get data  from Database
  Product.productModelFromJson(Map<String, dynamic> res)
      : id = res[fId],
        name = res[fName],
        qty = res[fQty],
        price = res[fPrice];
}
