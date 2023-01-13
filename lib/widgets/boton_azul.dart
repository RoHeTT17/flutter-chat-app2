import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final Function()? ponPressed;
  final String textButtom;
  final Color pColor;

  const BotonAzul({super.key, this.ponPressed, required this.textButtom, required this.pColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              
                            )
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            pColor
                          )

                        ),
                        onPressed: ponPressed, 
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Center(
                                       child: Text(textButtom, style: const TextStyle(color: Colors.white, fontSize: 17),)
                                      )
                        ),
                      );
  }
}