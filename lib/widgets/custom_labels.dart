import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String ruta;
  final String tituloCuenta;
  final String subtituloCuenta;

  const Labels({
    super.key, 
    required this.ruta, 
    required this.tituloCuenta, 
    required this.subtituloCuenta
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                  Text(tituloCuenta, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    child: Text(subtituloCuenta, style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),),
                    onTap: (){
                     Navigator.of(context).pushReplacementNamed(ruta);
                    }  
                  )
                ],
    );
  }
}