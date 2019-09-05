import 'package:flutter/widgets.dart';

import 'base_validator.dart';

class PasswordValidator extends BaseValidator {
  @override
  String key() {
    return 'password';
  }

  @override
  String validate(BuildContext context, Object value, String attribute) {
    if (value is String) {
      RegExp _regExp = new RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*');

      if (_regExp.hasMatch(value)) {
        return null;
      }
    }

    return this.message(context, attribute);
  }
}
