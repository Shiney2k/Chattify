import 'package:chattify/Utils/auth_methods.dart';
import 'package:chattify/Utils/user_model.dart';
import 'package:chattify/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chattify/Screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      } // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = true; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) => initWidget();

  initWidget() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? Center(
                child: Container(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: const CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                children: [
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                      color: Color.fromARGB(255, 2, 108, 179),
                      gradient: LinearGradient(
                        colors: [
                          (Color.fromARGB(255, 1, 8, 71)),
                          Color.fromARGB(255, 30, 182, 242)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Image.asset(
                            "images/app_icon.png",
                            height: 90,
                            width: 90,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 0, top: 20),
                          alignment: Alignment.center,
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        )
                      ],
                    )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 70),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: TextField(
                      controller: _email,
                      cursorColor: const Color.fromARGB(255, 2, 108, 179),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 2, 108, 179),
                        ),
                        hintText: "Enter Email",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xffEEEEEE),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 20),
                            blurRadius: 100,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: TextField(
                      controller: _password,
                      textAlignVertical: TextAlignVertical.center,
                      obscureText: _obscured,
                      cursorColor: const Color.fromARGB(255, 2, 108, 179),
                      decoration: InputDecoration(
                          focusColor: const Color.fromARGB(255, 2, 108, 179),
                          icon: const Icon(
                            Icons.vpn_key,
                            color: Color.fromARGB(255, 2, 108, 179),
                          ),
                          hintText: "Enter Password",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                _obscured
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                              ),
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        logIn(_email.text, _password.text).then((user) async {
                          if (user != null) {
                            DocumentSnapshot userData = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(user.uid)
                                .get();
                            UserModel userModel = UserModel.fromJson(userData);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(userModel)));
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            print("Login Failed!");
                            setState(() {
                              isLoading = false;
                            });
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Oops!'),
                                  content: SingleChildScrollView(
                                    child: ListBody(children: const <Widget>[
                                      Text('Sign in failed!'),
                                    ]),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                      } else {
                        print("Fill all the fields!");
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Oops!'),
                              content: SingleChildScrollView(
                                child: ListBody(children: const <Widget>[
                                  Text('Fill all the fields!'),
                                ]),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 70),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              (Color.fromARGB(255, 1, 8, 71)),
                              Color.fromARGB(255, 30, 182, 242)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey[200],
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 50,
                              color: Color(0xffEEEEEE)),
                        ],
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't Have Any Account?  "),
                        GestureDetector(
                          child: const Text(
                            "Register Now",
                            style: TextStyle(
                                color: Color.fromARGB(255, 2, 108, 179)),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ));
                          },
                        )
                      ],
                    ),
                  )
                ],
              )));
  }
}
