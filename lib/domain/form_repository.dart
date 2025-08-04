import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';

abstract class FormRepository {
  Future<List<InputField>> getForms();
}
