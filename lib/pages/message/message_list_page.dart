import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:desktop_im/components/common/common_dialog.dart';
import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/add_keyboard.dart';
import 'package:desktop_im/components/ui/emj_keyboard.dart';
import 'package:desktop_im/components/ui/message_input.dart';
import 'package:desktop_im/generated/l10n.dart';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/fileBean.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_json_model.dart';

import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/message/message_item.dart';
import 'package:desktop_im/pages/message/services/message_service.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';
import 'package:desktop_im/user/user_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MessageListPage extends BasePage {
  const MessageListPage({super.key, super.params});

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage>
    implements IMDatabaseListener, IMClientListener {
  User? chatUser;
  MessageService service = MessageService();

  User? user = UserManager().user;
  List<Message> messages = [];
  IMDatabase database = IMDatabase();
  IMClient client = IMClient();
  @override
  DatabaseCompleteCallback? completeCallback;

  @override
  DatabaseCompleteCallback? dataChangeCallback;

  @override
  DatabaseUnreadMessageNumberChange? unreadMessageNumberChange;
  final ScrollController _scrollController = ScrollController();
  late final VoidCallback _keyboardOpenedListener;
  final KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();
  MesssageInputViewController controller = MesssageInputViewController();
  bool isUserWriting = false;
  Timer? timer;
  @override
  void dispose() {
    database.removeListener(this);
    IMClient().removeListener(this);
    _scrollController.dispose();
    super.dispose();
  }

  _MessageListPageState() {
    database.addListener(this);
    IMClient().addListener(this);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection !=
          ScrollDirection.idle) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }
