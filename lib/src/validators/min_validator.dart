import 'package:flutter/widgets.dart';

import 'base_validator.dart';

class MinValidator extends BaseValidator {
  MinValidator(this._min);
  int _min;

  @override
  String key() {
    return 'min';
  }

  @override
  String validate(BuildContext context, Object value, String attribute) {
    if (value is String && value.length < this._min) {
      return this
          .message(context, attribute, replaces: {'min': this._min.toString()});
    }

    return null;
  }
}
