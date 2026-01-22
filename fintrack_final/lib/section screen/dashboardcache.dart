import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sec6 extends StatefulWidget {
  const Sec6({super.key});

  @override
  State<Sec6> createState() => _Sec6State();
}

const double figmaWidth = 412.0;
const double figmaHeight = 838.0;

class _Sec6State extends State<Sec6> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _header(context),
            _card1(context),
            _card2(context),
            _roomButtons(context),
            _bottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Positioned(
      top: scaleHeight(38, context),
      left: scaleWidth(14, context),
      width: scaleWidth(378, context),
      height: scaleHeight(49, context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'WELCOME\n',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(24, context),
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: 'in the ',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(16, context),
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
            TextSpan(
              text: 'Fin',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(16, context),
                fontWeight: FontWeight.w500,
                color: Color(0xFF00244B),
              ),
            ),
            TextSpan(
              text: 'Track',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(16, context),
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                color: Color(0xFFFFFB00),
              ),
            ),
            TextSpan(
              text: ' application',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(16, context),
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card1(BuildContext context) {
    return Positioned(
      top: scaleHeight(100, context),
      left: scaleWidth(16, context),
      width: scaleWidth(381, context),
      height: scaleHeight(72, context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(scaleWidth(8, context)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: scaleWidth(16, context),
          vertical: scaleHeight(12, context),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PT Maju Jaya Sejahtera',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(14, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF323232),
                  ),
                ),
                SizedBox(height: scaleHeight(4, context)),
                Row(
                  children: [
                    Text(
                      'CODE ROOM ',
                      style: GoogleFonts.montserrat(
                        fontSize: scaleFontSize(10, context),
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA3A3A3),
                      ),
                    ),
                    Text(
                      'X4FY70E',
                      style: GoogleFonts.montserrat(
                        fontSize: scaleFontSize(10, context),
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00244B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              'Owner',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(10, context),
                fontWeight: FontWeight.w400,
                color: Color(0xFFA3A3A3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card2(BuildContext context) {
    return Positioned(
      top: scaleHeight(180, context),
      left: scaleWidth(16, context),
      width: scaleWidth(381, context),
      height: scaleHeight(72, context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(scaleWidth(8, context)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: scaleWidth(16, context),
          vertical: scaleHeight(12, context),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PT Indonesia Maju',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(14, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF323232),
                  ),
                ),
                SizedBox(height: scaleHeight(4, context)),
                Row(
                  children: [
                    Text(
                      'CODE ROOM ',
                      style: GoogleFonts.montserrat(
                        fontSize: scaleFontSize(10, context),
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA3A3A3),
                      ),
                    ),
                    Text(
                      'SH367',
                      style: GoogleFonts.montserrat(
                        fontSize: scaleFontSize(10, context),
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00244B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              'Owner',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(10, context),
                fontWeight: FontWeight.w400,
                color: Color(0xFFA3A3A3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roomButtons(BuildContext context) {
    return Positioned(
      top: scaleHeight(260, context),
      left: scaleWidth(16, context),
      width: scaleWidth(380, context),
      height: scaleHeight(40, context),
      child: Row(
        children: [

          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: scaleWidth(8, context)),
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0A2E5B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(scaleWidth(8, context)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: scaleWidth(16, context),
                    vertical: scaleHeight(8, context),
                  ),
                ),
                child: Text(
                  'Add Room',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(16, context),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: scaleWidth(8, context)),
              child: OutlinedButton(
                onPressed: () {
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF0A2E5B)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(scaleWidth(8, context)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: scaleWidth(16, context),
                    vertical: scaleHeight(8, context),
                  ),
                ),
                child: Text(
                  'Join Room',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(16, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0A2E5B),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Positioned(
      top: scaleHeight(755, context),
      left: scaleWidth(88, context),
      width: scaleWidth(236, context),
      height: scaleHeight(62, context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0A2E5B),
          borderRadius: BorderRadius.circular(scaleWidth(100, context)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: scaleWidth(8, context),
          vertical: scaleHeight(6, context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.white, size: scaleFontSize(24, context)),
            Icon(Icons.email, color: Colors.white, size: scaleFontSize(24, context)),
            Icon(Icons.grid_view, color: Colors.white, size: scaleFontSize(24, context)),
          ],
        ),
      ),
    );
  }

  double getScaleWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth / figmaWidth;
  }

  double getScaleHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight / figmaHeight;
  }

  double scaleWidth(double figmaValue, BuildContext context) {
    return figmaValue * getScaleWidth(context);
  }

  double scaleHeight(double figmaValue, BuildContext context) {
    return figmaValue * getScaleHeight(context);
  }

  double scaleFontSize(double figmaFontSize, BuildContext context) {
    final scaleX = getScaleWidth(context);
    final scaleY = getScaleHeight(context);
    return figmaFontSize * (scaleX + scaleY) / 2;
  }
}