// 滚动到底部
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Log.debug("_scrollToBottom");
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    }
  }

  @override
  void initState() {
    super.initState();

    if (messages.isNotEmpty) {
      return;
    }
    chatUser = widget.params?["user"];
    if (chatUser == null) {
      throw Exception("chatUser is null");
    }
    if (user == null) {
      throw Exception("user is null");
    }
    if (messages.isEmpty) {
      messages.addAll(database.getChatMessages(chatUser!.userId));
      Log.debug("$messages");
    }
    dataChangeCallback ??= () {
      messages = [];
      messages.addAll(database.getChatMessages(chatUser!.userId));
      // configSendReadMessage();
      Log.debug("收到消息发生了变化 $messages");
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          setState(() {});
          _scrollToBottom();
        },
      );
    };

    transparentCallback ??= (message) {
      if (chatUser!.userId == message.fromId) {
        // 显示title 正在输入中..
        Log.debug("chatUser!.userId == message.fromId");
        isUserWriting = true;
        setState(() {});
        // 并开启定时 ..
        if (timer != null) {
          timer!.cancel();
          timer = null;
        } else {
          timer = Timer(const Duration(seconds: 5), () {
            delayTransparnetTask();
          });
        }
      }
    };

    controller.textChangeback ??= (string) {
      Log.debug("string = $string");
      _configSendTranparnetMessage();
    };

    // 滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    _keyboardOpenedListener = () {
      _scrollToBottom();
    };
    _keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        setState(() {
          addVisiable = false;
          emjVisiable = false;
        });
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 300))
              .then((value) => _keyboardOpenedListener());
        });
      }
    });
  }

  void delayTransparnetTask() {
    isUserWriting = false;
    setState(() {});
  }

  bool hasSend = false;
  bool addVisiable = false;
  bool emjVisiable = false;
  @override
  Widget build(BuildContext context) {
    // Log.debug("chatUser = $chatUser");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUserWriting ? S.current.writting : chatUser!.username,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: kTitleColor),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
              child: pagePadding(
            ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                Message message = messages[index];
                return MesssageItemView(
                  message: message,
                  icon: message.isOwner ? user!.icon : chatUser!.icon,
                  deleteCallback: (message) {
                    deleteMessage(message);
                  },
                );
              },
            ),
          )),
          MessageInputView(
            controller: controller,
            sendCallback: (text) {
              if (text.isNotEmpty) {
                sendAMessge(text);
                setState(() {});
              }
            },
            addClickCallback: () {
              setState(() {
                FocusScope.of(context).unfocus();
                addVisiable = !addVisiable;
                emjVisiable = false;
                Future.delayed(const Duration(milliseconds: 300),
                    () => {_scrollToBottom()});
              });
            },
            emjClickCallback: () {
              setState(() {
                FocusScope.of(context).unfocus();
                emjVisiable = !emjVisiable;
                addVisiable = false;
                Future.delayed(const Duration(milliseconds: 300),
                    () => {_scrollToBottom()});
              });
            },
          ),
          Visibility(
            visible: addVisiable,
            child: AddKeyboard(
              imageCallback: (filePath) {
                sendAImage(filePath);
              },
            ),
          ),
          Visibility(
            visible: emjVisiable,
            child: EmjKeyboard(
              emojisReadyCallback: (emojis) {
                if (controller.emojiReadyCallback != null) {
                  controller.emojiReadyCallback!(emojis);
                }
              },
              clickEmjKeyboardCallback: (empjiName) {
                if (controller.callback != null) {
                  controller.callback!(empjiName);
                }
              },
            ),
          ),
          const SafeArea(
              child: SizedBox(
            height: 0,
          )),
        ],
      ),
    );
  }

  void sendAMessge(String text) {
    Message message = MessageFactory.messageFromType(MessageType.TEXT);
    message.fromId = user!.userId;
    message.fromEntity = MessageEntityType.USER;
    message.toId = chatUser!.userId;
    message.toEntity = MessageEntityType.USER;
    message.content = text;
    client.sendMessage(message);
    messages.add(message);
    Log.debug("发送了一个消息：$message");
  }

  void sendAImage(String filePath) {
    // 先上传图片，上传成功后发送这个图片
    // 先添加一个message，然后上传图片，
    _addAImageMessageBefore(filePath).then((message) {
      _uploadImage(filePath).then((fileBean) {
        Log.debug("[picture]上传图片成功 $fileBean");
        if (fileBean != null) {
          sendAImageMessage(message, fileBean);
        } else {
          //TODO: wmy
          // 上传失败
          // sendAImage(filePath);
        }
      });
    });
  }

  Future<Message> _addAImageMessageBefore(String filePath) async {
    Completer<Message> completer = Completer();
    Message message = MessageFactory.messageFromType(MessageType.PICTURE);
    message.fromId = user!.userId;
    message.fromEntity = MessageEntityType.USER;
    message.toId = chatUser!.userId;
    message.toEntity = MessageEntityType.USER;
    FileBean fileBean = await FileBean.initFileBean(filePath);
    Log.debug(fileBean.toJson().toString());
    String content = jsonEncode(fileBean.toJson());
    message.content = content;
    completer.complete(message);
    Log.debug("[picture]本地添加一个消息 $message");
    setState(() {
      messages.add(message);
    });
    return completer.future;
  }

  void sendAImageMessage(Message message, FileBean fileBean) {
    Log.debug("[picture]发送图片");
    String content = jsonEncode(fileBean.toJson());
    message.content = content;
    Log.debug(content);
    // 找到message 替换掉
    int findIndex = -1;
    for (var i = messages.length - 1; i >= 0; i--) {
      Message aMessage = messages[i];
      if (aMessage.timestamp == message.timestamp) {
        findIndex = i;
        break;
      }
    }
    messages[findIndex] = message;
    message.content = content;
    Log.debug("[picture]将本地消息进行更新 $messages");
    setState(() {});
    client.sendMessage(message);
    Log.debug("[picture]发送了一个消息：$message");
  }

  Future<FileBean?> _uploadImage(String filePath) {
    Log.debug("[picture]上传图片 $filePath");
    Completer<FileBean?> completer = Completer();
    service.uploadFile(filePath, ImageType.image).then((fileBean) {
      completer.complete(fileBean);
    });
    return completer.future;
  }

  /// 删除一个消息
  void deleteMessage(Message message) {
    showBottomSubTitleDialog(
        context,
        S.current.delete,
        S.current.delete_content,
        [S.current.delete, S.current.cancel], (index) {
      if (index == 0) {
        Navigator.pop(context);
        execDeleteMessage(message);
      }
    });
  }

  void execDeleteMessage(Message message) {
    Message delMessage =
        MessageFactory.messageFromType(MessageType.DELETE_MESSAGE);
    delMessage.fromEntity = message.fromEntity;
    delMessage.fromId = message.fromId;
    delMessage.toEntity = message.toEntity;
    delMessage.toId = message.toId;
    delMessage.content = jsonEncode(
      SendJsonModel(
              msgId: 0,
              messageType: message.messageType,
              timestamp: message.timestamp,
              content: message.timestamp.toString())
          .toJson(),
    );
    Log.debug("$delMessage");
    client.sendMessage(delMessage);
    database.removeMessage(message);
    setState(() {});
  }

  Timer? sendTimer;
  void _configSendTranparnetMessage() {
    if (sendTimer != null) {
      Log.debug("5秒时间没到，不发消息");
      return;
    }
    _sendTranparnetMessage();
    sendTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      Log.debug("$timer");
      timer.cancel();
      sendTimer = null;
    });
  }

  void _sendTranparnetMessage() {
    Message message =
        MessageFactory.messageFromType(MessageType.TRANSPARENT_MESSAGE);
    message.fromEntity = MessageEntityType.USER;
    message.fromId = UserManager().uid();
    message.toEntity = MessageEntityType.USER;
    message.toId = chatUser!.userId;
    Log.debug("message = $message");
    client.sendMessage(message);
  }

  /// ------   im-client-listener   ------

  @override
  DatabaseAddReadableMessage? addReadableCallback;

  @override
  IMClientConnectSuccessCallback? connectSuccessCallback;

  @override
  IMClientReceiveMessageCallback? messageCallback;

  @override
  IMClientTransparentCallback? transparentCallback;

  @override
  IMClientUnReadedMessageCallback? unreadMessageCallback;
}
