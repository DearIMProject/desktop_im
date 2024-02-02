import 'package:desktop_im/components/common/colors.dart';
import 'package:desktop_im/components/common/fonts.dart';
import 'package:desktop_im/components/common/space.dart';
import 'package:desktop_im/router/routers.dart';
import 'package:flutter/material.dart';

typedef TestCallback = void Function();

class TestItemModel {
  String title;
  TestCallback callback;
  TestItemModel(this.title, this.callback);
}

// 测试页面
class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<TestItemModel> models = [];

  _TestPageState() {
    init();
  }
  void init() {
    initModels();
  }

  void initModels() {
// 测试链接tcp
    {
      TestItemModel itemModel = TestItemModel("测试长连接", () {
        Routers().openRouter("/test_connect_page", {}, context);
      });
      models.add(itemModel);
    }
    {
      TestItemModel itemModel = TestItemModel("数据库", () {
        Routers().openRouter("/test_db_page", {}, context);
      });
      models.add(itemModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleFontText(kTitleColor, "test"),
      ),
      body: pagePadding(ListView.builder(
        itemCount: models.length,
        itemBuilder: (BuildContext context, int index) {
          TestItemModel itemModel = models[index];
          return GestureDetector(
            onTap: itemModel.callback,
            child: subTitleFontText(kTitleColor, itemModel.title),
          );
        },
      )),
    );
  }
}
