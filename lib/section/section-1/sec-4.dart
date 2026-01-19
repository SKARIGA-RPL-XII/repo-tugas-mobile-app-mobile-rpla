import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Sec4 extends StatefulWidget {
  const Sec4({super.key});

  @override
  State<Sec4> createState() => _Sec4State();
}

const double figmaWidth = 412.0;
const double figmaHeight = 917.0;


class _Sec4State extends State<Sec4> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            SizedBox(height: scaleHeight(24, context)),
            _stepindicator(context),
            Expanded(child: _buildstepcontent(context)),
            _bottomButton(context)
          ],
        ),
      ),
      ),
    );
  }

  Widget _header(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(scaleWidth(16, context), scaleHeight(15, context), scaleWidth(16, context), scaleHeight(16, context)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: (){}, 
              icon: Icon(
                Icons.arrow_back,
                size: scaleFontSize(20, context),
                color: Color(0xFF00244B),
              ),
              ),
          ),
          Text(
            'Form Add Room',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: scaleFontSize(20, context),
              color: Color(0xFF00244B)
            ),
          )
        ],
      ),
      );
       
  }

  //step 1 - 3 start
  Widget _stepindicator(BuildContext contex){
    const double circleradius = 20.0;
    const double horizontalpadiing = 60.0;
    final double circleY = scaleHeight(circleradius, context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: scaleHeight(24, contex)),
      child: SizedBox(
        height: scaleHeight(90, context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: circleY,
              left: scaleWidth(horizontalpadiing + circleradius, context),
              right: scaleWidth(horizontalpadiing + circleradius, context),
              child: Center(
                child: SizedBox(
                  height: scaleHeight(1.5, context),
                  child: Container(
                    color: Colors.grey.shade300,
                  ),
                ),
              )
              ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: scaleWidth(horizontalpadiing, context),
                  ), 
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index){
                    final isActive = index == currentStep;
                    return  _stepCircle(index + 1, isActive);
                         
                          }),
                        ),
                ),
          ],
        ),
      ),

    
    );
  }

  Widget _stepCircle(int number, bool active){
    return Column(
      children: [
        CircleAvatar(
          radius: scaleWidth(20, context),
          backgroundColor: active ? Color(0xFF00244B) : Color(0xFFE0E0E0),
          child: Text(
            '$number',
            style: GoogleFonts.montserrat(
              color: active ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w700,
              fontSize: scaleFontSize(12, context)
            ),
          ),
        ),
         SizedBox(height: scaleHeight(8, context)),
         Text(
          ['Room', 'User', 'Finish'][number - 1],
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: active ? Color(0xFF00244B) : Colors.grey
          ),
         )
      ],
    );
  }

  Widget _buildstepcontent(BuildContext contex){
    switch(currentStep){
      case 0:
        return _stepRoom(contex);
      case 1:
        return _stepUser(context);
      case 2:
        return _stepFinish(context);
      default:
        return Center(
          child: Text('Finish Step'),
        );
    }
  }

  Widget _stepRoom(BuildContext contex){
    return Padding(
      padding: EdgeInsets.all(scaleWidth(16, contex)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Room Name / Company',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: 12
          ),
          ),
          SizedBox(height: scaleHeight(8, context)),
          TextField(
            decoration: InputDecoration(
              hintText: 'Input Here...',
              hintStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: scaleFontSize(15, context),
                color: Colors.grey
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(scaleWidth(20, context)),
                borderSide: BorderSide(
                  color: Colors.grey.shade300
                )
              )
            ),
          )
        ],
      ),
      );
  }

  Widget _stepUser(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(scaleWidth(16, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Admin',),
          SizedBox(height: scaleHeight(8, context)),
          _readonly('alwanad28@gmail.com (You)'),

          SizedBox(height: scaleHeight(16, context)),
          Text('User'),
          SizedBox(height: scaleHeight(8, context)),

          GestureDetector(
            onTap: () => _showAddusersheet(context),
            child: _dropdown('Select User'),
          )

        ],
      ),
    );
  }

  Widget _dropdown(String text){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: scaleWidth(12, context),
        vertical: scaleHeight(14, context),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(scaleWidth(8, context))
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey
              ))),
          Icon(Icons.keyboard_arrow_down,)
        ],
      ),
    );
  }
  Widget _readonly(String text){
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: scaleWidth(12, context),
        vertical: scaleHeight(14, context),
      ),
      decoration: BoxDecoration(
        color: Color(0xFFE5E7EB),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(scaleWidth(8, context))
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey
              ))),
        ],
      ),
    );
  }

  void _showAddusersheet(BuildContext context){
     showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(scaleWidth(16, context))),
      ),
      builder: (_){
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: _addusercontent(context),
          );
      }
      );
  }

  Widget _addusercontent(BuildContext contexxt){
    return Container(
      width: scaleWidth(380, context),
      padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(scaleWidth(8, context)),
        border: Border.all(color: Colors.grey.shade300)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _search(context),
          SizedBox(height: scaleHeight(16, context)),
          _userlist(context),
          SizedBox(height: scaleHeight(16, context)),
          _adduserbutton(context)
        ],
      ),
    );
  }

  Widget _search(BuildContext context){
    return Container(
      height: scaleHeight(40, context),
      padding: EdgeInsets.symmetric(
        horizontal: scaleWidth(12, context),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(scaleWidth(20, context))
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){},
            child: SvgPicture.asset(
              'assets/images/search-normal.svg',
              width: scaleWidth(18, context),
              height: scaleHeight(18, context),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: scaleWidth(12, context)),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                isDense: true
              ),
            )
            )
        ],
      ),
    );
  }

  Widget _userlist(BuildContext context){
    final list = [
        {'name': 'Achmad Zaeni', 'email': 'achmadzaeni@gmail.com'},
        {'name': 'Asyifaul Huda', 'email': 'nudasyaiful@gmail.com'},
        {'name': 'Raysha Al-Fatihah', 'email': 'rayshaal@gmail.com'},
        {'name': 'Naufal Fatihul', 'email': 'naufalfatihul@gmail.com'},
    ];

    return Column(
      children: list.map((user){
        return Padding(
          padding: EdgeInsets.only(bottom: scaleHeight(12, context)),
          child: Row(
            children: [
              CircleAvatar(radius: scaleWidth(18, context)),
              SizedBox(width: scaleWidth(12, context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['name']!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: scaleFontSize(10, context)
                      ),
                      ),
                    Text(user['email']!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: scaleFontSize(10, context),
                        color: Colors.grey
                      ),
                      ),
                  ],
                ),
              ),
              Checkbox(
                value: false, 
                onChanged: (_){}
                ),
            ],
          ),
          );
      }).toList(),
    );
}

  Widget _adduserbutton(BuildContext context){
    return SizedBox(
      width: double.infinity,
      height: scaleHeight(40, context),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00244B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scaleWidth(8, context))
          )
        ),
        onPressed: (){}, 
        child: Text('Add User',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          fontSize: scaleFontSize(14, context),
          color: Colors.white
        )
        ),
      )
    );
  }

  Widget _bottomButton(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(scaleWidth(16, context)),
      child: Row(
        children: [
          if(currentStep > 0)
            Expanded(
              child: OutlinedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(scaleWidth(8, context))
                    )
                  ),
                ),
                onPressed: () {
                  setState(() {
                    currentStep--;
                  });
                },
                child: Text('Previously',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: scaleFontSize(14, context),
                  color: Color(0xFF00244B),
                )
                )
                ),
              ),
              if(currentStep > 0 ) SizedBox(width: scaleWidth(12, context)),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00244B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(scaleWidth(8, context))
                    )
                  ),
                  onPressed: (){
                    if(currentStep < 2){
                      setState(() {
                        currentStep++;
                      });
                    }else if(currentStep == 2){
                      _showDialog(context);
                    }
                  }, 
                  child: Text(currentStep == 2 ? 'Send': 'Next',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: scaleFontSize(14, context),
                    color: Colors.white
                  ),
                  ),
                  ),
              )
        ],
      ),
    );
  }

  Widget _stepFinish(BuildContext context){
     final list = [
        {'name': 'Achmad Zaeni', 'email': 'achmadzaeni@gmail.com'},
        {'name': 'Asyifaul Huda', 'email': 'nudasyaiful@gmail.com'},
        {'name': 'Raysha Al-Fatihah', 'email': 'rayshaal@gmail.com'},
        {'name': 'Naufal Fatihul', 'email': 'naufalfatihul@gmail.com'},
    ];
    return Positioned(
      width: scaleWidth(380, context),
      height: scaleHeight(666, context),
      top: scaleHeight(220, context),
      left: scaleWidth(16, context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: scaleWidth(16, context),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/general-logo.svg',
                  width: scaleWidth(24, context),
                  height: scaleHeight(24, context),
                  fit: BoxFit.cover,
                ),
              SizedBox(width: scaleWidth(8, context)),
                Text(
                  'General Information',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: scaleFontSize(16, context
                  ),
                )
                ),
              ],
            ),
        
            SizedBox(height: scaleHeight(16, context)),
        
          Container(
          width: scaleWidth(380, context),
          decoration: BoxDecoration(
            color: Color(0xFFE6E9EF),
            borderRadius: BorderRadius.circular(scaleWidth(8, context))
          ),
        
        padding: EdgeInsets.only(
          left: scaleWidth(14, context),
          top: scaleHeight(16, context),
          bottom: scaleHeight(14, context),
          right: scaleWidth(14, context)
        ),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PT Moro Seneng Sejahtera',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(12, context),
                fontWeight: FontWeight.w600,
                color: Color(0xFF323232)
              ),
            ),
        
            SizedBox(height: scaleHeight(8, context)),
        
          Row(
            children: [
              Container(
                width: scaleWidth(23, context),
                height: scaleHeight(23, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(scaleWidth(100, context)),
                  color: Colors.pink
                ),
              ),
        
              SizedBox(width: scaleWidth(4, context)),
        
              RichText(
                text: TextSpan(
                  children:[
                    TextSpan(
                      text: 'Parpanss M',
                      style: GoogleFonts.montserrat(
                        fontSize: scaleFontSize(10, context),
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF323232)
                      )
                    ),
        
                    TextSpan(
                      text: ' - farfan28@gmail.com',
                      style: GoogleFonts.montserrat(
                        fontSize: scaleFontSize(10, context),
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA3A3A3)
                      )
                    )
                  ] 
                )
                ),
        
                Spacer(),
        
                Text(
                  'Owner',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(10, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFA3A3A3)
                  ),
                )
        
            ],
          )
          ],
        ),
        ),
        
        SizedBox(height: scaleHeight(16, context)),
        
        Row(
          children: [
               SvgPicture.asset(
                  'assets/images/user_logo.svg',
                  width: scaleWidth(24, context),
                  height: scaleHeight(24, context),
                  fit: BoxFit.cover,
                ),
                SizedBox(width: scaleWidth(8, context)),
            Text(
              'User List',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: scaleFontSize(16, context)
              ),
            ),
          ],
        ),
        
        SizedBox(height: scaleHeight(10, context)),
        
        Container(
          width: scaleWidth(380, context),
          height: scaleHeight(225, context),
          decoration: BoxDecoration(
            color: Color(0xFFE6E9EF),
            borderRadius: BorderRadius.circular(scaleWidth(8, context))
          ),
          padding: EdgeInsets.only(
            left: scaleWidth(14, context),
            top: scaleHeight(16, context),
            bottom: scaleHeight(14, context),
            right: scaleWidth(14, context)
          ),
          child: Column(
        children: list.map((user){
          return Padding(
            padding: EdgeInsets.only(bottom: scaleHeight(12, context)),
            child: Row(
              children: [
                CircleAvatar(radius: scaleWidth(18, context)),
                SizedBox(width: scaleWidth(12, context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name']!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: scaleFontSize(10, context)
                        ),
                        ),
                      Text(user['email']!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: scaleFontSize(10, context),
                          color: Colors.grey
                        ),
                        ),
                    ],
                  ),
                ),
        
              ],
            ),
            );
        }).toList(),
            ),
        ),
          ],
        ),
      )
      );
  }

  //modal notification

  Widget _notifsubmit({required BuildContext context, required VoidCallback onConfirm, required VoidCallback onCancel}){
    return Container(
      width: scaleWidth(358, context),
      height: scaleHeight(272, context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(scaleWidth(12, context)),
      ),
      padding: EdgeInsets.only(
        top: scaleHeight(32, context),
        bottom: scaleHeight(32, context),
        left: scaleWidth(24, context),
        right: scaleWidth(24, context)
      ),

      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/notifalert!.svg',
            width: scaleWidth(80, context),
            height: scaleHeight(80, context),
            fit: BoxFit.cover,
          ),

          SizedBox(height: scaleHeight(15, context)),
          Column(
            children: [
              Text(
                'Are You Sure?',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: scaleFontSize(16, context),
                  color: Color(0xFF00244B)
                ),
              ),

              SizedBox(height: scaleHeight(8, context)),

              Text(
                'Ensure the data is correct before saving !',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: scaleFontSize(12, context),
                  color: Color(0xFF606470)
                ),
              ),
            ],
          ),

          SizedBox(height: scaleHeight(16, context)),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    height: scaleHeight(48, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(scaleWidth(8, context)),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: scaleFontSize(14, context),
                          color: Colors.red
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: scaleWidth(8, context)),
              
               Expanded(
                 child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    height: scaleHeight(48, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(scaleWidth(8, context)),
                      color: Color(0xff00244B)
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: scaleFontSize(14, context),
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                               ),
               ),

            ],
          )
        ],
      ),
    );

  }

  void _showDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder:(BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scaleWidth(12, context))
          ),
          child: _notifsubmit(
            context: context,
            onCancel: (){
              Navigator.of(context).pop();
            },
            onConfirm: (){
              Navigator.of(context).pop();
              showsuccessdialog(context);
            }
          ),
        );
      }
      );
  }

  void showsuccessdialog(BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scaleWidth(12, context))
          ),
          child: _notifaccept(context),
        );
      }
      );
    Future.delayed(Duration(seconds: 3), () {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Tutup popup sukses
    }
  });
  }

  Widget _notifaccept(BuildContext context){
      return Container(
        width: scaleWidth(328, context),
        height: scaleHeight(243, context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(scaleWidth(12, context)),
        ),
        padding: EdgeInsets.all(scaleWidth(32, context)),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/logoceklis.svg',
              width: scaleWidth(80, context),
              height: scaleHeight(80, context),
              fit: BoxFit.cover,
            ),

            SizedBox(height: scaleHeight(15, context)),

            Text(
              'Successful Industrial Room Created',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: scaleFontSize(14, context),
                color: Color(0xFF00244B)
              ),
            ),

            SizedBox(height: scaleHeight(8, context)),

            Text(
              'The fund management room has been successfully created and is ready for use.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                fontSize: scaleFontSize(12, context),
                color: Color(0xFF606470)
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