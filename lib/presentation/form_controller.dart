import 'dart:async';
import 'package:flutter/cupertino.dart';
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

  FormController(this.formRepository) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _load() async {
    state = const AsyncLoading();
    try {
      final forms = await formRepository.getForms();
      state = AsyncValue.data(forms);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      debugPrint('Failed to load: $e\n$st');
    }
  }
}
