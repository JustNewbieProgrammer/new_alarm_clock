import 'package:flutter/material.dart';
import 'package:new_alarm_clock/data/model/alarm_folder_data.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_list_controller.dart';
import 'package:new_alarm_clock/ui/home/controller/folder_name_text_field_controller.dart';
import 'package:get/get.dart';

class SetFolderTitleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var folderNameTextFieldController =
        Get.put(FolderNameTextFieldController());
    var folderListController = Get.put(FolderListController());

    return GetBuilder<FolderNameTextFieldController>(builder: (_) {
      return AlertDialog(
        title: Text('폴더 이름'),
        content: TextField(
          onChanged: (value) {},
          controller: _.textEditingController,
          decoration: InputDecoration(
            hintText: "폴더 이름을 입력하세요.",
            suffixIcon: _.textEditingController.text.length > 0
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () => _.resetField(),
                  )
                : null,
            errorText: _.getErrorText(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.grey,
            ),
            child: Text('취소'),
            onPressed: () {
              folderNameTextFieldController.textEditingController.text = '';
              Get.back();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            child: Text('확인'),
            onPressed: () {
              if (folderListController.folderList.any((e) =>
                  e.name == folderNameTextFieldController.textEditingController.text)) {
                _.isError = true;
                //Get.back();
              } else {
                folderListController.inputFolder(AlarmFolderData(
                    name: folderNameTextFieldController
                        .textEditingController.text));
                folderNameTextFieldController.textEditingController.text = '';
                Get.back();
              }
            },
          ),
        ],
      );
    });
  }
}
