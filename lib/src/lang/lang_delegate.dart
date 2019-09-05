import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers.dart';
import 'lang.dart';

class LangDelegate extends LocalizationsDelegate<Lang> {
  const LangDelegate();

  @override
  bool isSupported(Locale locale) {
    return config('app.supportedLocales').contains(locale);
  }

  @override
  Future<Lang> load(Locale locale) async {
    Lang lang = new Lang(locale);
    await lang.load();

    return lang;
  }

  @override
  bool shouldReload(LangDelegate old) => false;
}
