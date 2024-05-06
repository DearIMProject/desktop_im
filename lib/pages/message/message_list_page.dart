import 'dart:async';
import 'dart:convert';

import 'package:desktop_im/components/common/common_dialog.dart';
import 'package:desktop_im/components/common/common_theme.dart';
import 'package:desktop_im/components/ui/add_keyboard.dart';
import 'package:desktop_im/components/ui/custom_dialog.dart';
import 'package:desktop_im/components/ui/emj_keyboard.dart';
import 'package:desktop_im/components/ui/message_input.dart';
import 'package:desktop_im/generated/l10n.dart';

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/models/group.dart';
import 'package:desktop_im/models/message/chat_entity.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/models/message/send_json_model.dart';

import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/pages/base_page.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/pages/message/message_item.dart';
import 'package:desktop_im/pages/message/message_list_type.dart';
import 'package:desktop_im/pages/message/services/message_service.dart';
import 'package:desktop_im/tcpconnect/connect/im_client.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:desktop_im/utils/image_utils.dart';

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
  /// 聊天类型
  ChatEntity? entity;

  /// 个人聊天时的聊天放

  /// 群组聊天时的聊天群组
  // Group? group;
  MessageService service = MessageService();

  User? user = UserManager().user;
  List<Message> messages = [];
  IMDatabase database = IMDatabase();
  IMClient client = IMClient();
  late MessageListType type;

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
    dataChangeCallback = null;
    transparentCallback = null;
    controller.textChangeback = null;

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
    Log.debug("param = ${widget.params}");

    entity = widget.params?["entity"];

    if (entity == null) {
      throw Exception("entity is null");
    }
    type = entity is Group ? MessageListType.GROUP : MessageListType.USER;

    if (user == null) {
      throw Exception("user is null");
    }
    if (messages.isEmpty) {
      messages.addAll(database.getChatMessages(entity!.getKey()));
      Log.debug("$messages");
    }
    dataChangeCallback ??= () {
      messages = [];
      messages.addAll(database.getChatMessages(entity!.getKey()));
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
      if (entity!.getId() == message.fromId) {
        // 显示title 正在输入中..
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
      // Log.debug("string = $string");
      //TODO: wmy 判断是否是个人消息
      if (type == MessageListType.USER) {
        _configSendTranparnetMessage();
      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUserWriting
              ? S.current.writting
              : entity is Group
                  ? "${entity!.getName()}(${(entity as Group).contentUserIds.length})"
                  : entity!.getName(),
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
                  deleteCallback: (message) {
                    _deleteMessage(message);
                  },
                );
              },
            ),
          )),
          MessageInputView(
            controller: controller,
            audioCallback: (isAudioPress) {
              if (isAudioPress) {
                // 开始录音
                // AudioManager.instance.startRecord();
              } else {
                // 停止录音
                // AudioManager.instance.stopRecord();
              }
            },
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
    message.toId = entity!.getId();
    message.toEntity = type == MessageListType.GROUP
        ? MessageEntityType.GROUP
        : MessageEntityType.USER;
    message.content = text;
    message.entityId = entity!.getId();
    message.entityType = type == MessageListType.GROUP
        ? MessageEntityType.GROUP
        : MessageEntityType.USER;
    client.sendMessage(message);
    messages.add(message);
    Log.debug("发送了一个消息：$message");
  }

  void sendAImage(String filePath) {
    CustomDialog().showLoadingDialog(context, S.current.processing);
    ImageUtils.sendFile(filePath, user!.userId, entity!.getId(), (message) {
      setState(() {
        CustomDialog().dismissDialog(context);
        messages.add(message);
        _scrollToBottom();
      });
    }).then((message) {
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
      Log.debug("[picture]将本地消息进行更新 $messages");
      setState(() {});
      Log.debug("[picture]发送了一个消息：$message");
    });
  }

  /// 删除一个消息
  void _deleteMessage(Message message) {
    showBottomSubTitleDialog(
        context,
        S.current.delete,
        S.current.delete_content,
        [S.current.delete, S.current.cancel], (index) {
      if (index == 0) {
        Navigator.pop(context);
        _execDeleteMessage(message);
      }
    });
  }

  void _execDeleteMessage(Message message) {
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
    message.toId = entity!.getId();
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
