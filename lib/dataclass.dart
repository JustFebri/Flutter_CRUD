// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'dart:convert';

class item {
  final String title;
  final String desc;

  item({required this.title, required this.desc});

  Map<String, dynamic> toJson() {
    return {
      "isititle": title,
      "isidesc": desc,
    };
  }

  factory item.fromJSON(Map<String, dynamic> json) {
    return item(
      title: json['isititle'],
      desc: json['isidesc'],
    );
  }
}
