import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/global/alarm_item/controller/alarm_skip_button_controller.dart';
import 'package:new_alarm_clock/ui/global/alarm_item/controller/alarm_switch_controller.dart';
import 'package:new_alarm_clock/ui/global/alarm_item/controller/selected_alarm_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/alarm_list_controller.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/size_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';
import 'widgets/alarm_item_text.dart';
import 'package:intl/intl.dart';

class AlarmItem extends StatelessWidget {
  bool _switchBool = true;
  Color _skipButtonColor;
  late int _id;
  AlarmProvider alarmProvider = AlarmProvider();

  AlarmItem(
      {required int id})
      : _id = id,
        _skipButtonColor = Colors.grey;

//color들 싹 조정하기
  @override
  Widget build(BuildContext context) {
    BorderRadius _alarmBorder = BorderRadius.all(Radius.circular(10));
    final SelectedCont = Get.put(SelectedAlarmController());
    final switchCont = Get.put(AlarmSwitchController());
    final skipCont = Get.put(AlarmSkipButtonController());
    final alarmListController = Get.put(AlarmListController());

    //나중에 LongPress했을 때 회색도 추가
    Get.find<SelectedAlarmController>().colorMap[_id] = ColorValue.alarm;

    return Container(
      height: SizeValue.alarmItemHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _alarmBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      //안된다면 Material로 감싸봐
      child: Material(
        borderRadius: _alarmBorder,
        child: Ink(
            height: SizeValue.alarmItemHeight,
            decoration: BoxDecoration(
              borderRadius: _alarmBorder,
              color: Get.find<SelectedAlarmController>().colorMap[_id],
            ),
            child: InkWell(
              borderRadius: _alarmBorder,
              splashColor: Colors.grey,
              onTap: () {
                Map<String, dynamic> argToNextPage = {StringValue.mode : StringValue.addMode,
                  StringValue.alarmId : _id};
                Get.toNamed(AppRoutes.addAlarmPage, arguments: argToNextPage);
              },
              onLongPress: () {
                alarmListController.deleteAlarm(_id);
                //스위치랑 스킵버튼은 애니메이션으로 오른쪽으로 보내고 안보이게
                //verticalDivider도
              },
              child: LayoutBuilder(//현재 위젯의 크기를 알기 위해
                  builder: (BuildContext context, BoxConstraints constraints) {
                return FutureBuilder<AlarmData>(
                    future: alarmProvider.getAlarmById(_id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //함부로 옮기다간 스위치 정상작동 안 한다.
                        switchCont.switchBoolMap[_id] = snapshot.data!.alarmState;
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //알람 제목 텍스트
                                    AlarmItemText(
                                        flex: 4,
                                        itemText: (snapshot.data)!.title!),
                                    Divider(
                                      thickness: 1,
                                      color: ColorValue.alarmItemDivider,
                                    ),

                                    //알람 시간 텍스트
                                    AlarmItemText(
                                        flex: 5,
                                        itemText: DateFormat('hh:mm a').format((snapshot.data)!
                                            .alarmDateTime).toLowerCase()),
                                    //alarmPoint 텍스트
                                    AlarmItemText(//수정하세요~
                                        flex: 3,
                                        itemText: (snapshot.data)!.alarmInterval.toString()),
                                    //Spacer(),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                thickness: 1,
                                color: ColorValue.alarmItemDivider,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        //color: Color.fromARGB(255, 250, 250, 250),
                                        borderRadius: _alarmBorder),
                                    padding: EdgeInsets.fromLTRB(
                                        0,
                                        constraints.maxHeight / 10,
                                        0,
                                        constraints.maxHeight / 20),
                                    child: Column(
                                      children: [
                                        Transform.scale(
                                            scale: 0.8,
                                            child: GetBuilder<AlarmSwitchController>(
                                              builder: (_) {
                                                return CupertinoSwitch(
                                                value: _.switchBoolMap[_id]!,
                                                onChanged: (value) {
                                                  _.setSwitchBool(_id);
                                                },
                                                activeColor: ColorValue.alarmActiveSwitch,
                                                trackColor: Color(0xffC8C2BC),
                                              );}
                                            )),

                                        Spacer(),

                                        //이 페이지 볼 때마다
                                        //체크되어있나 아닌가 설정값 찾아서
                                        //체크/미체크 표시하기기
                                        GetBuilder<AlarmSkipButtonController>(
                                          builder: (_) => IconButton(
                                              iconSize:
                                                  constraints.maxHeight / 4,
                                              onPressed: () {
                                                //이거 getx식으로 바꾸기
                                                if (_skipButtonColor ==
                                                    Colors.yellow) {
                                                  _skipButtonColor =
                                                      Colors.black26;
                                                } else {
                                                  _skipButtonColor =
                                                      Colors.grey;
                                                }
                                              },
                                              icon: Icon(
                                                Icons.expand_more,
                                                color: _skipButtonColor,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }
                      return Center(
                        child: Text(
                          'Loading..',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    });
              }),
            )),
      ),
    );
  }
}
