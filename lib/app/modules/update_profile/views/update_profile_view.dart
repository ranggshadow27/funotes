import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funotes/app/modules/login/views/login_view.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../theme.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> userData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final roundedTextField = BorderRadius.circular(18);
    final roundedButton = BorderRadius.circular(24);
    final deviceH = MediaQuery.of(context).size.height;
    final deviceW = MediaQuery.of(context).size.width;
    controller.nameC.text = userData['username'];
    controller.emailC.text = userData['email'];

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        title: Text(
          'Update Profile.',
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
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        children: [
          RLoginTextField(
            controller: controller.nameC,
            roundedTextField: roundedTextField,
            obscureText: false,
            label: 'your name',
          ),
          SizedBox(height: 10),
          TextField(
            obscureText: false,
            controller: controller.emailC,
            style: comfortaaB.copyWith(
              color: blackFont,
              fontSize: 14,
            ),
            cursorHeight: 18,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(
                20,
              ),
              labelText: 'email',
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
              disabledBorder: OutlineInputBorder(
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
          ),
          SizedBox(height: 20),
          Text(
            "Profile Photo :",
            style: comfortaaB.copyWith(
              color: blackFont,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Image.file(
                          File(c.image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    if (userData['profile_photo'] != null &&
                        userData['profile_photo'] != "") {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 60,
                              height: 60,
                              child: Image.network(userData['profile_photo']),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.deletePhoto(userData['uid']);
                            },
                            child: Text(
                              "Delete",
                              style: comfortaaB.copyWith(
                                color: redAccent,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        "No file choosen",
                        style: comfortaaB.copyWith(
                          color: blackFont,
                          fontSize: 14,
                        ),
                      );
                    }
                  }
                },
              ),
              OutlinedButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: Text(
                  "Choose file",
                  style: comfortaaB.copyWith(
                    color: blueAccent,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
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
                      await controller.updateProfile(userData['uid']);
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
                            ? "Update Profile"
                            : "Loading..",
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
