import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers.dart';
import 'base_data_receiver.dart';

class ApiDataReceiver extends BaseDataReceiver {
  @override
  Future create(String resource, Map<String, dynamic> data) async {
    return this._decode(await apiClient().post(resource + config('api.create'), body: data));
  }

  @override
  Future<bool> delete(String resource, String primaryKey) async {
    try {
      await apiClient().delete(this._makePath(resource, primaryKey));
    } catch (e) {
      return false;
    }

    return false;
  }

  @override
  Future get(String resource, String primaryKey) async {
    return this
        ._decode(await apiClient().get(this._makePath(resource, primaryKey)));
  }

  @override
  Future<List> index(String resource, {Map<String, dynamic> queries}) async {
    if (queries != null) {
      Uri uri = Uri.parse(resource);
      return this._decode(await apiClient()
          .get(uri.replace(queryParameters: queries).toString()));
    }

    return this._decode(await apiClient().get(resource));
  }

  @override
  Future update(
      String resource, String primaryKey, Map<String, dynamic> data) async {
    return this._decode(await apiClient()
        .put(this._makePath(resource, primaryKey), body: data));
  }

  String _makePath(String resource, String primaryKey) {
    return '$resource/$primaryKey';
  }

  dynamic _decode(http.Response response) {
    return json.decode(response.body)['data'];
  }
}
