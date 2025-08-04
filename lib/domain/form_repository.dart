import 'dart:io';

import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';

abstract class FormRepository {
  Future<List<InputField>> getForms();

  Future<void> submitForm(
    Map<String, String> fieldValues,
    Map<String, File> files,
  );
}
