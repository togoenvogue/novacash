import 'package:flutter/material.dart';
import '../../widgets/common/custom_card.dart';
import '../../styles/styles.dart';
import '../../config/configuration.dart';

class CustomTextInputLeadingAndIcon extends StatelessWidget {
  final Key key;
  final String icon;
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
  final String leadingText;

  CustomTextInputLeadingAndIcon({
    this.key,
    @required this.icon,
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
    this.leadingText,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    child: InkWell(
                      onTap: onTap,
                      splashColor: Colors.blue,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/placeholder.png'),
                        image: NetworkImage(
                                    '$flagUrl/${icon.toLowerCase()}.png') ==
                                null
                            ? Image.asset('assets/images/placeholder.png')
                            : NetworkImage(
                                '$flagUrl/${icon.toLowerCase()}.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 25,
                    //padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.white),
                        top: BorderSide(width: 1, color: Colors.white),
                        left: BorderSide(width: 1, color: Colors.white),
                        right: BorderSide(width: 1, color: Colors.white),
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  SizedBox(height: 18),
                ],
              ),
              InkWell(
                onTap: onTap,
                splashColor: Colors.blue,
                child: Container(
                  child: Text(
                    leadingText,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      fontFamily: MyFontFamily().family2,
                      color: MyColors().primary,
                    ),
                  ),
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
              Expanded(
                child: TextField(
                  key: key,
                  cursorWidth: 1.0,
                  //onTap: onTap,
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
                      top: 5.0,
                      bottom: 5.0,
                      left: 15.0,
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
                        width: 1,
                        color: Color(0xff5A73CB),
                      ),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
