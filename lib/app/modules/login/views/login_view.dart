import 'package:flutter/material.dart';
import 'package:funotes/app/routes/app_pages.dart';
import 'package:funotes/theme.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final roundedTextField = BorderRadius.circular(18);
    final roundedButton = BorderRadius.circular(24);
    final deviceH = MediaQuery.of(context).size.height;
    final deviceW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(40),
          children: [
            Container(
              height: deviceH - deviceH * .15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello. \nPlease Log In First!",
                    style: comfortaaB.copyWith(
                      color: blackFont,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 26),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 34),
                    height: deviceH * 0.54,
                    decoration: BoxDecoration(
                      color: secondaryBg,
                      borderRadius: BorderRadius.circular(48),
                      boxShadow: [
                        BoxShadow(
                          color: blackFont.withOpacity(.05),
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Email.",
                          style: comfortaaB.copyWith(
                              fontSize: 14, color: blackFont),
                        ),
                        SizedBox(height: 10),
                        RLoginTextField(
                          controller: controller.emailC,
                          roundedTextField: roundedTextField,
                          label: "your@email.com",
                          obscureText: false,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Password.",
                          style: comfortaaB.copyWith(
                              fontSize: 14, color: blackFont),
                        ),
                        SizedBox(height: 10),
                        RLoginTextField(
                          controller: controller.passC,
                          roundedTextField: roundedTextField,
                          label: "password.",
                          obscureText: true,
                        ),
                        // SizedBox(height: 10),
                        Align(
                          alignment: Alignment(.9, 0),
                          child: TextButton(
                            onPressed: () =>
                                Get.toNamed(Routes.FORGOT_PASSWORD),
                            child: Text(
                              "Lupa Password",
                              style: comfortaaB.copyWith(
                                color: redAccent,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(
                          () => Material(
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: roundedButton,
                                gradient: LinearGradient(
                                  colors: [
                                    greenButtonL,
                                    greenButtonR,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: roundedButton,
                                highlightColor: greenAccent.withOpacity(.2),
                                onTap: () async {
                                  if (controller.isLoading.isFalse) {
                                    await controller.login();
                                  }
                                },
                                child: Container(
                                  height: deviceH * .1,
                                  width: deviceW,
                                  decoration: BoxDecoration(
                                    borderRadius: roundedButton,
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.isLoading.isFalse
                                          ? "Login"
                                          : "Loading ..",
                                      style: comfortaaB.copyWith(
                                        fontSize: 16,
                                        color: primaryBg,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RLoginTextField extends StatelessWidget {
  const RLoginTextField({
    Key? key,
    required this.controller,
    required this.roundedTextField,
    required this.obscureText,
    required this.label,
  }) : super(key: key);

  final bool obscureText;
  final TextEditingController controller;
  final BorderRadius roundedTextField;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      style: comfortaaB.copyWith(
        color: blackFont,
        fontSize: 14,
      ),
      cursorHeight: 18,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(
          20,
        ),
        labelText: label,
        labelStyle: comfortaaB.copyWith(
          color: greyFont,
          fontSize: 14,
        ),
        filled: true,
        fillColor: primaryBg,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        focusedBorder: OutlineInputBorder(
          borderRadius: roundedTextField,
          borderSide: BorderSide(
            color: blueAccent,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: roundedTextField,
          borderSide: BorderSide(
            color: greyFont.withOpacity(.5),
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: roundedTextField,
        ),
      ),
    );
  }
}
