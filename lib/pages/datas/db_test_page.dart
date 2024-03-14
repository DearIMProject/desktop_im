import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/test/test_page.dart';
import 'package:flutter/material.dart';

class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({super.key});

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  List<TestItemModel> models = [];
  IMDatabase database = IMDatabase.getInstance();
  _DatabaseTestPageState() {
    {
      TestItemModel model = TestItemModel("清除所有数据库数据", () {
        database.removeAll().then((value) {
          if (value != 0) {
            Log.debug("数据库清除成功");
          }
        });
      });
      models.add(model);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: titleFontText(kTitleColor, "长连接测试"),
        ),
        body: pagePadding(
          ListView.builder(
            itemCount: models.length,
            itemBuilder: (BuildContext context, int index) {
              TestItemModel model = models[index];
              return GestureDetector(
                onTap: model.callback,
                child: titleFontText(kTitleColor, model.title),
              );
            },
          ),
        ));
  }
}
