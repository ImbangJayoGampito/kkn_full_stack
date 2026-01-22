import 'package:flutter/material.dart';
import 'package:client/utils/error_handling.dart';

typedef TextFieldEvaluate = Result<String> Function(String text);
Result<T> chainValidators<T>(T value, List<Result<T> Function(T)> validators) {
  for (final validator in validators) {
    final result = validator(value);
    if (result is Err<T>) return result;
  }
  return Ok(value);
}

// Validators used for frontend only
class ReactiveValidator {
  static Result<String> email(String value) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (value.isEmpty) return Err('Email wajib diisi');
    if (!regex.hasMatch(value)) return Err('Format email tidak valid');
    return Ok(value);
  }

  static Result<String> notEmpty(String value) {
    return value.trim().isEmpty ? Err('Tidak boleh kosong') : Ok(value);
  }

  static Result<String> noSpaces(String value) {
    return value.contains(' ') ? Err('Tidak boleh ada spasi') : Ok(value);
  }

  static Result<String> lowercaseOnly(String value) {
    return value.contains(RegExp(r'[A-Z]'))
        ? Err('Gunakan huruf kecil saja')
        : Ok(value);
  }

  static Result<String> requiredLength(String value, int min, int max) {
    if (value.length < min) {
      return Err('Harus lebih dari $min karakter');
    } else if (value.length > max) {
      return Err('Harus kurang dari $max karakter');
    }
    return Ok(value);
  }
}

class ReactiveTextInput extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextFieldEvaluate evaluateInput;
  const ReactiveTextInput({
    super.key,
    required this.evaluateInput,
    required this.labelText,
    required this.obscureText,
  });
  @override
  State<ReactiveTextInput> createState() => ReactiveTextInputState();
}

class ReactiveTextInputState extends State<ReactiveTextInput> {
  final TextEditingController _controller = TextEditingController();
  void initState() {
    super.initState();
    _controller.addListener(onTextChanged);
  }

  Color _borderColor = Color.fromARGB(255, 132, 116, 116);

  String _bottomText = "";
  void validate() {
    final String text = _controller.text;
    Color currentColor = Color.fromARGB(255, 5, 184, 44);
    String textError = "";
    Result<String> username = widget.evaluateInput(text);
    if (username is Err<String>) {
      currentColor = Colors.red;
      textError = username.error as String;
    }

    setState(() {
      _borderColor = currentColor;
      _bottomText = textError;
    });
  }

  void onTextChanged() {
    validate();
  }

  Result<String> getText() {
    validate();
    return widget.evaluateInput(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: _borderColor)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _borderColor, width: 2.0),
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: _borderColor),
        helperText: _bottomText,
        helperStyle: TextStyle(color: _borderColor),
      ),
    );
  }
}
