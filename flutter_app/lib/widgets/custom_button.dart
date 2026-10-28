import 'package:flutter/material.dart';

import '../config/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth =
        width ?? double.infinity;

    final buttonPadding =
        padding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            );

    if (isOutlined) {
      return OutlinedButton(
        onPressed:
        isLoading ? null : onPressed,

        style: OutlinedButton.styleFrom(
          minimumSize: Size(
            effectiveWidth,
            height,
          ),

          side: BorderSide(
            color:
            backgroundColor ??
                AppColors.primary,
            width: 1.5,
          ),

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              borderRadius,
            ),
          ),

          padding: buttonPadding,

          tapTargetSize:
          MaterialTapTargetSize
              .shrinkWrap,

          visualDensity:
          VisualDensity.standard,
        ),

        child: _buildChild(
          isOutlined: true,
        ),
      );
    }

    return ElevatedButton(
      onPressed:
      isLoading ? null : onPressed,

      style: ElevatedButton.styleFrom(
        backgroundColor:
        backgroundColor ??
            AppColors.primary,

        foregroundColor:
        textColor ?? Colors.white,

        disabledBackgroundColor:
        backgroundColor ??
            AppColors.primary,

        disabledForegroundColor:
        textColor ?? Colors.white,

        elevation: 0,

        minimumSize: Size(
          effectiveWidth,
          height,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
            borderRadius,
          ),
        ),

        padding: buttonPadding,

        tapTargetSize:
        MaterialTapTargetSize
            .shrinkWrap,

        visualDensity:
        VisualDensity.standard,
      ),

      child: _buildChild(
        isOutlined: false,
      ),
    );
  }

  // ===========================================================================
  // CHILD
  // ===========================================================================

  Widget _buildChild({
    required bool isOutlined,
  }) {
    final buttonColor = isOutlined
        ? (backgroundColor ??
        AppColors.primary)
        : (textColor ?? Colors.white);

    // -------------------------------------------------------------------------
    // LOADING
    // -------------------------------------------------------------------------

    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,

        child:
        CircularProgressIndicator(
          strokeWidth: 2.5,

          valueColor:
          AlwaysStoppedAnimation<
              Color>(
            buttonColor,
          ),
        ),
      );
    }

    // -------------------------------------------------------------------------
    // ICON + TEXT
    // -------------------------------------------------------------------------

    if (icon != null) {
      return Row(
        mainAxisSize:
        MainAxisSize.min,

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            size: 20,
            color: buttonColor,
          ),

          const SizedBox(width: 8),

          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              softWrap: false,
              textAlign:
              TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                fontWeight:
                FontWeight.w600,
                color: buttonColor,
              ),
            ),
          ),
        ],
      );
    }

    // -------------------------------------------------------------------------
    // TEXT ONLY
    // -------------------------------------------------------------------------

    return Text(
      text,
      maxLines: 1,
      overflow:
      TextOverflow.ellipsis,
      softWrap: false,
      textAlign:
      TextAlign.center,

      style: TextStyle(
        fontSize: 15,
        fontWeight:
        FontWeight.w600,
        color: buttonColor,
      ),
    );
  }
}