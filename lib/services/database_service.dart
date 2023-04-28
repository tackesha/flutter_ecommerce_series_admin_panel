import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_backend/models/models.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<OrderModel>> getOrders() {
    return _firebaseFirestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<OrderModel>> getPendingOrders() {
    return _firebaseFirestore
        .collection('orders')
        .where('isCancelled', isEqualTo: false)
        .where('isDelivered', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Product>> getProducts() {
    return _firebaseFirestore
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  Future<List<OrderStats>> getOrderStats() {
    return _firebaseFirestore
        .collection('order_stats')
        .orderBy('dateTime')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) => OrderStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }

  Stream<List<Category>> getCategories() {
    return _firebaseFirestore.collection('categories').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromMap(doc.data())).toList());
  }

  Future<void> addProduct(Product product) async {
      final docRef = _firebaseFirestore.collection('products').doc();
      final productId = docRef.id;
      final newProduct = product.copyWith(id: productId);
      await docRef.set(newProduct.toMap());
  // if(product.id == ''){
  //   final docRef = _firebaseFirestore.collection('products').doc();
  //   product.id = docRef.id;
  //    await docRef.set(product.toMap());
  // }else {
  //   await _firebaseFirestore.collection('products').doc(product.id).set(product.toMap());
  // } 
  //   //return _firebaseFirestore.collection('products').add(product.toMap());
  }

  Future<void> updateField(
    Product product,
    String field,
    dynamic newValue,
  ) {
    return _firebaseFirestore
        .collection('products')
        .where('id', isEqualTo: product.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.first.reference.update({field: newValue})
            });
  }

  Future<void> updateOrder(
    OrderModel order,
    String field,
    dynamic newValue,
  ) {
    return _firebaseFirestore
        .collection('orders')
        .where('id', isEqualTo: order.id)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.first.reference.update({field: newValue})
            });
  }
}
