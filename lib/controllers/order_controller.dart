import 'package:flutter_ecommerce_backend/models/models.dart';
import 'package:flutter_ecommerce_backend/services/database_service.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final DatabaseService database = DatabaseService();

  var orders = <OrderModel>[].obs;
  var pendingOrders = <OrderModel>[].obs;

  @override
  void onInit() {
    orders.bindStream(database.getOrders());
    pendingOrders.bindStream(database.getPendingOrders());
    super.onInit();
  }

  void updateOrder(
    OrderModel order,
    String field,
    bool value,
  ) {
    database.updateOrder(order, field, value);
  }
}
