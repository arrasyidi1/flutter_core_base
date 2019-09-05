import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FormList extends StatelessWidget {
  final List<Widget> items;
  final EdgeInsetsGeometry padding;

  FormList({@required this.items, this.padding});

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: padding,
      children: this.items
    );
  }
}

class FormItem extends StatelessWidget {
  final Widget input;

  FormItem({@required this.input});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: input,
    );
  }
}