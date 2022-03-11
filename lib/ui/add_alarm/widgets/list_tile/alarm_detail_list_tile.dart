import 'package:flutter/material.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_page_factory.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';
import 'package:get/get.dart';

class AlarmDetailListTile extends StatelessWidget {
  Text tileTitle =
      Text('', style: TextStyle(fontFamily: MyFontFamily.mainFontFamily));
  dynamic tileSubTitle;
  dynamic stateSwitch = Switch(value: true, onChanged: null);
  AlarmDetailPageFactory alarmDetailPageFactory = AlarmDetailPageFactory();
  dynamic currentListTileController;

  @override
  Widget build(BuildContext context) {
    switch(tileTitle.data!){
      case '알람음':
        currentListTileController = Get.put(RingRadioListController());
        break;
      case '진동':
        currentListTileController = Get.put(VibrationRadioListController());
        break;
      case '반복':
        currentListTileController = Get.put(RepeatRadioListController());
        break;
      default://error
        assert(false, 'error in currentListTileController of AlarmDetailListTile');
    }

    return Container(
      height: 80,
      child: InkWell(
        onTap: () {
          ////////리스트타일 터치해서 해당 페이지로 넘어가는 메소드.
          /////factory메소드 패턴으로 만든 그거 활용

          alarmDetailPageFactory.getAlarmDetailPage(tileTitle.data!);
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //tileTitle
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minWidth: 1, minHeight: 1),
                                      child: tileTitle),
                                ),
                              ),
                            ),

                            //tileSubTitle
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: 1, minHeight: 1),
                                    child: tileSubTitle),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //스위치
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: stateSwitch,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                )
              ],
            )),
      ),
    );
  }
}
