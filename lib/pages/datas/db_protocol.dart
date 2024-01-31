abstract class DbProtocol {
  // late Box box;
  void install(String boxName);
  void uninstall();

  void addItem(item);
  void removeItem(item);
  void updateItem(item);
}
