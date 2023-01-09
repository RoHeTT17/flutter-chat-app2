import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:chat_app/widgets/chat_message.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>  with TickerProviderStateMixin{

  final _chatTextController = TextEditingController();
  final _fousNode = FocusNode();

  List<ChatMessage> _messages = [
 
                                ];

  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
                      CircleAvatar(
                        child: Text('RR', style: TextStyle(fontSize: 12),),
                        backgroundColor: Colors.blue[100],
                        maxRadius: 14,
                      ),
                      SizedBox(height: 3,),
                      Text('Roger',style: TextStyle(color: Colors.black87, fontSize: 12),)
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
                                       uid: '123', 
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
  }

  @override
  void dispose() {
    //Limpiar los animation controller para no tener problemas de memoria.
    // TODO: implement dispose
    //off del socker para cancelar el escucha del chat

    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}