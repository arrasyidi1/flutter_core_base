import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lang {
  Lang(this.locale);

  final Locale locale;

  static Lang of(BuildContext context) {
    return Localizations.of<Lang>(context, Lang);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String _data = await rootBundle
        .loadString('resources/lang/${this.locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(_data);

    this._sentences = new Map();
    _result.forEach((String key, dynamic value) {
      this._sentences[key] = value.toString();
    });

    return true;
  }

  String trans(String key, {Map<String, String> replaces}) {
    String _sentence = this._sentences[key];

    if (replaces != null) {
      replaces.forEach((String from, String replace) {
        _sentence = _sentence.replaceAll('\:$from', replace);
      });
    }

    return _sentence;
  }
}
