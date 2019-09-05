import 'dart:async';

abstract class BaseDataReceiver {
  Future<List<dynamic>> index(String resource, {Map<String, dynamic> queries});
  Future<dynamic> get(String resource, String primaryKey);
  Future<dynamic> update(
      String resource, String primaryKey, Map<String, dynamic> data);
  Future<dynamic> create(String resource, Map<String, dynamic> data);
  Future<bool> delete(String resource, String primaryKey);
}
