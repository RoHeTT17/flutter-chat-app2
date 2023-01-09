import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

 final IconData pIcon;
 final String placeHolder;
 final TextEditingController pTextController;
 final TextInputType keyboardType;
 final bool isPassword;

  const CustomInput({
    super.key, 
    required this.pIcon, 
    required this.placeHolder, 
    required this.pTextController, 
             this.keyboardType = TextInputType.text, 
             this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {
    return   Container(
                        padding:  const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
                        margin:  const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                                        BoxShadow(
                                                  color: Colors.black.withOpacity(0.05), 
                                                  offset: const Offset(0,5), 
                                                  blurRadius: 5
                                                 ),
                                     ]
                        ),
                        child: TextField(
                          controller: pTextController,
                          autocorrect: false,
                          keyboardType: keyboardType,
                          obscureText: isPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(pIcon),
                            focusedBorder: InputBorder.none, //Quitar borde al tener el focus
                            border: InputBorder.none, //quitar bordes
                            hintText: placeHolder
                          ),

                        ),
                      );
}
}