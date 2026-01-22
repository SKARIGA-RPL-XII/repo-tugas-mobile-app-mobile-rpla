import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Sec5 extends StatefulWidget {
  const Sec5({super.key});

  @override
  State<Sec5> createState() => _Sec5State();
}

const double figmaWidth = 412.0;
const double figmaHeight = 838.0;

class _Sec5State extends State<Sec5> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _header(context),
            _imageSection(context),
            _noDataText(context),
            _addRoomButton(context),
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
      height: scaleHeight(55, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'WELCOME',
            style: GoogleFonts.montserrat(
              fontSize: scaleFontSize(20, context),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
         RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'in the ',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(16, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000)
                  )
                ),

              TextSpan(
              text: 'Fin',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(16, context),
                fontWeight: FontWeight.w500,
                color: Color(0xFF00244B)
                  ),
                ),
              TextSpan(
                text: 'Track',
                style: GoogleFonts.montserrat(
                  fontSize: scaleFontSize(16, context),
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: Color(0xffFFFB00)
                )
              ),

               TextSpan(
                  text: ' application',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(16, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000)
                  )
                ),
              ]
            )
            )
        ],
      ),
    );
  }

  Widget _imageSection(BuildContext context) {
  return Positioned(
    top: scaleHeight(121, context),
    left: scaleWidth(20, context),
    child: SvgPicture.asset(
      'assets/images/imagenodata.svg',
      width: scaleWidth(300, context),
      height: scaleHeight(300, context),
    ),
  );
}


  Widget _noDataText(BuildContext context) {
    return Positioned(
      top: scaleHeight(467, context),
      left: scaleWidth(20, context),
      width: scaleWidth(372, context),
      height: scaleHeight(74, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Data',
            style: GoogleFonts.montserrat(
              fontSize: scaleFontSize(20, context),
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: scaleHeight(8, context)),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Please Click ',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(12, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000)
                  )
                ),

              TextSpan(
              text: 'Add Room or Join Room',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(12, context),
                fontWeight: FontWeight.w600,
                color: Color(0xFF00244B)
                  ),
                ),

               TextSpan(
                  text: ' to add new data',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(12, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000)
                  )
                ),
              ]
            )
            )
        ],
      ),
    );
  }

   Widget _addRoomButton(BuildContext context) {
    return Positioned(
      top: scaleHeight(555, context),
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
                  // Logika Add Room
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2E5B),
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
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2E5B),
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
                    color: Colors.white,
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
      left: scaleWidth(117, context),
      width: scaleWidth(178, context),
      height: scaleHeight(62, context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A2E5B),
          borderRadius: BorderRadius.circular(scaleWidth(100, context)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: scaleWidth(8, context),
          vertical: scaleHeight(6, context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              'assets/images/iconhome.svg',
              width: scaleWidth(24, context),
              height: scaleHeight(24, context),
              fit: BoxFit.cover,
              color: Colors.white,
            ),
            SvgPicture.asset(
              'assets/images/sms-notification.svg',
              width: scaleWidth(24, context),
              height: scaleHeight(24, context),
              fit: BoxFit.cover,
              color: Colors.white,
            ),
            SvgPicture.asset(
              'assets/images/category-2.svg',
              width: scaleWidth(24, context),
              height: scaleHeight(24, context),
              fit: BoxFit.cover,
              color: Colors.white,
            ),
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