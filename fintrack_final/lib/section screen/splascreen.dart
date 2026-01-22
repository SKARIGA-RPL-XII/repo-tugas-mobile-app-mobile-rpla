import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Sec2 extends StatefulWidget {
  const Sec2({super.key});

  @override
  State<Sec2> createState() => _Sec2State();
}
const double figmaWidth = 412.0;
const double figmaHeight = 917.0;

class _Sec2State extends State<Sec2> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF00244B),

      body: Stack(
        children: [
          _logo(context),
          _ilustration(context),
          _backgrundcard( context),
          _lolbot(context)
        ],
      ),
      ),
    );
  }

  Widget _logo(BuildContext context){
    return Positioned(
      top: scaleHeight(148, context),
      left: scaleWidth(115.75, context),
      width: scaleWidth(190, context),
      height: scaleHeight(48, context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Fin',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(39.78, context),
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            ),
            TextSpan(
              text: 'Track',
              style: GoogleFonts.montserrat(  
                fontSize: scaleFontSize(39.78, context),
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: Color(0xFFfffB00)
              )
            )
          ]
        )
        )
    );
  }

  Widget _ilustration(BuildContext context){
    return Positioned(
      top: scaleHeight(347, context),
      left: scaleWidth(18, context),
      width: scaleWidth(375, context),
      height: scaleHeight(345, context),
      child: Container(
          decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.15), 
            blurRadius: 40,              
            spreadRadius: -10,           
            offset: const Offset(0, 20), 
          ),
        ],
      ),
        child: SvgPicture.asset(
          'assets/images/image_frame2.svg',
        fit: BoxFit.cover,
            ),
      ),
      );
  }

  Widget _lolbot(BuildContext context){
    return Positioned(
      top: scaleHeight(671.99, context),
      left: scaleWidth(18, context),
      width: scaleWidth(378, context),
      height: scaleHeight(213.77, context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(scaleWidth(40, context)) 
        ),

        padding: EdgeInsets.only(
          top: scaleHeight(22.02, context),
          bottom: scaleHeight(22.02, context),
          left: scaleWidth(16, context),
          right: scaleWidth(16, context)
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _indicator(context),
            SizedBox(height: scaleHeight(16, context)),
          Text(
            'Solusi cerdas keuangan industri',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: scaleFontSize(16, context),
              color: Color(0xff00244B)
            ),
          ),

          SizedBox(height: scaleHeight(8, context)),

          Text(
            'Kelola anggaran, transaksi, dan laporan keuangan perusahaan secara digital dan akurat',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400,
              fontSize: scaleFontSize(12.84, context),
              color: Color(0xff858D9D)
            ),
          ),
          SizedBox(height: scaleHeight(16, context)),
          _buttonNext(context)
          ],
        ),
      )
      );
  }

  Widget _indicator(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(false, context),
        _dot(true, context),
        _dot(false, context)
      ],
    );
  }

  Widget _dot(bool active, BuildContext context) {
      return Container(
        margin:  EdgeInsets.symmetric(horizontal: scaleWidth(4, context)),
        width: active ? scaleWidth(16, context) : scaleWidth(6, context),
        height: scaleHeight(6, context),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(scaleWidth(6, context))
        ),
      );
  }

  Widget _buttonNext(BuildContext context){
    return GestureDetector(
      onTap: (){
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut
          );
      },

      child: Container(
        width: scaleWidth(346, context),
        height: scaleHeight(48, context),
        decoration: BoxDecoration(
          color: Color(0xff00244B),
          borderRadius: BorderRadius.circular(scaleWidth(100, context))
        ),
        padding: EdgeInsets.symmetric(
          horizontal: scaleWidth(10, context),
          vertical: scaleHeight(8, context)
          ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: scaleWidth(32, context),
              height: scaleHeight(32, context),
              child: SvgPicture.asset(
                'assets/images/Button1.svg',
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _backgrundcard(BuildContext context){
    return Positioned(
      top: scaleHeight(728, context),
      left: scaleWidth(-5, context),
      child: Container(
        width: scaleWidth(423, context),
        height: scaleHeight(189, context),
        decoration: BoxDecoration(
          color: Color(0xFFF2F4F7),
        ),
      )
    );
  }

  //screen start
  double getScaleWidth(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth / figmaWidth;
  }

  double getScaleHeight(BuildContext context){
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight / figmaHeight;
  }

  double scaleWidth(double figmavalue, BuildContext context){
    return figmavalue * getScaleWidth(context);
  }

  double scaleHeight(double figmavalue, BuildContext context){
    return figmavalue * getScaleHeight(context);
  }

  double scaleFontSize(double figmaFontsize, BuildContext context){
    final scaleX = getScaleWidth(context);
    final scaleY = getScaleHeight(context);
    return figmaFontsize * (scaleX + scaleY) / 2;
  }
  //screen end 
}