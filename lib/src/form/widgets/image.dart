import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../helpers.dart';
import '../../validators/base_validator.dart';

class SelectImage extends StatelessWidget {
  final String name;
  final ImageSource source;
  final String value;
  final int width;
  final int height;
  final int ratioX;
  final int ratioY;
  final List<BaseValidator> validators;
  final FormFieldSetter<File> onSaved;

  File image;

  SelectImage({
    @required this.name,
    this.source,
    this.value,
    this.width,
    this.height,
    this.ratioX,
    this.ratioY,
    this.validators,
    this.onSaved
  });

  Future<ImageSource> _getImageSource(BuildContext context) async {
    if (this.source != null) {
      return this.source;
    }

    return await showDialog<ImageSource>(context: context, builder: (BuildContext context) {
      return new SimpleDialog(
        children: <Widget>[
          new ListTile(
            title: new Text(trans(context, 'camera')),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          new ListTile(
            title: new Text(trans(context, 'gallery')),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    FormFieldValidator<File> validator;
    if (this.validators != null) {
      validator = (File value) => validates(context, value, this.name, this.validators);
    }

    return new FormField<File>(
      initialValue: null,
      onSaved: this.onSaved,
      validator: validator,
      builder: (FormFieldState<File> field) {
        return new InkWell(
          child: new InputDecorator(
            decoration: new InputDecoration(
              labelText: 'Profile picture',
              errorText: field.errorText,
            ),
            child: new Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                bottom: 0.0
              ),
              child: new Row(
                children: <Widget>[
                  new CircleAvatar(
                    backgroundColor: Theme.of(context).disabledColor,
                    backgroundImage: image != null ? FileImage(image) : null,
                    radius: 20.0,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                      left: 12.0
                    ),
                    child: new Text(
                      'Select a profile picture'
                    ),
                  )
                ],
              ),
            )
          ),
          onTap: () async {
            var image = ImagePicker.pickImage(
                source: await _getImageSource(context)
            );
          },
        );
      },
    );
  }
}