import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType textInputType;
  final String hintText;
  final IconData prefixIcon;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final bool isObscure;
  final bool showSuffix;
  const CustomTextField(
      {super.key,
      required this.textInputType,
      required this.hintText,
      required this.prefixIcon,
      required this.isObscure,
      required this.showSuffix,
      required this.textInputAction,
      required this.textEditingController,
      this.validator,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      validator: validator,
      controller: textEditingController,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
        // fontFamily: 'optica',
      ),
      obscureText: false,
      decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: showSuffix
              ? InkWell(
                  onTap: () {
                    // value.toggleVisibility();
                  },
                  child: const Icon(
                    Icons.remove_red_eye_outlined,
                  ),
                )
              : const SizedBox(),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey,
          ),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black45,
              )),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget widget;
  const TextFieldContainer({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.07,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: widget,
      ),
    );
  }
}
