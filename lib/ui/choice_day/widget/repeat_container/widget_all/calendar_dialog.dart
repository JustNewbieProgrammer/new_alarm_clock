import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 5 * 4,
      height: Get.height * 3 / 5,
      child: SfDateRangePicker(
        headerHeight: 40,
        minDate: DateTime(2000),
        maxDate: DateTime(2100),
        enablePastDates: false,
        selectionMode:
        DateRangePickerSelectionMode.single,
        yearCellStyle: DateRangePickerYearCellStyle(
          textStyle: TextStyle(
            color: Colors.black,
            fontFamily:
            MyFontFamily.mainFontFamily,
          ),
        ),
        monthCellStyle:
        const DateRangePickerMonthCellStyle(
          textStyle: TextStyle(
            color: Colors.black,
            fontFamily:
            MyFontFamily.mainFontFamily,
          ),
          todayTextStyle: TextStyle(
              color: Colors.black,
              fontFamily:
              MyFontFamily.mainFontFamily,),
        ),
        startRangeSelectionColor: Colors.white,
        endRangeSelectionColor: Colors.white,
        rangeSelectionColor: Colors.white,
        selectionTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily:
            MyFontFamily.mainFontFamily),
        todayHighlightColor: Colors.amber,
        selectionColor: Color(0xFF7fcd91),
        // backgroundColor: Colors.deepPurple,
        //allowViewNavigation: false,
        // view:  DateRangePickerView.month,
        //11월 2021  이 부분
        headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: ColorValue.calendarTitleBar,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 25,
              letterSpacing: 5,
              fontFamily:
              MyFontFamily.mainFontFamily,
              fontWeight: FontWeight.bold
            )),
        monthViewSettings:
        DateRangePickerMonthViewSettings(
            enableSwipeSelection: false,
            //일 월 화 수 목 금 토  이 부분
            viewHeaderStyle:
            DateRangePickerViewHeaderStyle(
                textStyle: TextStyle(
                    fontFamily: MyFontFamily
                        .mainFontFamily,
                    color:
                    Colors.black))),
        showActionButtons: true,
        onSubmit: (Object? value) {
          Get.back(result: value);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}