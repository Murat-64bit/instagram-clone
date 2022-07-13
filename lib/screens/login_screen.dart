import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/screens/signup_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      isLoading = false;
    });
    if (res == 'succes') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: ((context) => ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => SignupScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: MediaQuery.of(context).size.width > webScreenSize
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
          : const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          // svg image
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(
            height: 64,
          ),
          //textfield input for email
          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 10,
          ),
          //textfield input for password
          TextFieldInput(
            textEditingController: _passwordController,
            hintText: "Enter your password",
            textInputType: TextInputType.text,
            isPass: true,
          ),
          const SizedBox(
            height: 10,
          ),
          // button
          InkWell(
            onTap: loginUser,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: const Text("Log in"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor,
                    ),
                  ),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          // Transitioining to signig up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("Don't you have an account?"),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: navigateToSignup,
                child: Container(
                  child: Text(
                    "Sign up.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          )
        ],
      ),
    )));
  }
}
