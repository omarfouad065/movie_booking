import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking/core/helper_functions/build_error_bar.dart';
import 'package:movie_booking/core/services/firestore_service.dart';
import 'package:movie_booking/core/services/shared_preferances_singleton.dart';
import 'package:movie_booking/pages/bottom_nav.dart';
import 'package:movie_booking/pages/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "", password = "", myname = "", myid = "", myimage = "";

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      QuerySnapshot snapshot = await FirestoreService().getUserByEmail(email);
      myname = snapshot.docs[0]['name'];
      myid = snapshot.docs[0]['id'];
      myimage = snapshot.docs[0]['imageUrl'];

      await SharedPreferanceHelper().saveUserName(myname);
      await SharedPreferanceHelper().saveUserId(myid);
      await SharedPreferanceHelper().saveUserId(email);
      await SharedPreferanceHelper().saveUserImage(myimage);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNav(
                    name: myname,
                  )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        buildErrorBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        buildErrorBar(context, 'Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            _buildHeader(),
            const SizedBox(height: 40),
            _buildTextField(
                emailController, "Email", "Enter Email", Icons.email),
            const SizedBox(height: 20),
            _buildTextField(passwordController, "Password", "Enter Password",
                Icons.password,
                isPassword: true),
            const SizedBox(height: 10),
            _buildForgotPassword(),
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome!",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "LogIn",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  setState(() {
                    email = emailController.text;
                    password = passwordController.text;
                  });
                }
                userLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "LogIn",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
