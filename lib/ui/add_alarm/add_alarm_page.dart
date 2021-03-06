import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_alarm_clock/data/database/alarm_provider.dart';
import 'package:new_alarm_clock/data/model/alarm_data.dart';
import 'package:new_alarm_clock/data/shared_preferences/id_shared_preferences.dart';
import 'package:new_alarm_clock/routes/app_routes.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/days_of_week_row.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/list_tile/alarm_detail_list_tile_factory.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/save_button.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/time_spinner.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/title_text_field.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/repeat/controller/repeat_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/ring/controller/ring_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/alarm_detail_page/vibration/controller/vibration_radio_list_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/interval_text_field_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/month_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/start_end_day_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/year_repeat_day_controller.dart';
import 'package:new_alarm_clock/ui/add_alarm/widgets/going_back_dialog.dart';
import 'package:new_alarm_clock/ui/day_off/controller/day_off_list_controller.dart';
import 'package:new_alarm_clock/ui/global/auto_size_text.dart';
import 'package:new_alarm_clock/ui/home/controller/required_parameter_to_add_alarm_page_controller.dart';
import 'package:new_alarm_clock/utils/enum.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/utils/values/string_value.dart';

import '../global/color_controller.dart';

final String toBeAddedIdName = 'toBeAddedId';

class AddAlarmPage extends StatelessWidget {
  String mode = '';
  int alarmId = -1;
  String currentFolderName = '';
  AlarmProvider _alarmProvider = AlarmProvider();
  late AlarmData alarmData;
  final AlarmDetailListTileFactory _alarmDetailListTileFactory =
      AlarmDetailListTileFactory();
  final IdSharedPreferences idSharedPreferences = IdSharedPreferences();

  Future<void> initEditAlarm() async {
    // ???????????? ?????? ??? ????????? ?????? init ????????? ??????????????? ?????? ?????? ??????
    if (Get.find<RequiredParameterToAddAlarmPageController>().isFirstInit == true) {
      alarmData = await _alarmProvider.getAlarmById(alarmId);

      Get.find<RepeatModeController>().repeatMode = alarmData.alarmType;
      Get.find<VibrationRadioListController>().power = alarmData.vibrationBool;
      Get.find<VibrationRadioListController>()
          .initSelectedVibrationInEdit(alarmData.vibrationName);
      Get.find<RingRadioListController>().power = alarmData.musicBool;
      Get.find<RingRadioListController>().volume = alarmData.musicVolume;
      Get.find<RingRadioListController>()
          .initSelectedMusicPathInEdit(alarmData.musicPath);
      Get.find<RepeatRadioListController>().power = alarmData.repeatBool;
      Get.find<RepeatRadioListController>()
          .setAlarmIntervalWithInt(alarmData.repeatInterval);
      Get.find<RepeatRadioListController>()
          .setRepeatNumWithInt(alarmData.repeatNum);
      Get.find<IntervalTextFieldController>()
          .initTextFieldInEditRepeat(alarmData.alarmInterval);
      Get.find<MonthRepeatDayController>().initInEdit(alarmData.monthRepeatDay);
      Get.find<StartEndDayController>().setStart(alarmData.alarmDateTime);
      Get.find<StartEndDayController>().setEnd(alarmData.endDay);
      Get.find<YearRepeatDayController>().yearRepeatDay = alarmData.alarmDateTime;

      Get.find<RequiredParameterToAddAlarmPageController>().isFirstInit = false;
    }
  }

  Future<bool> _onTouchAppBarBackButton() async {
    return await Get.dialog(GoingBackDialog('appBar'));
  }

  Future<bool> _onTouchSystemBackButton() async {
    return await Get.dialog(GoingBackDialog('system'));
  }

