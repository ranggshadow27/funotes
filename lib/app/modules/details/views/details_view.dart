import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../theme.dart';
import '../controllers/details_controller.dart';

class DetailsView extends GetView<DetailsController> {
  Map<String, dynamic> dataSavings = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final roundedButton = BorderRadius.circular(24);
    final deviceH = MediaQuery.of(context).size.height;
    final deviceW = MediaQuery.of(context).size.width;

    final dateFormat = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(dataSavings['createdAt']));

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(dataSavings['value']);

    final status = dataSavings['status'];

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        title: Text(
          'Transaction Details.',
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
            padding: EdgeInsets.all(35),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(58),
              color: secondaryBg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          status == "Income"
                              ? 'assets/icons/income.svg'
                              : 'assets/icons/outcome.svg',
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 120,
                      child: Text(
                        status == "Income"
                            ? "+ ${currencyFormat}"
                            : "- ${currencyFormat}",
                        style: comfortaaB.copyWith(
                          color: blackFont,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 23),
                Divider(
                  thickness: 3,
                  color: primaryBg,
                ),
                SizedBox(height: 33),
                RDetailsText(
                  dateFormat: dateFormat,
                  title: 'Date Created:',
                  label: dateFormat,
                  color: blackFont,
                ),
                SizedBox(height: 16),
                RDetailsText(
                  dateFormat: dateFormat,
                  title: 'Status:',
                  label: status,
                  color: status == "Income" ? greenAccent : redAccent,
                ),
                SizedBox(height: 16),
                RDetailsText(
                  dateFormat: dateFormat,
                  title: 'For Saving:',
                  label: dataSavings['savings'],
                  color: blackFont,
                ),
                SizedBox(height: 16),
                Text(
                  "Note :",
                  style: comfortaaB.copyWith(
                    fontSize: 14,
                    color: blackFont,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  dataSavings['notes'],
                  style: comfortaaB.copyWith(
                    fontSize: 14,
                    color: greyFont,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 50),
                Material(
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: roundedButton,
                      gradient: LinearGradient(
                        colors: [
                          redButtonL,
                          redButtonR,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: roundedButton,
                      highlightColor: greenAccent.withOpacity(.2),
                      onTap: () => Get.back(),
                      child: Container(
                        height: deviceH * .1,
                        width: deviceW,
                        decoration: BoxDecoration(
                          borderRadius: roundedButton,
                        ),
                        child: Center(
                          child: Text(
                            "Back to Transaction",
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
            ),
          ),
        ],
      ),
    );
  }
}

class RDetailsText extends StatelessWidget {
  const RDetailsText({
    Key? key,
    required this.dateFormat,
    required this.label,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String dateFormat;
  final String title;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: comfortaaB.copyWith(
            fontSize: 14,
            color: blackFont,
          ),
        ),
        Spacer(),
        Container(
          width: 100,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: comfortaaB.copyWith(
              fontSize: 14,
              color: color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
