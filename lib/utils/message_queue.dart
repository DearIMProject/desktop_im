import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

import 'package:desktop_im/log/log.dart';

typedef Task = void Function(SendPort replyPort);

class MessageQueue {
  late Isolate _isolate;
  late SendPort _sendPort;
  final _taskQueue = Queue<Task>();
  bool _isRunning = false; // 是否有任务正在运行
  bool _initialized = false; // 是否已初始化
  bool get hasInitialezed => _initialized;
  Future<void> initialize() async {
    if (_initialized) return Completer().future;
    _initialized = true;
    _isRunning = false;
    // 用于接收 isolate 的消息的端口
    final receivePort = ReceivePort();

    // 创建一个新的 isolate
    _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);

    // 等待与新的 isolate 的第一次通信，来获取它的sendPort
    _sendPort = await receivePort.first;
  }

  // 将任务函数添加到队列中
  void addTask(Task task) {
    if (!_initialized) throw Exception("TaskQueue is not initialized.");
    _taskQueue.add(task);
    Log.debug("添加task到消息队列 $task");
    _tryExecuteTask();
  }

  // 尝试执行下一个任务
  void _tryExecuteTask() {
    Log.debug("尝试执行下一个任务!");
    // 如果已有任务在运行，或队列为空，则不继续执行
    if (_isRunning || _taskQueue.isEmpty) {
      Log.debug("$_isRunning ${_taskQueue.isEmpty}");
      return;
    }
    Log.debug("修改running");
    _isRunning = true;

    // 获取队列中的下一个任务
    final task = _taskQueue.removeFirst();

    // 创建一个 ReceivePort 来接收任务完成消息
    final taskCompletionPort = ReceivePort();
    taskCompletionPort.listen((_) {
      Log.debug("task finish!");
      _isRunning = false;
      taskCompletionPort.close();
      // 尝试执行下一个任务
      _tryExecuteTask();
    });

    // 执行任务
    task(_sendPort);
  }

  // 用于执行任务的 isolate 入口
  void _isolateEntry(SendPort initialReplyTo) {
    Log.debug("_isolateEntry");
    final port = ReceivePort();
    initialReplyTo.send(port.sendPort);
    port.listen((message) {
      // 任务是一个接收SendPort的函数
      Log.debug("_isolateEntry 接收到message $message");
      Log.debug("_isolateEntry running $_isRunning");
      _isRunning = false;
      if (message != null) {
        Log.debug("message $message");
        final task = message as Task;
        final sendPort = initialReplyTo;
        task(sendPort);
      }
    });
  }

  void dispose() {
    if (_initialized) {
      _isolate.kill(priority: Isolate.immediate);
      _initialized = false;
    }
  }
}
