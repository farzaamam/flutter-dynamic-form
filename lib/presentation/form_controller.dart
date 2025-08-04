import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dynamic_form/di/global_providers.dart';
import 'package:flutter_dynamic_form/domain/form_repository.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/presentation/widgets/file_field_widget.dart';
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
  load(){}

  bool isSubmitting = false;
  final Map<String, dynamic> fieldValues = {};
  final Map<String, UploadedFile?> files = {};

  // Other existing members...

  void updateFieldValue(String title, dynamic value) {
    fieldValues[title] = value;
  }

  void updateFile(String title, UploadedFile? file) {
    if (file != null) {
      files[title] = file;
    } else {
      files.remove(title);
    }
  }

  Future<void> submit() async {
    isSubmitting = true;
    try {

    } catch (e,s) {
      print("dfesfdrgvdrv $s : $e");

      rethrow;
    } finally {
      isSubmitting = false;
    }
  }

}
