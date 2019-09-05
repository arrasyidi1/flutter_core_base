import 'package:flutter/widgets.dart';

import 'base_validator.dart';

class StringValidator extends BaseValidator {
  @override
  String key() {
    return 'string';
  }

  @override
  String validate(BuildContext context, Object value, String attribute) {
    if (value is String) {
      return null;
    }

    return this.message(context, attribute);
  }
}
