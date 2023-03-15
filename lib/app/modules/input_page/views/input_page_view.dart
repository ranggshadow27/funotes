import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funotes/app/controllers/page_index_controller.dart';
import 'package:funotes/theme.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/input_page_controller.dart';

class InputPageView extends GetView<InputPageController> {
  @override
  Widget build(BuildContext context) {
    final roundedTextField = BorderRadius.circular(22);
    final roundedButton = BorderRadius.circular(24);
    final deviceH = MediaQuery.of(context).size.height;
    final deviceW = MediaQuery.of(context).size.width;

    final pageC = Get.find<PageIndexController>();

    final iconList = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.solidUser,
    ];

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        title: Text(
          'Input Savings.',
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
          Container(
            decoration: BoxDecoration(
              color: secondaryBg,
              borderRadius: BorderRadius.circular(58),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RText(label: "Value."),
                SizedBox(height: 12),
                RValueTextField(
                  controller: controller.nomineC,
                  roundedTextField: roundedTextField,
                  maxLines: 1,
                  label: 'input your value ..',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 24),
                RText(label: "For Saving."),
                SizedBox(height: 12),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.getAllSavings(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    List<String> items = [];

                    for (var i = 0; i < snapshot.data!.docs.length; i++) {
                      DocumentSnapshot snap = snapshot.data!.docs[i];

                      items.add(snap.id.toString());
                      print(items);
                    }

                    return DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        fit: FlexFit.loose,
                        textStyle: comfortaaB.copyWith(
                          color: greyFont,
                          fontSize: 14,
                        ),
                      ),
                      items: items,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.all(
                            20,
                          ),
                          labelText: 'Select your saving.',
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
                      ),
                      onChanged: (value) {
                        print(value);
                        controller.savingC.text = value.toString();
                      },
                    );
                  },
                ),
                SizedBox(height: 24),
                RText(label: "Status."),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RStatusRadioBtn(
                      roundedTextField: roundedTextField,
                      controller: controller,
                      color: greenAccent,
                      selectedStatus: controller.isIncome,
                      reverseStatus: controller.isOutcome,
                      label: "Income",
                    ),
                    RStatusRadioBtn(
                      roundedTextField: roundedTextField,
                      controller: controller,
                      color: redAccent,
                      reverseStatus: controller.isIncome,
                      selectedStatus: controller.isOutcome,
                      label: "Outcome",
                    ),
                  ],
                ),
                SizedBox(height: 24),
                RText(label: "Notes."),
                SizedBox(height: 12),
                RValueTextField(
                  controller: controller.notesC,
                  roundedTextField: roundedTextField,
                  maxLines: 6,
                  label: 'take some notes ..',
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 36),
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
                            await controller.addValue();
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
                                  ? "Submit Data"
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
    );
  }
}

class RText extends StatelessWidget {
  const RText({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-.98, 0),
      child: Text(
        label,
        style: comfortaaB.copyWith(
          fontSize: 16,
          color: blackFont,
        ),
      ),
    );
  }
}

class RStatusRadioBtn extends StatelessWidget {
  const RStatusRadioBtn({
    Key? key,
    required this.roundedTextField,
    required this.selectedStatus,
    required this.reverseStatus,
    required this.color,
    required this.controller,
    required this.label,
  }) : super(key: key);

  final BorderRadius roundedTextField;
  final InputPageController controller;
  final RxBool selectedStatus;
  final RxBool reverseStatus;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        color: secondaryBg,
        child: InkWell(
          borderRadius: roundedTextField,
          onTap: () {
            selectedStatus.toggle();
            reverseStatus.toggle();
          },
          child: Container(
            decoration: BoxDecoration(
              color: selectedStatus.isTrue ? color : primaryBg,
              borderRadius: roundedTextField,
              border: Border.all(
                width: 2,
                color: selectedStatus.isTrue ? color : greyFont.withOpacity(.5),
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.29,
            height: 58,
            child: Center(
              child: Text(
                label,
                style: comfortaaB.copyWith(
                  color: selectedStatus.isTrue ? primaryBg : greyFont,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RValueTextField extends StatelessWidget {
  const RValueTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.label,
    required this.maxLines,
    required this.roundedTextField,
  }) : super(key: key);

  final TextEditingController controller;
  final BorderRadius roundedTextField;
  final int maxLines;
  final String label;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines,
      style: comfortaaB.copyWith(
        color: blackFont,
        fontSize: 14,
      ),
      cursorHeight: 18,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 22,
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
