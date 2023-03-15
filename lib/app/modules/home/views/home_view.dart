import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funotes/app/controllers/page_index_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funotes/theme.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    final iconList = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.solidUser,
    ];

    return Scaffold(
      backgroundColor: primaryBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  Map<String, dynamic> userData = snapshot.data!.data()!;

                  String defaultAvatar =
                      "https://ui-avatars.com/api/?name=${userData['username']}&background=0D8ABC&color=fff";

                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Get.toNamed(Routes.PROFILE),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                height: 60,
                                width: 60,
                                child: Image.network(
                                  userData['profile_photo'] != null &&
                                          userData['profile_photo'] != ""
                                      ? userData['profile_photo']
                                      : defaultAvatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 22),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dashboard.",
                                style: comfortaaL.copyWith(
                                    fontSize: 14, color: blackFont),
                              ),
                              SizedBox(height: 4),
                              Text.rich(
                                TextSpan(
                                  text: 'Hi. ',
                                  style: comfortaaL.copyWith(
                                      fontSize: 14, color: blackFont),
                                  children: [
                                    TextSpan(
                                      text: userData['username'],
                                      style: comfortaaB.copyWith(
                                          fontSize: 14, color: blackFont),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My Savings",
                            style: comfortaaB.copyWith(
                                fontSize: 16, color: blackFont),
                          ),
                          IconButton(
                            onPressed: () async {
                              await controller.addNewSavings();
                            },
                            splashRadius: 24,
                            icon: Icon(
                              FontAwesomeIcons.circlePlus,
                              color: blueAccent,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                } else {
                  //tidak ada data di snapshot
                  return Center(
                    child: Text("User tidak ada?"),
                  );
                }
              },
            ),
            GetBuilder<HomeController>(
              builder: (c) =>
                  FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: controller.getAllSavings(),
                builder: (context, snapshotAllSavings) {
                  if (snapshotAllSavings.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(height: 80),
                        Text(
                          "Memuat data, sebentar ..",
                          style: comfortaaB.copyWith(
                            color: blackFont,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  }
                  if (snapshotAllSavings.data?.docs.length == 0 ||
                      snapshotAllSavings.data?.docs == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        SvgPicture.asset(
                          'assets/img/test.svg',
                          height: 200,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "No Savings Found.",
                          style: comfortaaB.copyWith(
                            color: greyFont,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Please add your saving first.",
                          style: comfortaaB.copyWith(
                            color: greyFont,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 14,
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width * 0.5,
                          mainAxisExtent:
                              MediaQuery.of(context).size.width * 0.5,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshotAllSavings.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> dataSavings =
                              snapshotAllSavings.data!.docs[index].data();

                          var formatDate = DateFormat("dd/MM/yyyy")
                              .format(DateTime.parse(dataSavings['createdAt']));

                          String formatCurrency = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: '',
                            decimalDigits: 0,
                          ).format(dataSavings['total']);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    greenDarkButtonL,
                                    greenDarkButtonR,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () => Get.toNamed(
                                  Routes.ALL_DETAILS,
                                  arguments: dataSavings,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Balance.",
                                        style: comfortaaM.copyWith(
                                          fontSize: 10,
                                          color: whiteFont,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Column(
                                        children: [
                                          Text(
                                            "Rp.",
                                            style: rajdhaniB.copyWith(
                                              fontSize: 16,
                                              color: whiteFont.withAlpha(160),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        formatCurrency,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: rajdhaniM.copyWith(
                                          fontSize: 20,
                                          color: whiteFont,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        dataSavings['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: comfortaaM.copyWith(
                                          fontSize: 12,
                                          color: whiteFont,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "${formatDate}",
                                        style: comfortaaL.copyWith(
                                          fontSize: 8,
                                          color: whiteFont,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.INPUT_PAGE),
        backgroundColor: secondaryBg,
        child: Icon(
          FontAwesomeIcons.plus,
          color: blueAccent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        inactiveColor: greyFont,
        activeColor: blackFont,
        icons: iconList,
        activeIndex: pageC.pageIndex.value,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (p0) => pageC.changePage(p0),
        //other params
      ),
    );
  }
}
