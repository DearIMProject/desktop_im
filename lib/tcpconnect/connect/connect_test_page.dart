import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/pages/test/test_page.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:flutter/material.dart';

// 长连接测试页面
class ConnectTestPage extends StatefulWidget {
  const ConnectTestPage({super.key});

  @override
  State<ConnectTestPage> createState() => _ConnectTestPageState();
}

class _ConnectTestPageState extends State<ConnectTestPage> {
  List<TestItemModel> models = [];
  _ConnectTestPageState() {
    {
      TestItemModel model = TestItemModel("连接", () {
        IMClient().connect();
      });
      models.add(model);
    }
    {
      TestItemModel model = TestItemModel("发送登录消息", () {
        IMClient().sendRequestLoginMessage();
      });
      models.add(model);
    }
    {
      TestItemModel model = TestItemModel("发送获取离线消息", () {
        IMClient().sendRequestOfflineMessage();
      });
      models.add(model);
    }
    {
      TestItemModel model = TestItemModel("断开", () {
        IMClient().close();
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
