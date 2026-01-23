import 'package:flutter/material.dart';
import 'package:client/utils/error_handling.dart';


typedef TextFieldEvaluate = Result<String, String> Function(String text);
Result<T, String> chainValidators<T>(
    T value, List<Result<T, String> Function(T)> validators) {
  for (final validator in validators) {
    final result = validator(value);
    if (result is Err<T, String>) return result;
  }
  return Ok<T, String>(value);
}

/// Frontend validators
class ReactiveValidator {
  static Result<String, String> email(String value) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (value.isEmpty) return Err<String, String>('Email wajib diisi');
    if (!regex.hasMatch(value)) return Err<String, String>('Format email tidak valid');
    return Ok<String, String>(value);
  }

  static Result<String, String> notEmpty(String value) {
    return value.trim().isEmpty
        ? Err<String, String>('Tidak boleh kosong')
        : Ok<String, String>(value);
  }

  static Result<String, String> noSpaces(String value) {
    return value.contains(' ')
        ? Err<String, String>('Tidak boleh ada spasi')
        : Ok<String, String>(value);
  }

  static Result<String, String> lowercaseOnly(String value) {
    return value.contains(RegExp(r'[A-Z]'))
        ? Err<String, String>('Gunakan huruf kecil saja')
        : Ok<String, String>(value);
  }

  static Result<String, String> requiredLength(
      String value, int min, int max) {
    if (value.length < min) {
      return Err<String, String>('Harus lebih dari $min karakter');
    } else if (value.length > max) {
      return Err<String, String>('Harus kurang dari $max karakter');
    }
    return Ok<String, String>(value);
  }
}

/// Reactive text input widget 
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
  Color _borderColor = Colors.grey;
  String _helperText = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _validate();
  }

  void _validate() {
    final String text = _controller.text;
    Color newColor = Colors.green;
    String newHelperText = '';

    final result = widget.evaluateInput(text);
    if (result is Err<String, String>) {
      newColor = Colors.red;
      newHelperText = result.error;
    }

    if (_borderColor != newColor || _helperText != newHelperText) {
      setState(() {
        _borderColor = newColor;
        _helperText = newHelperText;
      });
    }
  }

  /// Call this to get the current validated value
  Result<String, String> getText() {
    _validate();
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
      controller: _controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: _borderColor),
        helperText: _helperText.isEmpty ? null : _helperText,
        helperStyle: TextStyle(color: _borderColor),
        border: OutlineInputBorder(borderSide: BorderSide(color: _borderColor)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: _borderColor)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: _borderColor, width: 2)),
      ),
    );
  }
}