  String convertAlarmDateTime() {
    if (Get.find<StartEndDayController>().start['dateTime'].year >
        DateTime.now().year) {
      return '${Get.find<StartEndDayController>().start['year']} '
          '${Get.find<StartEndDayController>().start['monthDay']}';
    } else if (Get.find<StartEndDayController>().start['dateTime'].year ==
        DateTime.now().year) {
      return Get.find<StartEndDayController>().start['monthDay'];
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    void closeKeyBoard() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      //Checking hasPrimaryFocus is necessary to prevent Flutter from throwing an exception
      //when trying to unfocus the node at the top of the tree.
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }

    bool isRepeat() {
      return Get.find<RepeatModeController>().repeatMode != RepeatMode.off &&
          Get.find<RepeatModeController>().repeatMode != RepeatMode.single;
    }

    mode = Get.find<RequiredParameterToAddAlarmPageController>().mode; //add or edit
    alarmId = Get.find<RequiredParameterToAddAlarmPageController>().alarmId;
    currentFolderName = Get.find<RequiredParameterToAddAlarmPageController>().folderName;

    final repeatModeController = Get.put(RepeatModeController());
    final startEndDayController = Get.put(StartEndDayController());
    Get.put(RingRadioListController());
    Get.put(VibrationRadioListController());
    Get.put(RepeatRadioListController());
    Get.put(IntervalTextFieldController());
    Get.put(MonthRepeatDayController());
    Get.put(YearRepeatDayController());
    Get.put(DayOffListController());

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Get.find<ColorController>().colorSet.mainColor));

    if (mode == StringValue.editMode) {
      initEditAlarm();
    }

    Get.find<DayOffListController>().id = alarmId;

    return WillPopScope(
      onWillPop: _onTouchSystemBackButton,
      child: GestureDetector(
        onTap: () {
          closeKeyBoard();
        },
        child: Scaffold(
          backgroundColor: ColorValue.addAlarmPageBackground,
          appBar: AppBar(
            backgroundColor: ColorValue.appbar,
            foregroundColor: ColorValue.appbarText,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: _onTouchAppBarBackButton,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.5),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SaveButton(
                    alarmId,
                    mode,
                    currentFolderName,
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: ColorValue.addAlarmPageBackground,
                padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
                child: Column(
                  children: [
                    //spinner
                    Container(
                      height: 250,
                      child: TimeSpinner(
                          alarmId: alarmId, fontSize: 24, mode: mode),
                    ),

                    Divider(
                      thickness: 2,
                    ),

                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DaysOfWeekRow(mode, alarmId),
                            ),
                          ),

                          //ChoiceDayButton
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: GestureDetector(
                                child: Icon(
                                  Icons.today,
                                  color: ColorValue.calendarIcon,
                                  size: 1000,
                                ),
                                onTap: () {
                                  repeatModeController.previousRepeatMode =
                                      repeatModeController.repeatMode;
                                  Get.toNamed(AppRoutes.choiceDayPage);
                                },
                              )),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //ResetNextAlarmDayButton
                          GetBuilder<RepeatModeController>(builder: (_) {
                            return IconButton(
                              onPressed: () {
                                if(repeatModeController.repeatMode == RepeatMode.month){
                                  startEndDayController.resetDateWhenMonthRepeat(alarmData.alarmDateTime);
                                }
                                else if (mode == StringValue.editMode && isRepeat()) {
                                  startEndDayController.setStart(alarmData.alarmDateTime);
                                }
                              },
                              icon: Icon(Icons.refresh_rounded),
                              //tooltip: '?????????',
                              color: (mode == StringValue.editMode && isRepeat())
                                      ? Colors.black45
                                      : Colors.transparent,
                            );
                          }),
                          //NextYearMonthDayText
                          GetBuilder<StartEndDayController>(builder: (_) {
                            return Container(
                              padding: EdgeInsets.only(top: 5),
                              height: 40,
                              child: AutoSizeText(
                                convertAlarmDateTime(),
                                bold: true,
                              ),
                            );
                          }),
                          //SkipNextAlarmDayButton
                          GetBuilder<RepeatModeController>(builder: (_) {
                            return IconButton(
                              onPressed: () {
                                if (mode == StringValue.editMode && isRepeat()) {
                                  startEndDayController.skipNextAlarmDate(alarmId);
                                }
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                              //tooltip: '?????? ?????? ????????????',
                              color: (mode == StringValue.editMode && isRepeat())
                                      ? Colors.black45
                                      : Colors.transparent,
                            );
                          }),
                        ],
                      ),
                    ),

                    //IntervalInfoText
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child:
                          GetBuilder<IntervalTextFieldController>(builder: (_) {
                        return GetBuilder<RepeatModeController>(
                            builder: (repeatCont) {
                          return GetBuilder<MonthRepeatDayController>(
                              builder: (monthCont) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              height: 35,
                              child: AutoSizeText(
                                '${_.getIntervalText()}'
                                '${repeatCont.getRepeatModeText(
                                    _.textEditingController.text,
                                    monthCont.monthRepeatDay)}',
                                color: Colors.black54,
                              ),
                            );
                          });
                        });
                      }),
                    ),

                    TitleTextField(mode, alarmId),

                    _alarmDetailListTileFactory
                        .getDetailListTile(DetailTileName.ring),
                    _alarmDetailListTileFactory
                        .getDetailListTile(DetailTileName.vibration),
                    _alarmDetailListTileFactory
                        .getDetailListTile(DetailTileName.repeat),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
