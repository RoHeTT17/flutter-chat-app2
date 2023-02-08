import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  
  final String pTexto;
  final String uid;
  final AnimationController animationController;
  
  const ChatMessage({
    super.key, 
    required this.pTexto, 
    required this.uid, 
    required this.animationController
  });

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition( //Para la opacidad
      opacity: animationController,
      child: SizeTransition(//Para dar el efecto de desplazar el mensaje
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          //Validar si el uid del mensaje es el mismo que esta conectado en la app
          //se define el _handleSubmit del chat_page
          child: uid == authService.usuario.uid
                 ? _myMessage()
                 : _otherMessage()
        ),
      ),
    );
  }

  Widget _myMessage(){
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
          decoration:  BoxDecoration(
            color: const Color(0xff4D9EF6),
            borderRadius:BorderRadius.circular(20)
          ),
          child: Text(pTexto, style: const TextStyle(color: Colors.white),),
        ),
      );
  }

  Widget _otherMessage(){
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 5, right: 50, left: 5),
          decoration:  BoxDecoration(
            color: const Color(0xffE4E5E8),
            borderRadius:BorderRadius.circular(20)
          ),
          child: Text(pTexto, style: const TextStyle(color: Colors.black87),),
        ),
      );
  }

  

}