sealed class InputValidation {}

enum TextInputValidationType { number, email, phone, other }

class TextValidation extends InputValidation {
  final int? minLen;
  final int? maxLen;
  final TextInputValidationType type;

  TextValidation(this.minLen, this.maxLen, this.type);
}

class FileValidation extends InputValidation {
  final int size;
  FileValidation({required this.size});
}