import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Sect1 extends StatefulWidget {
  const Sect1({super.key});

  @override
  State<Sect1> createState() => _Sect1State();
}

const double figmaWidth = 412.0;
const double figmaHeight = 917.0;


class _Sect1State extends State<Sect1> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF00244B),

    body: Stack(
      children: [
        Positioned(
          top: scaleHeight(-40, context),
          left: scaleWidth(0, context),
          right: scaleWidth(0, context),
          child: SvgPicture.asset(
            'assets/images/wave_bottom.svg',
            fit: BoxFit.cover,
          ),
          ),

        Positioned(
          top: scaleHeight(500, context),
          right: scaleWidth(0, context),
          left: scaleWidth(-83, context),
          child: SvgPicture.asset(
            'assets/images/wave_top.svg',
            fit: BoxFit.cover,
          )
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Fin',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: scaleFontSize(52, context),
                        color: Colors.white
                      )
                    ),
                    TextSpan(
                      text: 'Track',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        fontSize: scaleFontSize(52, context),
                        color: Color(0xFFfffB00)
                      )
                    ),
                  ]
                )
                ),
                SizedBox(height: scaleHeight(20, context)),
                  Text(
                    'Aplikasi Pengelola Perusahaan anda',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w300,
                      fontSize: scaleFontSize(20, context),
                      color: Colors.white
                    ),
                  ),
            ],
          ),
        
        ),
     

      ],
    ),
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