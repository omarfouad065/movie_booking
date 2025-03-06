import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_booking/core/services/data_service,.dart';

class FirestoreService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<void> addData(
      {required String path,
      required Map<String, dynamic> data,
      String? documentId}) async {
    if (documentId != null) {
      await firestore.collection(path).doc(documentId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  @override
  Future<dynamic> getData(
      {required String path,
      String? documentId,
      Map<String, dynamic>? query}) async {
    if (documentId != null) {
      var data = await firestore.collection(path).doc(documentId).get();
      return data.data();
    } else {
      Query<Map<String, dynamic>> data = firestore.collection(path);
      if (query != null) {
        if (query['orderBy'] != null) {
          var orderByFiled = query['orderBy'];
          var descending = query['descending'];
          data = data.orderBy(orderByFiled, descending: descending);
        }

        if (query['Limit'] != null) {
          var limit = query['Limit'];
          data = data.limit(limit);
        }
      }

      var result = await data.get();
      return result.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<bool> checkIfDataExists(
      {required String path, String? documentId}) async {
    var data = await firestore.collection(path).doc(documentId).get();
    return data.exists;
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  Future addUserBooking(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("bookings")
        .add(userInfoMap);
  }

  Future addQrId(String qrid) async {
    return await FirebaseFirestore.instance
        .collection("AllQrCode")
        .doc("q0ylQxcBTfMsLuX9tia")
        .update({
      'QRCode': FieldValue.arrayUnion([qrid])
    });
  }

  Future<Stream<QuerySnapshot>> getbookings(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("bookings")
        .snapshots();
  }
}
