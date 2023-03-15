import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/all_details_controller.dart';

class AllDetailsView extends GetView<AllDetailsController> {
  Map<String, dynamic> dataTotalSaving = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: "id_ID",
      symbol: '',
      decimalDigits: 0,
    ).format(
      dataTotalSaving['total'],
    );

    final dateFormat = DateFormat("dd/MM/yyyy").format(
      DateTime.parse(
        dataTotalSaving['createdAt'],
      ),
    );

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        title: Text(
          'Transaction.',
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
        padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .24,
            padding: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [greenDarkButtonL, greenDarkButtonR],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: blackFont.withOpacity(.1),
                  blurRadius: 10,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Balance.",
                      style: comfortaaM.copyWith(
                        fontSize: 12,
                        color: primaryBg.withOpacity(.8),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Get.defaultDialog(
                        backgroundColor: primaryBg,
                        title: "Confirm",
                        titleStyle:
                            comfortaaB.copyWith(color: blackFont, fontSize: 16),
                        middleText:
                            "Are you sure to Delete '${dataTotalSaving['name']}' ?",
                        middleTextStyle:
                            comfortaaM.copyWith(color: blackFont, fontSize: 14),
                        contentPadding: EdgeInsets.all(20),
                        confirm: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redButtonR,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            await controller.deleteSavings();
                          },
                          child: Text(
                            "Delete.",
                            style: comfortaaM.copyWith(
                                color: primaryBg, fontSize: 14),
                          ),
                        ),
                        cancel: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: Text(
                            "Cancel.",
                            style: comfortaaM.copyWith(
                                color: blackFont, fontSize: 14),
                          ),
                        ),
                      ),
                      child: Icon(
                        FontAwesomeIcons.xmark,
                        size: 16,
                        color: redAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    text: "Rp.  ",
                    style: rajdhaniB.copyWith(
                      color: primaryBg.withOpacity(.6),
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "${currencyFormat}",
                        style: rajdhaniM.copyWith(
                          color: primaryBg,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "${dateFormat}",
                  style: comfortaaM.copyWith(
                    fontSize: 12,
                    color: primaryBg.withOpacity(.6),
                  ),
                ),
                SizedBox(height: 12),
                Center(
                  child: Text(
                    "${dataTotalSaving['name']}",
                    style: comfortaaSB.copyWith(
                      fontSize: 12,
                      color: primaryBg,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<AllDetailsController>(
            builder: (c) => FutureBuilder(
              future: controller.getSavingDetails(),
              builder: (context, snapshotSavingDetails) {
                if (snapshotSavingDetails.connectionState ==
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
                if (snapshotSavingDetails.data?.docs.length == 0 ||
                    snapshotSavingDetails.data?.docs.length == null) {
                  return Column(
                    children: [
                      SizedBox(height: 80),
                      Center(
                        child: Text(
                          "Belum ada nabung nabung ni bos",
                          style: comfortaaB.copyWith(
                            color: blackFont,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "History",
                      style: comfortaaB.copyWith(
                        fontSize: 16,
                        color: blackFont,
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      itemCount: snapshotSavingDetails.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> dataSavings =
                            snapshotSavingDetails.data!.docs[index].data();

                        var formatCurrency = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp. ',
                          decimalDigits: 0,
                        ).format(dataSavings['value']);

                        var dateFormat = DateFormat("dd/MM/yyyy HH:mm")
                            .format(DateTime.parse(dataSavings['createdAt']));

                        String status = dataSavings['status'];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Material(
                            color: primaryBg,
                            borderRadius: BorderRadius.circular(26),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(26),
                              onTap: () => Get.toNamed(
                                Routes.DETAILS,
                                arguments: dataSavings,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 74,
                                          height: 74,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: status == "Income"
                                                  ? [greenButtonL, greenButtonR]
                                                  : [redButtonL, redButtonR],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(26),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              status == "Income"
                                                  ? 'assets/icons/income.svg'
                                                  : 'assets/icons/outcome.svg',
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 22),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              status == "Income"
                                                  ? "+ ${formatCurrency}"
                                                  : "- ${formatCurrency}",
                                              style: comfortaaB.copyWith(
                                                color: blackFont,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .5,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${dataSavings['status']}",
                                                    style: comfortaaB.copyWith(
                                                      color: greyFont,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    child: Text(
                                                      "${dateFormat}",
                                                      style:
                                                          comfortaaB.copyWith(
                                                        color: greyFont,
                                                        fontSize: 14,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Text("${dataSavings['savings']}"),
                                    // Text("${dataSavings['notes']}"),
                                    // Text("${dateFormat}"),
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.INPUT_PAGE),
        backgroundColor: secondaryBg,
        child: Icon(
          FontAwesomeIcons.plus,
          color: blueAccent,
        ),
      ),
    );
  }
}
