import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funotes/app/modules/login/views/login_view.dart';

import 'package:get/get.dart';

import '../../../../theme.dart';
import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    final roundedTextField = BorderRadius.circular(18);
    final roundedButton = BorderRadius.circular(24);
    final deviceH = MediaQuery.of(context).size.height;
    final deviceW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        title: Text(
          'Change Password.',
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
          Text(
            'New Password.',
            style: comfortaaB.copyWith(
              color: blackFont,
            ),
          ),
          SizedBox(height: 8),
          RLoginTextField(
              controller: controller.newPassC,
              roundedTextField: roundedTextField,
              obscureText: true,
              label: 'New Password.'),
          SizedBox(height: 20),
          Text(
            'Confirm Password.',
            style: comfortaaB.copyWith(
              color: blackFont,
            ),
          ),
          SizedBox(height: 8),
          RLoginTextField(
              controller: controller.confirmPassC,
              roundedTextField: roundedTextField,
              obscureText: true,
              label: 'Confirm New Password.'),
          SizedBox(height: 30),
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
                  onTap: () {
                    if (controller.isLoading.isFalse) {
                      controller.newPassword();
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
                            ? "Change Password"
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
