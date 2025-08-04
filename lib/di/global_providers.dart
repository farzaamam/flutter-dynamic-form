import 'package:flutter_dynamic_form/data/form_data_source.dart';
import 'package:flutter_dynamic_form/data/form_repository_imp.dart';
import 'package:flutter_dynamic_form/data/parser.dart';
import 'package:flutter_dynamic_form/domain/form_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formRepositoryProvider = Provider<FormRepository>((ref) {
  final formDataSource = ref.watch(formDataSourceProvider);
  return FormRepositoryImp(formDataSource: formDataSource);
});

final formDataSourceProvider = Provider<FormDataSource>((ref) {
  return FormDataSource(FormParser());
});
