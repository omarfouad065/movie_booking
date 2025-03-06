import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking/constants.dart';
import 'package:movie_booking/core/helper_functions/build_error_bar.dart';
import 'package:movie_booking/core/services/firestore_service.dart';
import 'package:movie_booking/core/services/shared_preferances_singleton.dart';
import 'package:movie_booking/pages/detail_page/widgets/build_back_button.dart';
import 'package:movie_booking/pages/detail_page/widgets/build_movie_desc.dart';
import 'package:movie_booking/pages/detail_page/widgets/build_movie_poster.dart';
import 'package:movie_booking/pages/detail_page/widgets/build_movie_title.dart';
import 'package:movie_booking/pages/detail_page/widgets/build_date_section_title.dart';
import 'package:movie_booking/pages/detail_page/widgets/build_time_section_title.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(
      {super.key,
      required this.image,
      required this.name,
      required this.shortDetail,
      required this.movieDetail,
      required this.ticketPrice});

  final String image, name, shortDetail, movieDetail;
  final int ticketPrice;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? id, name;

  getTheSharedPref() async {
    SharedPreferanceHelper sharedPrefHelper = SharedPreferanceHelper();
    id = await sharedPrefHelper.getUserId();
    name = await sharedPrefHelper.getUserName();
    setState(() {});
  }

  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;
  int ticketCount = 1;
  Map<String, dynamic>? paymentIntent;
  String? currentDate;
  String? currentTime;
  List<String> getFormattedDates() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE d');
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return formatter.format(date);
    });
  }

  @override
  void initState() {
    getTheSharedPref();
    super.initState();
  }

  List<String> getShowTimes() {
    return ['08:00 PM', '10:00 PM', '06:00 PM'];
  }

  @override
  Widget build(BuildContext context) {
    final dates = getFormattedDates();
    final showTimes = getShowTimes();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BuildMoviePoster(imagePath: widget.image),
          BuildBackButton(),
          _buildMovieDetails(dates, showTimes),
        ],
      ),
    );
  }

  Widget _buildMovieDetails(List<String> dates, List<String> showTimes) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xff1e232c),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildMovieTitle(
                  title: widget.name,
                  subtitle: widget.shortDetail,
                ),
                BuildMovieDesc(
                  desc: widget.movieDetail,
                ),
                BuildDateSectionTitle(title: 'Select Date'),
                _buildDateSelector(dates),
                BuildTimeSectionTitle(title: 'Select Time'),
                _buildTimeSlots(showTimes),
                _buildTicketSelector(),
                _buildBookNowButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSelector(List<String> dates) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedDateIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => selectedDateIndex = index);
              currentDate = dates[index];
            },
            child: Container(
              width: 80,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? const Color(0xffeed51e)
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Text(dates[index],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots(List<String> showTimes) {
    return Wrap(
      spacing: 10,
      children: List.generate(
        showTimes.length,
        (index) {
          final isSelected = selectedTimeIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => selectedTimeIndex = index);
              currentTime = showTimes[index];
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? const Color(0xffeed51e)
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Text(showTimes[index],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTicketSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Text('Total: ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text('\$${ticketCount * widget.ticketPrice}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70)),
          const Spacer(),
          Row(
            children: [
              _buildQuantityButton(Icons.remove, () {
                if (ticketCount > 1) setState(() => ticketCount--);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('$ticketCount',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              _buildQuantityButton(Icons.add, () {
                setState(() => ticketCount++);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[800],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildBookNowButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffeed51e),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          makePayment((ticketCount * widget.ticketPrice).toString());
          print((ticketCount * widget.ticketPrice).toString());
        },
        child: const Text('Book Now',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent?['client_secret'],
              style: ThemeMode.system,
              merchantDisplayName: 'Flutter Stripe Store Demo',
            ),
          )
          .then((value) {});
      disPlayPaymentSheet(amount);
    } catch (e) {
      print('Error: $e');
    }
  }

  disPlayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        String uniqueId = randomAlphaNumeric(5);
        Map<String, dynamic> userMovieMap = {
          'movieName': widget.name,
          'movieImage': widget.image,
          'movieDate': currentDate,
          'movieTime': currentTime,
          'quantity': ticketCount,
          'total': amount,
          'qrId': uniqueId,
          'name': name,
        };

        await FirestoreService().addUserBooking(userMovieMap, id!);
        await FirestoreService().addQrId(uniqueId);
        buildErrorBar(context, 'Ticket has been Booked Successfully');
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('Payment Successful',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      )
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error: $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error: $e');

      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text('Cancelled'),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to create payment intent: ${response.body}');
        return null;
      }
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculateAmount = (int.parse(amount)) * 100;
    return calculateAmount.toString();
  }
}
