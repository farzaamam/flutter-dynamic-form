import 'dart:ui';

TextDirection getDirection(String text) {
  final rtlChars = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
  return rtlChars.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
}