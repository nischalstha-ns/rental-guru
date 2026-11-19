import 'package:flutter/material.dart';

/// A text field for passwords with a show/hide toggle.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TapRegionCallback? onTapOutside;

  const PasswordField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onTapOutside,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      obscuringCharacter: '\u2022',
      validator: widget.validator,
      onTapOutside: widget.onTapOutside,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}