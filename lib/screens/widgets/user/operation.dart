import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadingData(String _productName, String _productPrice,
    String _imageUrl, bool _isFavourite) async {
  await FirebaseFirestore.instance.collection("products").add({
    'productName': _productName,
    'productPrice': _productPrice,
    'imageUrl': _imageUrl,
    'isFavourite': _isFavourite,
  });
}

Future<void> editStatus(bool _isActive,String id) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .update({"isActive": !_isActive});
}

Future<void> deleteUser(DocumentSnapshot doc) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(doc.id)
      .delete();
}