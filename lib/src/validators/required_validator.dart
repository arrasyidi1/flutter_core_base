import 'package:flutter/widgets.dart';

import 'base_validator.dart';

class RequiredValidator extends BaseValidator {
  @override
  String key() {
    return 'required';
  }

  @override
  String validate(BuildContext context, Object value, String attribute) {
    // If is string
    if (value is String && value.length <= 0) {
      return this.message(context, attribute);
    }

    return value == null ? this.message(context, attribute) : null;
  }
}
