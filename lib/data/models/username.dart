import 'package:flutter_architecture/utils/validators.dart';
import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  bool isValid() {
    return value?.isNotEmpty == true && Validator.isValidEmail(value);
  }

  @override
  UsernameValidationError validator(String value) {
    return isValid() ? null : UsernameValidationError.empty;
  }
}
