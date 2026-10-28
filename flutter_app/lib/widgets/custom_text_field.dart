import 'package:flutter/material.dart';

import '../config/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.autofillHints,
    this.textInputAction,
    this.initialValue,
  });

  @override
  State<CustomTextField> createState() =>
      _CustomTextFieldState();
}

class _CustomTextFieldState
    extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isMultiline =
        widget.maxLines > 1;

    final showPasswordToggle =
        widget.isPassword &&
            !isMultiline;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            maxLines: 2,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w600,
              color:
              AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],

        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,

          validator: widget.validator,

          obscureText:
          showPasswordToggle
              ? _obscureText
              : false,

          keyboardType:
          widget.keyboardType,

          maxLines:
          widget.isPassword
              ? 1
              : widget.maxLines,

          minLines:
          isMultiline
              ? 2
              : 1,

          readOnly: widget.readOnly,

          onTap: widget.onTap,

          onChanged:
          widget.onChanged,

          autofillHints:
          widget.autofillHints,

          textInputAction:
          widget.textInputAction,

          style: const TextStyle(
            fontSize: 15,
            color:
            AppColors.textPrimary,
            fontWeight:
            FontWeight.w500,
          ),

          decoration:
          InputDecoration(
            hintText: widget.hint,

            hintMaxLines: 2,

            prefixIcon:
            widget.prefixIcon !=
                null
                ? Icon(
              widget.prefixIcon,
              color:
              AppColors
                  .textSecondary,
              size: 20,
            )
                : null,

            suffixIcon:
            showPasswordToggle
                ? IconButton(
              tooltip:
              _obscureText
                  ? 'Show password'
                  : 'Hide password',
              icon: Icon(
                _obscureText
                    ? Icons
                    .visibility_off_outlined
                    : Icons
                    .visibility_outlined,
                color: AppColors
                    .textSecondary,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscureText =
                  !_obscureText;
                });
              },
            )
                : widget.suffixIcon,

            contentPadding:
            EdgeInsets.symmetric(
              horizontal: 16,
              vertical:
              isMultiline
                  ? 14
                  : 15,
            ),

            alignLabelWithHint:
            isMultiline,

            errorMaxLines: 3,

            counterText: null,
          ),
        ),
      ],
    );
  }
}