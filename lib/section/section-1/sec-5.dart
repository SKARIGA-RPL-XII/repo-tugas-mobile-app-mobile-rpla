import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Header Section
            Positioned(
              top: scaleHeight(38, context),
              left: scaleWidth(14, context),
              child: Container(
                width: scaleWidth(378, context),
                height: scaleHeight(55, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME',
                      style: TextStyle(
                        fontSize: scaleFontSize(24, context),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'in the FinTrack application',
                      style: TextStyle(
                        fontSize: scaleFontSize(16, context),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Image Section
            Positioned(
              top: scaleHeight(121, context),
              left: scaleWidth(20, context),
              child: SvgPicture.asset(
                'assets/images/nodataimg.svg',
                width: scaleWidth(372, context),
                height: scaleHeight(372, context),
              ),
            ),

            // No Data Text Section
            Positioned(
              top: scaleHeight(467, context),
              left: scaleWidth(20, context),
              child: Container(
                width: scaleWidth(372, context),
                height: scaleHeight(74, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No Data',
                      style: TextStyle(
                        fontSize: scaleFontSize(20, context),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: scaleHeight(8, context)),
                    Text(
                      'Please click Add Room to add new data.',
                      style: TextStyle(
                        fontSize: scaleFontSize(14, context),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add Room Button
            Positioned(
              top: scaleHeight(555, context),
              left: scaleWidth(16, context),
              child: Container(
                width: scaleWidth(380, context),
                height: scaleHeight(40, context),
                child: ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika untuk menambahkan room
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A2E5B), // Warna biru tua sesuai gambar
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(scaleWidth(8, context)),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: scaleWidth(24, context),
                      vertical: scaleHeight(8, context),
                    ),
                  ),
                  child: Text(
                    'Add Room',
                    style: TextStyle(
                      fontSize: scaleFontSize(16, context),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              top: scaleHeight(755, context),
              left: scaleWidth(88, context),
              child: Container(
                width: scaleWidth(236, context),
                height: scaleHeight(62, context),
                decoration: BoxDecoration(
                  color: Color(0xFF0A2E5B), // Warna biru tua
                  borderRadius: BorderRadius.circular(scaleWidth(99999997952, context)), // Radius besar untuk membuat oval
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: scaleWidth(8, context),
                  vertical: scaleHeight(6, context),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.home, color: Colors.white, size: scaleFontSize(24, context)),
                    Icon(Icons.calendar_today, color: Colors.white, size: scaleFontSize(24, context)),
                    Icon(Icons.email, color: Colors.white, size: scaleFontSize(24, context)),
                    Icon(Icons.grid_view, color: Colors.white, size: scaleFontSize(24, context)),
                  ],
                ),
              ),
            ),
            
          ],
        ),
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