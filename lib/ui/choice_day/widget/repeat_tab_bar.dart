import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_alarm_clock/ui/choice_day/controller/repeat_mode_controller.dart';
import 'package:new_alarm_clock/ui/choice_day/widget/repeat_tab_bar_view.dart';
import 'package:new_alarm_clock/utils/values/color_value.dart';
import 'package:new_alarm_clock/utils/values/my_font_family.dart';

class RepeatTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repeatModeController = Get.put(RepeatModeController());
    return DefaultTabController(
      length: 4,
      initialIndex: repeatModeController.subIndex.value,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context)!;
        repeatModeController.setRepeatMode(1, tabController.index);
        print(repeatModeController.getRepeatMode());
        tabController.addListener(() {
          repeatModeController.setRepeatMode(1, tabController.index);
          print(repeatModeController.getRepeatMode());
        });
        return Column(children: [
          TabBar(
            labelStyle: TextStyle(
              fontFamily: MyFontFamily.mainFontFamily,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: ColorValue.subTabBarIndicator,
            labelColor: ColorValue.subTabBarIndicator,
            unselectedLabelColor: Colors.black54,
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                text: "일",
              ),
              Tab(
                text: "주",
              ),
              Tab(
                text: "월",
              ),
              Tab(
                text: "년",
              ),
            ],
          ),
          Expanded(child: RepeatTabBarView())
        ]);
      }),
    );
  }
}
