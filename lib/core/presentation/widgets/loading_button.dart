import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Generic button that can work with any BLoC/Cubit
class GenericCustomButton<T extends StateStreamable<S>, S>
    extends StatelessWidget {
  const GenericCustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.bloc,
    this.isLoadingCondition,
    this.isEnabledCondition,
    this.color,
    this.labelStyle,
    this.isWrapped = false,
    this.borderRadius = 6.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.loadingWidget,
    this.elevation,
    this.shadowColor,
  });

  final String label;
  final VoidCallback onPressed;
  final T? bloc;
  final bool Function(S)? isLoadingCondition;
  final bool Function(S)? isEnabledCondition;
  final TextStyle? labelStyle;
  final bool isWrapped;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Widget? loadingWidget;
  final double? elevation;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    if (bloc != null &&
        (isLoadingCondition != null || isEnabledCondition != null)) {
      return BlocBuilder<T, S>(
        bloc: bloc,
        builder: (context, state) {
          return _buildButton(
            context,
            isLoading: isLoadingCondition?.call(state) ?? false,
            isEnabled: isEnabledCondition?.call(state) ?? true,
          );
        },
      );
    }

    return _buildButton(context);
  }

  Widget _buildButton(
    BuildContext context, {
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return SizedBox(
      width: isWrapped ? null : double.infinity,
      child: elevation != null
          ? ElevatedButton(
              style: _getElevatedButtonStyle(context, isLoading, isEnabled),
              onPressed: (isLoading || !isEnabled) ? null : onPressed,
              child: _buildButtonChild(context, isLoading),
            )
          : TextButton(
              style: _getTextButtonStyle(context, isLoading, isEnabled),
              onPressed: (isLoading || !isEnabled) ? null : onPressed,
              child: _buildButtonChild(context, isLoading),
            ),
    );
  }

  ButtonStyle _getTextButtonStyle(
    BuildContext context,
    bool isLoading,
    bool isEnabled,
  ) {
    return ButtonStyle(
      padding: WidgetStateProperty.all(padding),
      backgroundColor: WidgetStateProperty.all(
        (isLoading || !isEnabled)
            ? Theme.of(context).disabledColor
            : color ?? Theme.of(context).primaryColor,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      overlayColor: WidgetStateProperty.all(
        color?.withOpacity(0.1) ??
            Theme.of(context).primaryColorDark.withOpacity(0.1),
      ),
      foregroundColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  ButtonStyle _getElevatedButtonStyle(
    BuildContext context,
    bool isLoading,
    bool isEnabled,
  ) {
    return ElevatedButton.styleFrom(
      padding: padding,
      backgroundColor: (isLoading || !isEnabled)
          ? Theme.of(context).disabledColor
          : color ?? Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildButtonChild(BuildContext context, bool isLoading) {
    if (isLoading) {
      return loadingWidget ??
          SizedBox(
            height: 22,
            width: 22,
            child: FittedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          );
    }

    return Text(
      label,
      style:
          labelStyle ??
          GoogleFonts.mulish(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
    );
  }
}
