abstract class KeyValueStorageServiceBase {
  Future<T?> getValue<T>(String key);
  Future<void> setValue<T>(String key, T value);
  Future<bool> removeKey(String key);
}