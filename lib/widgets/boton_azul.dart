import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {

  final Function()? ponPressed;
  final String textButtom;

  const BotonAzul({super.key, this.ponPressed, required this.textButtom});

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
                            Colors.blue
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