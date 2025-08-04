import 'package:flutter_dynamic_form/di/global_providers.dart';
import 'package:flutter_dynamic_form/domain/form_repository.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formControllerProvider =
    StateNotifierProvider<FormController, AsyncValue<List<InputField>>>((ref) {
      final formRepository = ref.watch(formRepositoryProvider);

      return FormController(formRepository);
    });

class FormController extends StateNotifier<AsyncValue<List<InputField>>> {
  final FormRepository formRepository;

  FormController(this.formRepository) : super(const AsyncLoading());
}
