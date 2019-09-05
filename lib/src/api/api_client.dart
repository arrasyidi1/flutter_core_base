import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers.dart';
import 'api_exception.dart';

class ApiClient {
  final RegExp _urlRegExp = new RegExp(r'^(?:(?:http|https|ftp):\/\/)');
  final http.Client _inner;

  ApiClient() : this._inner = new http.Client();

  Future<http.Response> delete(url, {Map<String, String> headers}) async {
    return this._sendRequest(this
        ._inner
        .delete(this._setUrl(url), headers: await this._setHeaders(headers)));
  }

  Future<http.Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    return this._sendRequest(this._inner.patch(this._setUrl(url),
        headers: await this._setHeaders(headers),
        body: body,
        encoding: encoding));
  }

  Future<http.Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    return this._sendRequest(this._inner.put(this._setUrl(url),
        headers: await this._setHeaders(headers),
        body: body,
        encoding: encoding));
  }

  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    print(this._setUrl(url));

    return this._sendRequest(this._inner.post(this._setUrl(url),
        headers: await this._setHeaders(headers),
        body: body,
        encoding: encoding));
  }

  Future<http.Response> get(url, {Map<String, String> headers}) async {
    return this._sendRequest(this
        ._inner
        .get(this._setUrl(url), headers: await this._setHeaders(headers)));
  }

  String _setUrl(String url) {
    if (this._urlRegExp.hasMatch(url)) {
      return url;
    }

    return this._baseUri + (url.startsWith('/') ? url.substring(1) : url);
  }

  String get _baseUri {
    String uri = config('api.url');

    return uri.endsWith('/') ? uri : uri + '/';
  }

  Future<Map<String, String>> _setHeaders(Map<String, String> headers) async {
    if (headers == null) {
      headers = new Map<String, String>();
    }

    headers['Accept'] = 'application/json';

    if (auth().check()) {
      headers['Authorization'] = await auth().getBearerToken();
    }

    return headers;
  }

  Future<http.Response> _sendRequest(Future<http.Response> request) async {
    http.Response response = await request;

    if (ApiException.hasError(response)) {
      throw new ApiException(response);
    }

    return request;
  }
}
