// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:local_storage/database/constant/database_fiel.dart';

class CatagoryModel {
  int? catagoryId;
  String? catagoryName;
  String? catagoryImage;
  CatagoryModel({this.catagoryId, this.catagoryName, this.catagoryImage});
  Map<String, dynamic> catagoryToJson() {
    return {
      fCatagoryID: catagoryId,
      fCatagoryName: catagoryName,
      fCatagoryImage: catagoryImage
    };
  }

  CatagoryModel.catagoryFromJson(Map<String, dynamic> res)
      : catagoryId = res[fCatagoryID],
        catagoryName = res[fCatagoryName],
        catagoryImage = res[fCatagoryImage];
}
