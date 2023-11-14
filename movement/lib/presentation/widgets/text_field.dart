import 'package:flutter/material.dart';

import '../../infrastructure/notifiers/responsive_ui.dart';
import '../../text_style.dart';

mixin TextFieldMixin {
  void onTextChanged(
    String source,
    String text,
  );
}

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final Widget icon;
  final String source;
  final TextInputType keyboardType;
  final bool isObscureText;
  final TextCapitalization textCapitalization;
  final TextFieldMixin delegate;

  bool isVisible = false;

  TextFieldWidget({
    required this.hintText,
    required this.icon,
    required this.source,
    required this.keyboardType,
    required this.isObscureText,
    required this.textCapitalization,
    required this.delegate,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      style: textStyleSourceSans16,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.isObscureText ? !widget.isVisible : widget.isObscureText,
      scrollPadding: EdgeInsets.only(bottom: 600 * y),
      decoration: this.widget.isObscureText
          ? InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              icon: widget.icon,
              hintText: widget.hintText,
              hintStyle: textStyleAkko16,
              suffixIcon: IconButton(
                icon: Icon(
                  widget.isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: () {
                  setState(() {
                    widget.isVisible = !widget.isVisible;
                  });
                },
              ),
            )
          : InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              icon: widget.icon,
              hintText: widget.hintText,
              hintStyle: textStyleAkko16,
            ),
      onChanged: (value) {
        widget.delegate.onTextChanged(widget.source, value);
      },
    );
  }
}
