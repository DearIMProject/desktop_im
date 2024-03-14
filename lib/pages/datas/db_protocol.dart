/// 数据库接口
abstract class DbProtocol<T> {
  // late Box box;

  /// 初始化数据库
  void install(String boxName);

  /// 关闭数据库
  void uninstall();

  /// 删除所有数据
  Future<int> deleteAllDatas();

  /// 添加一个元素
  void addItem(T item);

  /// 删除一个元素
  void removeItem(T item);

  /// 更新一个元素
  void updateItem(T item);

  /// 根据id获取元素
  T? getItem(int id);

  /// 获取所有的元素
  List<T> getItems();
}
