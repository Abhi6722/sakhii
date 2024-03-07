import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakhii/controllers/auth_controller.dart';
import 'package:sakhii/screens/login_screen.dart';
import 'package:sakhii/utils/constants.dart';
import 'package:sakhii/utils/theme.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureText = true;
  bool emailEmpty = true;
  bool passEmpty = true;
  bool loginButtonEnabled = false;
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.07),
        child: GetBuilder<AuthController>(
            builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 70,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 34,
                      color: myTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Register your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: myTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        authController.loginError = '';
                        emailEmpty = val.isNotEmpty ? false : true;
                        loginButtonEnabled = (!emailEmpty && !passEmpty) ? true : false;
                      });
                    },
                    cursorColor: myTheme.primaryColor,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    controller: authController.emailController,
                    style: TextStyle(fontSize: 15, color: Constants.primaryColor),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: myTheme.primaryColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 25.0,
                        horizontal: 25.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: myTheme.primaryColorLight.withOpacity(0.2),
                      hintStyle: TextStyle(
                        color: myTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: authController.passwordController,
                    onChanged: (val) {
                      setState(() {
                        authController.loginError = '';
                        passEmpty = val.isNotEmpty ? false : true;
                        loginButtonEnabled = (!emailEmpty && !passEmpty) ? true : false;
                      });
                    },
                    cursorColor: myTheme.primaryColor,
                    obscureText: obscureText,
                    autofocus: false,
                    style: TextStyle(fontSize: 15, color: Constants.primaryColor),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: myTheme.primaryColor,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Constants.primaryColor.withOpacity(0.5),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 25.0,
                        horizontal: 25.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide.none, // Remove the active border line
                      ),
                      filled: true,
                      fillColor: myTheme.primaryColorLight.withOpacity(0.2),
                      hintStyle: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold, // Make the placeholder text bold
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (loginButtonEnabled) {
                        authController.registerUser();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: loginButtonEnabled
                            ? myTheme.primaryColor
                            : myTheme.primaryColor.withOpacity(0.5),
                      ),
                      height: 45,
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=> const LoginScreen());
                        },
                        child: Text("Log in", style: TextStyle(color: myTheme.primaryColor, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: authController.isLoading.value ? true : false,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  Visibility(
                    visible: authController.loginError == 'Invalid' ? true : false,
                    child: const Text(
                      'Invalid ID or Password',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Visibility(
                    visible: authController.loginError == 'Error' ? true : false,
                    child: const Text(
                      'Server error',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}