import 'package:flutter/widgets.dart';

import 'base_validator.dart';

class MaxValidator extends BaseValidator {
  MaxValidator(this._max);
  int _max;

  @override
  String key() {
    return 'max';
  }

  @override
  String validate(BuildContext context, Object value, String attribute) {
    if (value is String && value.length > this._max) {
      return this
          .message(context, attribute, replaces: {'max': this._max.toString()});
    }

    return null;
  }
}
