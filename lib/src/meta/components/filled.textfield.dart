// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilledTextField extends StatelessWidget {
  const FilledTextField(
      {this.controller,
      this.focusNode,
      this.onChanged,
      this.inputFormatters,
      this.hint,
      this.prefixText,
      this.autocorrect = false,
      this.decoration,
      this.height,
      this.width,
      this.autofillHints,
      this.textCapitalization = TextCapitalization.none,
      this.onTap,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.readOnly = false,
      this.maxLines = 1,
      this.obsecured = false,
      this.textInputType = TextInputType.text,
      this.validator,
      Key? key})
      : super(key: key);
  final bool autocorrect, readOnly, obsecured;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? hint, prefixText;
  final int maxLines;
  final InputDecoration? decoration;
  final double? height, width;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final GestureTapCallback? onTap;
  final TextInputType textInputType;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width ?? 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.grey[200]!,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          keyboardType: textInputType,
          autocorrect: autocorrect,
          autofillHints: autofillHints,
          focusNode: focusNode,
          onChanged: onChanged,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          validator: validator,
          controller: controller,
          readOnly: readOnly,
          obscureText: obsecured,
          maxLines: maxLines,
          decoration: decoration ??
              InputDecoration(
                isDense: true,
                hintText: hint,
                prefixText: prefixText,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                fillColor: Colors.grey[200],
              ),
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
        ),
      ),
    );
  }
}
