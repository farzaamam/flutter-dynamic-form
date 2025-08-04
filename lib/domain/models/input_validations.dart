sealed class InputValidation {}

enum TextInputValidationType { number, email, phone, plain }

class TextValidation extends InputValidation {
  final int? minLen;
  final int? maxLen;
  final TextInputValidationType type;

  TextValidation(this.minLen, this.maxLen, this.type);
}

class FileValidation extends InputValidation {
  final double maxSize;

  FileValidation({required this.maxSize});
}
