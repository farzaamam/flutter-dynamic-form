import 'dart:async';
import 'dart:io';
import 'package:flutter_dynamic_form/data/mock_form_json.dart';
import 'package:flutter_dynamic_form/data/parser.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';

class FormDataSource {
  final FormParser formParser;

  FormDataSource(this.formParser);

  Future<List<InputField>> fetchForm() async {
    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 1000));

    return formParser.parseFromJsonString(sampleFormJson);
  }

  submitData(Map<String, String> fieldValues, Map<String, File> files) {}
}
