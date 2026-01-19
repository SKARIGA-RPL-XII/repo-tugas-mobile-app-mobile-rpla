import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';




class Sect3 extends StatefulWidget {
  const Sect3({super.key});

  @override
  State<Sect3> createState() => _Sect3State();
}

const double figmaWidth = 412.0;
const double figmaHeight = 1204;

class _Sect3State extends State<Sect3> {
  int inactive = 1;

  DateTime _focusedday = DateTime.now();
  DateTime? _selectDay;
  String? _selectedDateLabel;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
    
    body: Stack(
      children: [
        _header(context),
        _cardprofil(context),
        _cardgrafik(context),
        _cardtransaksi(context),
        _buttonaddroom(context)
        
      ],
    ),
    ),
    );
  }

  Widget _header(BuildContext context){
    return Positioned(
      top: scaleHeight(48, context),
      left: scaleWidth(16, context),
      width: scaleWidth(219, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'WELCOME',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(20, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000)
                  )
                ),
              ]
            )
            ),

          SizedBox(height: scaleFontSize(3, context)),

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
      )
      );
  }

  Widget _cardprofil(BuildContext context){
    return Positioned(
      top: scaleHeight(137, context),
      left: scaleWidth(16, context),
      width: scaleWidth(380, context),
      height: scaleHeight(81, context),
      child: Container(
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
              width: scaleWidth(18, context),
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
      )
      );
  }

  Widget _cardgrafik(BuildContext context){
      return Positioned(
        height: scaleHeight(482.05, context),
        width: scaleWidth(380, context),
        top: scaleHeight(238, context),
        left: scaleWidth(15, context),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: scaleWidth(16, context),
            vertical: scaleHeight(16, context)
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(scaleWidth(10, context)),
            color: Color(0xFFE6E9EF)
          ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: scaleWidth(301, context),
              child: Text(
                'MY CHART CARD', 
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(16, context),
                fontWeight: FontWeight.w600,
                color: Color(0xFF00244B)
              ),
              ),
            ),

            SizedBox(height: scaleHeight(10, context)),

          Align(
            alignment: Alignment.center,
            child: Text(
              'Rp 14,569,000.00',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(33, context),
                fontWeight: FontWeight.w600,
                color: Color(0xFF00244B)
              ),
            ),
          ),

          SizedBox(height: scaleHeight(10, context)),

          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: scaleHeight(35, context),
                width: scaleWidth(140, context),
                decoration: BoxDecoration(
                  color: Color(0xff00244B).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(scaleWidth(5, context)),
                ),
                padding: EdgeInsets.only(
                  top: scaleHeight(6, context),
                  right: scaleWidth(20, context),
                  bottom: scaleHeight(6, context),
                  left: scaleWidth(20, context) 
                ),
                child: Text(
                  '- Rp. 2,000,000',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(14, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF00244B)
                  ),
                ),
              ),
            
              SizedBox(width: scaleWidth(10, context)),
            
              Container(
                height: scaleHeight(35, context),
                width: scaleWidth(145, context),
                decoration: BoxDecoration(
                  color: Color(0xff00244B).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(scaleWidth(5, context)),
                ),
                padding: EdgeInsets.only(
                  top: scaleHeight(6, context),
                  right: scaleWidth(20, context),
                  bottom: scaleHeight(6, context),
                  left: scaleWidth(20, context) 
                ),
                child: Text(
                  '+ Rp. 5,000,000',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(14, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF00244B)
                  ),
                ),
              ),
            ],
            ),
          ),
          SizedBox(height: scaleHeight(20, context)),
          _chart(context),
          ],
        ),
        ),
      );
  }

  Widget _cardtransaksi(BuildContext context){
    return Positioned(
      top: scaleHeight(741, context),
      width: scaleWidth(380, context),
      height: scaleHeight(333.5, context),
      left: scaleWidth(16, context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE6E9EF),
          borderRadius: BorderRadius.circular(scaleWidth(10, context))
        ),
        padding: EdgeInsets.symmetric(
          horizontal: scaleWidth(16, context),
          vertical: scaleHeight(16, context)
        ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRANSACTION',
        style: GoogleFonts.montserrat(
          fontSize: scaleFontSize(16, context),
          fontWeight: FontWeight.w600,
          color: Color(0xff000000)
        ),
        ),
        SizedBox(height: scaleHeight(10, context)),

        Text(
          'Balance',
          style: GoogleFonts.montserrat(
            fontSize: scaleFontSize(14, context),
            fontWeight: FontWeight.w400,
            color: Color(0xff000000)
          ),
        ),

      
      Text(
        'Rp 2,000,000',
        style: GoogleFonts.montserrat(
          fontSize: scaleFontSize(20, context),
          fontWeight: FontWeight.w600,
          color: Color(0xff0F9500)
        ),
      ),

      SizedBox(height: scaleHeight(25, context)),

      DottedLine(
        dashColor: Color(0xFFBDBDBD),
        dashLength: scaleWidth(4, context),
        dashGapLength: scaleWidth(4, context),
        lineThickness: 1,
      ),

      SizedBox(height: scaleHeight(10, context)),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Income',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(14, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F9500)
                  ),
                ),

                Text(
                  'Rp. 50,000,000',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(20, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000)
                  ),
                )
              ],
            ), 
          ),

          SizedBox(width: scaleWidth(60, context)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(14, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFE50000)
                  ),
                ),
                Text(
                  'Rp. 36,000,000',
                  style: GoogleFonts.montserrat(
                    fontSize: scaleFontSize(20, context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE50000)
                  ),
                )
              ],
            ),
          )
        ],
      ),

      SizedBox(height: scaleHeight(10, context)),

      GestureDetector(
        onTap: () async {
          showModalBottomSheet(
            context: context, 
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(scaleWidth(20, context)),
              )
            ),
            builder: (BuildContext context){
              return SizedBox(
                 height: scaleHeight(700, context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Date',
                            style: GoogleFonts.montserrat(
                              fontSize: scaleFontSize(18, context),
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000)
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                      SizedBox(height: scaleHeight(16, context)),
                  
                      Expanded(
                        child: _calendar(context)),
                  
                      SizedBox(height: scaleHeight(12, context)),
                      
                      Padding(
                        padding:  EdgeInsets.all(
                          scaleWidth(10, context)
                          ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00244B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(scaleWidth(8, context))
                            ),
                            minimumSize: Size(double.infinity, scaleHeight(50, context))
                          ),
                          onPressed: () {
                            if(_selectDay != null){
                              setState(() {
                                _selectedDateLabel = 
                                      '${_selectDay!.day}/${_selectDay!.month}/${_selectDay!.year}';
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Terapkan',
                            style: GoogleFonts.montserrat(
                              fontSize: scaleFontSize(14, context),
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFFFF)
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            );
        },
        child: Container(
          width: scaleWidth(350, context),
          height: scaleHeight(44, context),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(scaleWidth(4, context))
          ),
          padding: EdgeInsets.only(
            top: scaleHeight(10, context),
            bottom: scaleHeight(10, context),
            right: scaleWidth(20, context),
            left: scaleWidth(20, context)
          ),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDateLabel ?? 'Search Date',
              style: GoogleFonts.montserrat(
                fontSize: scaleFontSize(14, context),
                fontWeight: FontWeight.w400,
                color: _selectedDateLabel != null ? Colors.black: Color(0xFFA3A3A3)
              )
            ),
        
          SizedBox(
            width: scaleWidth(21, context),
            height: scaleHeight(30, context),
            child: SvgPicture.asset(
              'assets/images/icon-calendar.svg',
              fit: BoxFit.cover,
            ),
          )
          ],
        ),
        ),
      ),

        SizedBox(height: scaleHeight(23, context)),

        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: scaleHeight(40, context),
              width: scaleWidth(215, context),
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(scaleWidth(8, context)),
              color: Color(0xFF00244B)
            ),
              padding: EdgeInsets.only(
                right: 24,
                left: 24,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'View Detail Transaction',
                style: GoogleFonts.montserrat(
                  fontSize: scaleFontSize(14, context),
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),
                ),
              ),
            ),
          ),
        )
    
      ],
      ),
      )
      );
  }

  Widget _buttonaddroom(BuildContext context){
    return Positioned(
      width: scaleWidth(180, context),
      height: scaleHeight(60, context),
      top: scaleHeight(1095, context),
      left: scaleWidth(15, context),
      child: ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00244B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scaleWidth(8, context))
          )
        ),
        child: Text(
          'Add Room',
          style: GoogleFonts.montserrat(
            fontSize: scaleFontSize(16, context),
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF)
          ),
        ),
      )
    );
  }

  //widget card chart start
  Widget _chart(BuildContext context){
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: scaleWidth(335, context),
              child: _linechart(context),
                  
            ),
          ),
            SizedBox(height: scaleHeight(6, context)),
      
          SizedBox(
            width: scaleWidth(335, context),
            height: scaleWidth(95, context),
            child: _gridnominal(),
          ),

            SizedBox(height: scaleHeight(4, context)),
            _monthsRow(),
            SizedBox(height: scaleHeight(6, context)),
            _filtercontainer(),
        ],
      ),
    );
  }

  Widget _linechart(BuildContext context){
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 15,

        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),

        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 5),
              FlSpot(2, 6),
              FlSpot(3, 6.5),
              FlSpot(4, 5.8),
              FlSpot(5, 4.8),
              FlSpot(6, 6.8),
              FlSpot(7, 7.5),
              FlSpot(8, 11),
              FlSpot(9, 12),
              FlSpot(10, 13),
              FlSpot(11, 14),
            ],

          isCurved: false,
          barWidth: 2,
          color: Color(0xFF00244B),
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00244B).withValues(alpha: 0.35),
                Colors.transparent
              ]
              )
          )
          )
        ]
      )
    );
  }

  Widget _gridnominal(){
    return Stack(
      children: [

        _dasheline(top: scaleHeight(30, context)),
        _nominal('10.000.000', top: scaleHeight(2, context)),

        _dasheline(top: scaleHeight(75, context)),
        _nominal('10.000.000', top: scaleHeight(47, context)),

        _dasheline(bottom: scaleHeight(0, context)),
        _nominal('10.000.000', bottom: scaleHeight(6, context))


      ],
    );
  }

  Widget _dasheline({double? top, double? bottom}){
    return Positioned(
      top: top,
      bottom: bottom,
      left: 0,
      right: 0,
      child:  DottedLine(
        dashGapLength: scaleWidth(4, context),
        dashLength: scaleWidth(4, context),
        lineThickness: 1,
        dashColor: Color(0xFF9DB2CE),
      )
      );
  }

  Widget _nominal(String text,{double? top, double? bottom}){
    return Positioned(
      top: top,
      bottom: bottom,
      right: 0,
      child: Text(
        text,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF6B84A6)
      ),
      )
      );
  }

  Widget _monthsRow(){
    const monthrow = [
      'Jan','Feb','Mar','Apr','Mei','Jun',
      'Jul','Ags','Sep','Okt','Nov','Des'
    ];

    return SizedBox(
      width: 334,
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: 
          monthrow.map((e) => Text(
            e,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: Color(0xFF6B84A6),
              fontWeight: FontWeight.w400
            ),
            )).toList(),
      ),
    );
  }

  Widget _filtercontainer(){
    return Container(
      width: scaleWidth(357, context),
      height: scaleHeight(57, context),
      padding: EdgeInsets.symmetric(horizontal: scaleWidth(20, context), vertical: scaleHeight(10, context)),
      decoration: BoxDecoration(
        color: const Color(0xFF00244B),
        borderRadius: BorderRadius.circular(scaleWidth(10, context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _filteritem('Week', 0),
          _filteritem('Month', 1),
          _filteritem('Year', 2),
          _filteritem('All', 3)
        ],
      ),
    );
  }

  Widget _filteritem(String text, int index){
    final bool active = inactive == index;

    return GestureDetector(
      onTap: () => setState(() => inactive = index),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: scaleWidth(16, context), vertical: scaleHeight(8, context)),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(scaleWidth(8, context))
          ),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              color: active ? const Color(0xFF00244B) : Colors.white,
              fontSize: scaleFontSize(14, context)
            ),
          ),
        ),
      );
  }
  //widget card chart end

  Widget _calendar(BuildContext contex){
    return TableCalendar(
      focusedDay: _focusedday, 
      firstDay: DateTime.utc(2026, 1, 1), 
      lastDay: DateTime.utc(2030, 12, 31),
      selectedDayPredicate: (day){
        return isSameDay(_selectDay, day);
      },
      onDaySelected: (selectedday, focusedday){
        setState(() {
          _selectDay = selectedday;
          _focusedday = focusedday;
        });
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xff00244B),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: const TextStyle(color: Colors.black),
        weekendTextStyle: const TextStyle(color: Colors.red)
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
        decoration: BoxDecoration(
          color: Color(0xff00244B),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.red)
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