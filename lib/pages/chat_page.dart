import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/models/mensajes_response.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';

import 'package:chat_app/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>  with TickerProviderStateMixin{

  final _chatTextController = TextEditingController();
  final _fousNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

@override
  void initState() {
    super.initState();
  
     //listen en false, porque no se puede redibujar nada en el init state, amenos que
     //este en un callback
     chatService   = Provider.of<ChatService>  (context,listen: false);
     socketService = Provider.of<SocketService>(context,listen: false);
     authService   = Provider.of<AuthService>  (context,listen: false);

     //Metodo para estar escuchando el 'mensaje-personal' que responde el servidor
     socketService.getSocket.on('mensaje-personal', _escucahrMensaje);
  
      //cargar historial de mensjaes
      _cargarHistorial (chatService.usuarioPara.uid);

  }

  void _escucahrMensaje (dynamic payload){

    //1. Crear una instancia de ChatMessage
    ChatMessage message = ChatMessage(
                                      pTexto: payload['mensaje'], 
                                      uid:    payload['de'], 
                                      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300)) 
                                     );

    //2. Agregar al inicio el mensaje a lista de mensajes
    setState(() {
        _messages.insert(0, message);
    });

    //3. Disparar la animación
    message.animationController.forward();

  }

  void _cargarHistorial(String uidPara) async{

    //Consumir el recurso
    List<Mensaje> chat = await chatService.getChat(uidPara);

    //Iterar la lista y regresar una instancia de CharMessage
    final history = chat.map((m) => ChatMessage(
                                                 pTexto: m.mensaje, 
                                                 uid:    m.de, 
                                                 //..forward para lanzar de forma inmediata el animation controller
                                                 animationController: AnimationController(vsync: this,duration: const Duration(milliseconds: 0))..forward()
                                                ));
     //Agregar a la lista los mensajes 
     setState(() {      
        _messages.insertAll(0, history);
    });

  }

  @override
  Widget build(BuildContext context) {

  //final chatService = Provider.of<ChatService>(context,);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        maxRadius: 14,
                        child: Text(
                                    chatService.usuarioPara.nombre.substring(0,2), 
                                    style: const TextStyle(fontSize: 12),
                                   ),
                      ),
                      const SizedBox(height: 3,),
                      Text(
                           chatService.usuarioPara.nombre,
                           style: const TextStyle(color: Colors.black87, fontSize: 12),
                          )
                    ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
                      Flexible(
                        child: ListView.builder(
                                                physics: const BouncingScrollPhysics(),
                                                itemCount: _messages.length,
                                                itemBuilder: (context, index) => _messages[index],
                                                reverse: true,
                                              )
                      ),
                      const Divider(height: 1,),
                      Container(
                        color: Colors.white,
                        //height: 100,
                        child: _inputChat(),
                      )
                    ],
        ),

      )
   );
  }

  Widget _inputChat(){

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: [
                               //Caja del Text
                                Flexible(
                                         child: TextField(
                                                            controller: _chatTextController,
                                                            onSubmitted: _handleSubmint,
                                                            onChanged: (texto) {

                                                              setState(() {
                                                                 if(texto.trim().isNotEmpty) {
                                                                   _estaEscribiendo = true;
                                                                 } else {
                                                                   _estaEscribiendo = false;
                                                                 }
                                                              });
                                                              
                                                            },
                                                            decoration: const InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
                                                            focusNode: _fousNode,
                                                         )
                                        ),

                                //Botón de Enviar    
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Platform.isIOS
                                         ? CupertinoButton(
                                                            onPressed: _estaEscribiendo 
                                                                            ? () => _handleSubmint(_chatTextController.text.trim())
                                                                            : null,
                                                            child: const Text('Enviar')
                                                          )
                                         : Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                            child: IconTheme(
                                              data: IconThemeData(color: Colors.blue[400],),
                                              child: IconButton(
                                                                 highlightColor: Colors.transparent, 
                                                                 splashColor: Colors.transparent,    
                                                                 icon: const Icon(Icons.send), 
                                                                 onPressed: _estaEscribiendo 
                                                                            ? () => _handleSubmint(_chatTextController.text.trim())
                                                                            : null
                                                               ),
                                            ),
                                         ) 
                                )    
                             ],
                  ),
      )
    );

  }

  _handleSubmint (String texto){

       if(texto.isEmpty) return;
 
       final newMessage = ChatMessage(
                                       pTexto: texto, 
                                       uid: authService.usuario.uid, //valdiar que sea el mismo dispositivo
                                       animationController: AnimationController(vsync: this, duration: const Duration(microseconds: 200)),
                                    );
       _messages.insert(0, newMessage); 
       newMessage.animationController.forward();

       setState(() {
         _estaEscribiendo = false;
         //limpiar texto
         _chatTextController.clear();
         //mantener el focus
         _fousNode.requestFocus();
       
       }); 

       //Armar el payload que se mandará al servidor
       socketService.getSocket.emit('mensaje-personal',{
        'de'  : authService.usuario.uid,//quien esta mandando el mensaje
        'para': chatService.usuarioPara.uid,//para quien (este se carga cuando se selcciona el usuario a chatear)
        'mensaje': texto
       });
  }

  @override
  void dispose() {
    //Limpiar los animation controller para no tener problemas de memoria.
    //off del socker para cancelar el escucha del chat

    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    //Al salir de la pantalla no estar escuchando los mensajes que estan llegnado.
    //Normalmente si se escuchan solo es para la clase
    socketService.getSocket.off('mensaje-personal');

    super.dispose();
  }
  

}