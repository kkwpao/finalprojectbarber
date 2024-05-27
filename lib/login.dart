// ignore_for_file: use_build_context_synchronously

import 'package:finalprojectbarber/components/k_components.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool showPassword = true;
  bool isLoading = false;
  bool isBarber = false;

  late SharedPreferences login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/barber.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
                // Lottie.asset(
                //   'assets/login.json',
                //   height: MediaQuery.of(context).size.height * 0.3,
                //   width: MediaQuery.of(context).size.width * 0.7,
                // ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  'บริการช่างตัดผมนอกสถานที่',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 60,
                  child: TextFormField(
                    controller: emailController,
                    cursorColor: Colors.orangeAccent,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: kTextFormFieldDecoration.copyWith(
                      labelText: 'Email1',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 60,
                  child: TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.orangeAccent,
                    style: const TextStyle(fontSize: 18.0),
                    obscureText: showPassword,
                    decoration: kTextFormFieldDecoration.copyWith(
                        labelText: 'Password',
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: Icon(showPassword
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash))),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         CupertinoPageRoute(
                //             builder: (context) =>
                //                 const ForgetPasswordScreen()));
                //   },
                //   child: const Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(
                //       'Forget Password?',
                //       style: TextStyle(color: Colors.black),
                //     ),
                //   ),
                // ),           
                const SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  elevation: 10.0,
                  onPressed: () async {
                    login = await SharedPreferences.getInstance();
                    setState(() {
                      isLoading = true;
                    });
                    if (isBarber) {
                      try {
                        final result = loginUser(emailController.text,
                            passwordController.text, 'Barber', context);
                        if (await result) {
                          setState(() {
                            login.setString('email', emailController.text);
                            login.setString(
                                'password', passwordController.text);
                            login.setString('roll', 'Barber');
                            login.setBool('login', false);
                            isLoading = false;
                          });
                        }
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('ข้อผิดพลาด'),
                              content: Text('$e'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('ตกลง'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      // final userProfile = await FirebaseFirestore.instance
                      //     .collection('Customer')
                      //     .where('email', isEqualTo: emailController.text)
                      //     .get();

                      // if (userProfile.docs.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(content: Text('User not found')));
                      //   setState(() {
                      //     isLoading = false;
                      //   });
                      // }else{
                      if (await loginUser(emailController.text,
                          passwordController.text, 'Customer', context)) {
                        setState(() {
                          login.setString('email', emailController.text);
                          login.setString('password', passwordController.text);
                          login.setString('roll', 'Customer');
                          login.setBool('login', false);
                          isLoading = false;
                        });
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                    // }
                  },
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: const Color.fromARGB(255, 255, 183, 77),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20.0,
                                color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have account? ',
                      style: TextStyle(color: Colors.black),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      child: const Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.orangeAccent),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
