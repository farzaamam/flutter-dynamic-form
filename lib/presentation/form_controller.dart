import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dynamic_form/di/global_providers.dart';
import 'package:flutter_dynamic_form/domain/form_repository.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formControllerProvider =
    StateNotifierProvider<FormController, FormPageState>((ref) {
      final formRepository = ref.watch(formRepositoryProvider);
      return FormController(formRepository);
    });

class FormController extends StateNotifier<FormPageState> {
  final FormRepository formRepository;

  FormController(this.formRepository)
    : super(FormPageState(fields: const AsyncLoading())) {
    _init();
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _load() async {
    state = state.copyWith(fields: AsyncValue.loading());
    try {
      final forms = await formRepository.getForms();
      state = state.copyWith(fields: AsyncValue.data(forms));
    } catch (e, st) {
      state = state.copyWith(fields: AsyncValue.error(e, st));
      debugPrint('Failed to load: $e\n$st');
    }
  }

  final Map<String, String> fieldValues = {};
  final Map<String, File> files = {};

  void updateFieldValue(String title, dynamic value) {
    fieldValues[title] = value;
  }

  void updateFile(String title, File? file) {
    if (file != null) {
      files[title] = file;
    } else {
      files.remove(title);
    }
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);
    try {
      await formRepository.submitForm(fieldValues, files);
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  reload() {
    _load();
  }
}

class FormPageState {
  final AsyncValue<List<InputField>> fields;
  final bool isSubmitting;

  FormPageState({required this.fields, this.isSubmitting = false});

  FormPageState copyWith({
    AsyncValue<List<InputField>>? fields,
    bool? isSubmitting,
  }) {
    return FormPageState(
      fields: fields ?? this.fields,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
