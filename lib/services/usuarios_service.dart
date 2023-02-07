import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';

import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuario_response.dart';

class UsuariosService{
  //En esta ocación esta clase no extiende de un ChangeNotifier porque no estamos usando
  //provider, todo esto porque estamos usando un StatefulWidget y el pull to refresh para refrescar.

  Future<List<Usuario>> getUsuarios() async{
    try {

      final url = Uri.parse('${Enviroment.apiUrl}/usuarios');

      final resp = await http.get(
                                  url,
                                  headers: {
                                              'Content-Type': 'application/json',
                                              'x-token'     : await AuthService.getToken() ?? 'xrxrt'
                                           }
                                 );  

      final usuariosResponse = usuariosResponseFromJson(resp.body);

      return usuariosResponse.usuarios;


    } catch (e) {
      return[];
    }
  }

}