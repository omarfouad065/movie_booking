import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking/core/helper_functions/build_error_bar.dart';
import 'package:movie_booking/core/services/firestore_service.dart';
import 'package:movie_booking/core/services/shared_preferances_singleton.dart';
import 'package:movie_booking/pages/bottom_nav.dart';
import 'package:movie_booking/pages/login_page.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  registration() async {
    if (nameController.text != "" && emailController.text != "") {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String id = randomAlphaNumeric(16);
        Map<String, dynamic> userInfoMap = {
          "name": name,
          "email": email,
          "id": id,
          "imageUrl":
              "https://upgnlzqypnrdetexcluy.supabase.co/storage/v1/object/public/fruits_images/images/image%2029.png"
        };

        await SharedPreferanceHelper().saveUserName(nameController.text);
        await SharedPreferanceHelper().saveUserEmail(emailController.text);
        await SharedPreferanceHelper().saveUserId(id);
        await SharedPreferanceHelper().saveUserImage(
            "https://upgnlzqypnrdetexcluy.supabase.co/storage/v1/object/public/fruits_images/images/image%2029.png");

        await FirestoreService().addData(
          path: "users",
          data: userInfoMap,
        );

        buildErrorBar(context, 'success');

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNav(
                name: nameController.text,
              ),
            ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          buildErrorBar(context, 'Password is too weak.');
        } else if (e.code == 'email-already-in-use') {
          buildErrorBar(context, 'Email already in use.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildTextField(
                controller: nameController,
                label: "Name",
                hint: "Enter Name",
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: emailController,
                label: "Email",
                hint: "Enter Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: passwordController,
                label: "Password",
                hint: "Enter Password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              _buildSignUpButton(),
              const SizedBox(height: 20),
              _buildLoginRow(),
            ],
          ),
        ),
      ),
    );
  }

  /// Large heading: 'Sign up'
  Widget _buildHeader() {
    return const Text(
      "Sign up",
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Reusable text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
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

  /// 'Sign Up' button
  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          print('Name: $name, Email: $email, Password: $password');
          setState(() {
            name = nameController.text;
            email = emailController.text;
            password = passwordController.text;
            registration();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "SignUp",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Bottom text: 'Already have an account? Login'
  Widget _buildLoginRow() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Already have an account? ",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
            },
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
