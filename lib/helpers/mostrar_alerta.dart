import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarAlerta (BuildContext context, String titulo, String subtitulo){

  //Android
  if(Platform.isAndroid){
    //Si entra aquíu hace el return y no ya no entra al de IOS
     return  showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: Text(titulo),
                        content: Text(subtitulo),
                        actions: [
                                    MaterialButton(
                                      elevation: 5,
                                      textColor: Colors.blue,
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Aceptar'),
                                    )
                                ],
                      ),
          
                    );
  }

  //IOS
  showDialog(
             context: context, 
             builder:(context) =>  CupertinoAlertDialog(
                        title: Text(titulo),
                        content: Text(subtitulo),
                        actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Aceptar'),
                                    )
                                ],             
             ),
             );

}