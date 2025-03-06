import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking/core/services/firestore_service.dart';
import 'package:movie_booking/core/services/shared_preferances_singleton.dart';
import 'package:movie_booking/core/utils/app_images.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? id, name;

  getTheSharedPref() async {
    SharedPreferanceHelper sharedPrefHelper = SharedPreferanceHelper();
    id = await sharedPrefHelper.getUserId();
    name = await sharedPrefHelper.getUserName();
    setState(() {});
  }

  Stream? bookingStream;
  getOnTheLoad() async {
    await getTheSharedPref();
    bookingStream = await FirestoreService().getbookings(id!);
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allBooking() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          shrinkWrap: true,
          //padding: const EdgeInsets.all(16),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16), // Space between cards
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: QrImageView(
                          data: ds['qrId'],
                          version: QrVersions.auto,
                          size: 120,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              Assets.assetsImagesInfinity,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoRow(Icons.person, ds['name'],
                                    fontSize: 22),
                                const SizedBox(height: 10),
                                _infoRow(Icons.movie, ds['movieName'],
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _infoRow(
                                        Icons.group, ds['quantity'].toString()),
                                    const SizedBox(width: 20),
                                    _infoRow(Icons.monetization_on,
                                        "\$${ds['total']}"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _infoRow(Icons.alarm, ds['movieTime']),
                                    const SizedBox(width: 20),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                _infoRow(Icons.calendar_month, ds['movieDate']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String text,
      {Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w500}) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 204, 151, 7)),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
              color: color, fontSize: fontSize, fontWeight: fontWeight),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Center(
              child: const Text(
                'Bookings',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              margin: EdgeInsets.only(left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xff1e232c),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Expanded(child: allBooking()),
            ))
          ],
        ),
      ),
    );
  }
}
