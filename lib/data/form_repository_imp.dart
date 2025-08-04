import 'dart:io';

import 'package:flutter_dynamic_form/data/form_data_source.dart';
import 'package:flutter_dynamic_form/domain/form_repository.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';

class FormRepositoryImp extends FormRepository {
  final FormDataSource formDataSource;

  FormRepositoryImp({required this.formDataSource});

  @override
  Future<List<InputField>> getForms() {
    return formDataSource.fetchForm();
  }

  @override
  Future<void> submitForm(
    Map<String, String> fieldValues,
    Map<String, File> files,
  ) async {
    formDataSource.submitData(fieldValues, files);
  }
}
