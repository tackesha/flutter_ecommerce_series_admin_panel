import 'package:get/get.dart';
import 'package:flutter_ecommerce_backend/models/models.dart';
import 'package:flutter_ecommerce_backend/services/database_service.dart';

class CategoryController extends GetxController {
  final DatabaseService _database = DatabaseService();

  var categories = <Category>[].obs;

  @override
  void onInit() {
    categories.bindStream(_database.getCategories());
    super.onInit();
  }
}
