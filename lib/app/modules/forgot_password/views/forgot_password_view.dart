import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funotes/app/modules/login/views/login_view.dart';
import 'package:funotes/theme.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    final roundedTextField = BorderRadius.circular(18);
    final roundedButton = BorderRadius.circular(24);
    final deviceH = MediaQuery.of(context).size.height;
    final deviceW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password.',
          style: comfortaaB.copyWith(
            fontSize: 16,
            color: blackFont,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(FontAwesomeIcons.arrowLeft),
          color: blackFont,
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: primaryBg,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(40),
        children: [
          RLoginTextField(
              controller: controller.emailC,
              roundedTextField: roundedTextField,
              obscureText: false,
              label: 'your@email.com'),
          SizedBox(height: 20),
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
                      await controller.forgotPassword();
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
                            ? "Reset Password"
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
          ),
        ],
      ),
    );
  }
}
