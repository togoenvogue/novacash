import 'package:flutter/material.dart';
import '../../widgets/common/custom_card.dart';
import '../../styles/styles.dart';

class CustomTextInput extends StatelessWidget {
  final Key key;
  final String labelText;
  final String hintText;
  final String helpText;
  final bool isObscure;
  final bool readOnly;
  final double borderRadius;
  final int maxLength;
  final dynamic maxLines;
  final TextInputType inputType;
  final Function onTap;
  final Function onChanged;
  final TextEditingController controller;

  CustomTextInput({
    this.key,
    this.hintText,
    this.helpText,
    @required this.labelText,
    @required this.isObscure,
    this.borderRadius = 50,
    this.inputType,
    this.maxLength,
    @required this.maxLines,
    this.onTap,
    this.onChanged,
    this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Color(0xff2d9c68),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              labelText,
              style: MyStyles().textInputLabel,
            ),
          ),
          SizedBox(height: 4),
          TextField(
            key: key,
            cursorWidth: 1.0,
            onTap: onTap,
            onChanged: onChanged,
            keyboardType: inputType,
            obscureText: isObscure,
            maxLength: maxLength,
            maxLines: maxLines,
            controller: controller,
            readOnly: readOnly,
            style: MyStyles().textInputContent,
            decoration: InputDecoration(
              filled: true,
              fillColor: MyColors().primary,
              counterStyle: TextStyle(
                color: Colors.grey,
              ),
              hintText: hintText,
              hintStyle: MyStyles().textInputContent,
              helperText: helpText,
              helperStyle: MyStyles().hint,
              contentPadding: EdgeInsets.only(
                top: 6.0,
                bottom: 4.0,
                left: 18.0,
                right: 15.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.15),
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white.withOpacity(1),
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
