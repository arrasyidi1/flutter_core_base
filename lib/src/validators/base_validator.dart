import 'package:flutter/widgets.dart';

import '../helpers.dart';

abstract class BaseValidator {
  // Validate
  String validate(BuildContext context, Object value, String attribute);

  // Validator key
  String key();

  // Validation message
  String message(BuildContext context, String attribute,
      {Map<String, String> replaces}) {
    if (replaces == null) {
      replaces = {'attribute': trans(context, 'attribute.$attribute')};
    } else {
      replaces['attribute'] = trans(context, 'attribute.$attribute');
    }

    return trans(context, 'validation.${this.key()}', replaces: replaces);
  }
}
