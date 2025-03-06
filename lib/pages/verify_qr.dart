import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking/core/services/qrCode_scaner.dart';
import 'package:movie_booking/core/utils/app_images.dart';

class VerifyQr extends StatefulWidget {
  const VerifyQr({super.key});

  @override
  State<VerifyQr> createState() => _VerifyQrState();
}

class _VerifyQrState extends State<VerifyQr> {
  final String collectionName = 'AllQrCode';
  final String documentId = 'q0ylQxcBTfMsLuX9tia';
  final String arrayField = 'QRCode';
  List<dynamic> QRCode = [];

  Future<List> fetchArray() async {
    try {
      DocumentSnapshot snapShot = await FirebaseFirestore.instance
          .collection("AllQrCode")
          .doc('q0ylQxcBTfMsLuX9tia')
          .get();

      if (snapShot.exists) {
        QRCode = snapShot[arrayField];
        return QRCode;
      } else {
        throw "Document does not exist";
      }
    } catch (e) {
      print('Error fetching array: $e');
      return [];
    }
  }

  @override
  void initState() {
    fetchArray();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 90),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                Assets.assetsImagesQrCode,
                height: 500,
                width: 500,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QrcodeScaner(
                              qrCodeData: QRCode,
                            )));
              },
              child: Material(
                color: Colors.transparent,
                elevation: 20,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  width: 250,
                  height: 80,
                  child: Center(
                    child: const Text(
                      'Scan QR Code',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
