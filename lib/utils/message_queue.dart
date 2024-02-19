import 'dart:collection';

import 'package:desktop_im/log/log.dart';

typedef QueueTask = Future<void> Function();

class MessageQueue {
  final Queue<QueueTask> _taskQueue = Queue<QueueTask>();
  bool _isProcessing = false;

  // 向队列中添加任务
  void addTask(QueueTask task) {
    _taskQueue.add(task);
    if (!_isProcessing) {
      _processNext();
    }
  }

  // 递归处理队列
  void _processNext() {
    if (_taskQueue.isEmpty) {
      _isProcessing = false;
      return;
    }
    _isProcessing = true;
    var task = _taskQueue.removeFirst();
    task().then((_) {
      _processNext();
    }).catchError((error) {
      Log.error('Error occurred in MessageQueue: $error');
      _processNext(); // Even if there's an error, proceed with the next task.
    });
  }
}
