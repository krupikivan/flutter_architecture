import 'package:flutter_architecture/utils/validators.dart';
import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  bool isValid() {
    return value?.isNotEmpty == true && Validator.isValidPassword(value);
  }

  @override
  PasswordValidationError validator(String value) {
    return isValid() ? null : PasswordValidationError.empty;
  }
}
