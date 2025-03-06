import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking/pages/booking.dart';
import 'package:movie_booking/pages/home.dart';
import 'package:movie_booking/pages/profile.dart';

class BottomNav extends StatefulWidget {
  final String name;
  const BottomNav({super.key, required this.name});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home HomePage;
  late Booking booking;
  late Profile profile;

  int currentTabIndex = 0;

  @override
  void initState() {
    HomePage = Home(
      name: widget.name,
    );
    booking = Booking();
    profile = Profile();

    pages = [HomePage, booking, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.black,
        color: const Color.fromARGB(255, 204, 151, 7),
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.book,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
