import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:funotes/app/controllers/page_index_controller.dart';
import 'package:funotes/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../../../../theme.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  final iconList = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.solidUser,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Center(
              child: Text(
                'Profile.',
                style: comfortaaB.copyWith(
                  color: blackFont,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                userData['profile_photo'] != null
                                    ? userData['profile_photo'] != ""
                                        ? userData['profile_photo']
                                        : defaultAvatar
                                    : defaultAvatar,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text.rich(
                        TextSpan(
                          text: 'Hi. ',
                          style: comfortaaL.copyWith(
                            fontSize: 16,
                            color: blackFont,
                          ),
                          children: [
                            TextSpan(
                              text: '${userData['username']}',
                              style: comfortaaB.copyWith(
                                fontSize: 16,
                                color: blackFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "${userData['email']}",
                        style: comfortaaB.copyWith(
                          color: blackFont,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Divider(
                          color: greyFont.withAlpha(50),
                          thickness: 2,
                        ),
                      ),
                      SizedBox(height: 30),
                      RCardWidget(
                        text: 'Update Profile.',
                        userData: userData,
                        routes: Routes.UPDATE_PROFILE,
                      ),
                      RCardWidget(
                        text: 'Update Password.',
                        userData: userData,
                        routes: Routes.UPDATE_PASSWORD,
                      ),
                      RCardWidget(
                        text: 'My Savings.',
                        userData: userData,
                        routes: Routes.UPDATE_PASSWORD,
                      ),
                      if (userData['email'] == "ranggicaa@ever.com")
                        RCardWidget(
                          text: 'Add User.',
                          userData: userData,
                          routes: Routes.REGISTER_USER,
                        ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [redButtonL, redButtonR],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(26),
                            onTap: () {
                              controller.signOut();
                            },
                            child: Container(
                              height: 68,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'Logout.',
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
                    ],
                  );
                } else {
                  return Center(
                    child: Text("Gagal memuat informasi user"),
                  );
                }
              },
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

class RCardWidget extends StatelessWidget {
  const RCardWidget({
    Key? key,
    required this.routes,
    required this.userData,
    required this.text,
  }) : super(key: key);

  final Map<String, dynamic> userData;
  final String routes;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              width: 2,
              color: greyFont.withAlpha(50),
            ),
          ),
          onTap: () {
            Get.toNamed(routes, arguments: userData);
          },
          title: Text(
            text,
            style: comfortaaB.copyWith(fontSize: 14, color: blackFont),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
