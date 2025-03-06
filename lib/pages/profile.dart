import 'package:flutter/material.dart';
import 'package:movie_booking/core/services/auth.dart';
import 'package:movie_booking/core/services/shared_preferances_singleton.dart';
import 'package:movie_booking/core/utils/app_images.dart';
import 'package:movie_booking/pages/login_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? id, name, email, image;

  getTheSharedPref() async {
    SharedPreferanceHelper sharedPrefHelper = SharedPreferanceHelper();
    id = await sharedPrefHelper.getUserId();
    name = await sharedPrefHelper.getUserName();
    email = await sharedPrefHelper.getUserEmail();
    image = await sharedPrefHelper.getUserImage();

    setState(() {});
  }

  Future<void> logout() async {
    AuthMethods authMethods = AuthMethods();
    await authMethods.SignOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
    print("User Signed Out");
  }

  Future<void> deleteuser() async {
    AuthMethods authMethods = AuthMethods();
    await authMethods.deleteuser();
    print("User Deleted");
  }

  @override
  void initState() {
    getTheSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Dark background
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: const Text("Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Column(
              children: [
                // Profile Image
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(
                          Assets.assetsImagesBoy), // Replace with your asset
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Name
                profileTile(Icons.person, "Name", name!),
                const SizedBox(height: 10),

                // Email
                profileTile(Icons.email, "Email", email!),
                const SizedBox(height: 20),

                // Contact Us
                actionTile(Icons.contact_mail, "Contact Us"),
                const SizedBox(height: 10),

                // Logout
                actionTile(Icons.logout, "Logout", onTap: () {
                  logout();
                }),
                const SizedBox(height: 10),

                // Delete Account
                actionTile(Icons.delete, "Delete Account", isDelete: true,
                    onTap: () {
                  deleteuser();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for Profile Details (Name, Email)
  Widget profileTile(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xffedb41d)),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Widget for Action Buttons (Contact Us, Logout, Delete)
  Widget actionTile(
    IconData icon,
    String title, {
    bool isDelete = false,
    VoidCallback? onTap, // Callback for user interaction
  }) {
    return InkWell(
      onTap: onTap, // Handle tap event
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Soft shadow
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isDelete ? Colors.red : const Color(0xffedb41d),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: isDelete ? Colors.red : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
