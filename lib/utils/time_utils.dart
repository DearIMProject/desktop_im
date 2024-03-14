String getTime(int timestamp) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var nowDateTime = DateTime.now();
  if (nowDateTime.year != dateTime.year) {
    return "${dateTime.year}";
  }
  if (nowDateTime.month != dateTime.month) {
    return "${dateTime.month}月";
  }
  if (nowDateTime.day != dateTime.day) {
    return "${dateTime.month}月${dateTime.day}日";
  }
  return "${dateTime.hour}:${dateTime.minute}";
}

/// 是否过期
bool isExpire(int timestamp) {
  var currentTimestamp = DateTime.now().millisecondsSinceEpoch;
  if (currentTimestamp < timestamp) {
    return false;
  }
  return true;
}
