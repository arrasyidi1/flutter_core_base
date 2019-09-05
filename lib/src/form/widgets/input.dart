import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../helpers.dart';
import '../../validators/base_validator.dart';

enum InputType {
  string, number, email, password, phone, multiline
}

class Input extends StatelessWidget {
  final String name;
  final InputType type;
  final String value;
  final List<BaseValidator> validators;
  final FormFieldSetter<String> onSaved;

  Input({@required this.name, this.type : InputType.string, this.value, this.validators, this.onSaved});

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    bool obscureText = false;

    switch (this.type) {
      case InputType.number:
        keyboardType = TextInputType.number;
        break;

      case InputType.email:
        keyboardType = TextInputType.emailAddress;
        break;

      case InputType.password:
        keyboardType = TextInputType.text;
        obscureText = true;
        break;

      case InputType.phone:
        keyboardType = TextInputType.phone;
        break;

      case InputType.multiline:
        keyboardType = TextInputType.multiline;
        break;

      case InputType.string:
      default:
        keyboardType = TextInputType.text;
        break;
    }

    FormFieldValidator<String> validator;
    if (this.validators != null) {
      validator = (String value) => validates(context, value, this.name, this.validators);
    }

    return new TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      initialValue: this.value,
      onSaved: this.onSaved,
      maxLines: this.type == InputType.multiline ? null : 1,
      decoration: new InputDecoration(
        hintText: trans(context, 'hint.${this.name}'),
        labelText: trans(context, 'attribute.${this.name}')
      ),
      validator: validator
    );
  }

}
