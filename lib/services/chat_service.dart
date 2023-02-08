import 'package:chat_app/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';

import 'package:chat_app/models/usuario.dart';

import 'package:chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier{

  //Usuario para el cual van los mensajes
  late Usuario usuarioPara;

  //Petición para obtener los ultimos 30 mensajes

  Future<List<Mensaje>> getChat (String usuarioID) async{

      final url = Uri.parse('${Enviroment.apiUrl}/mensajes/$usuarioID');

      final token = await AuthService.getToken();


      final resp = await http.get(url, 
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'x-token': token!
                                  });
      //Falta valdiar que sea un status 200
      final mensajesResp = mensajesResponseFromJson(resp.body);  

      return mensajesResp.mensajes;                         

  }

}