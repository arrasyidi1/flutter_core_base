class MagicConfig {
  /// All of the configuration items.
  Map<String, dynamic> _items = new Map<String, dynamic>();

  /// Get the specified configuration value.
  dynamic get(String key) {
    return this._items[key];
  }

  /// Set a given configuration value.
  void set(String key, dynamic value) {
    this._items[key] = value;
  }

  /// Determine if the given configuration value exists.
  bool has(String key) {
    return this._items.containsKey(key);
  }
}
