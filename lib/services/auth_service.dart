import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/global/environment.dart';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';

class AuthService extends ChangeNotifier{

  String msgError = "";

  late Usuario usuario;
  
  bool _autenticando = false;
  
  bool get getAutenticando => _autenticando;
  set setAutenticando(bool value){
    _autenticando = value;
    notifyListeners();
  }

  // Create storage  
  final _storage = const FlutterSecureStorage();
  //Getters del token de forma estática
  //Es Futuro porque hay que esperar a que terminar la lectura y esta no es asincrona
  static Future<String?> getToken() async{
      //Al ser static no tenemos acceso a las propiedades de las clase, porque se vuelve a instanciar 
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      return token;

  }

  static Future<void> deleteToken() async{
      //Al ser static no tenemos acceso a las propiedades de las clase, porque se vuelve a instanciar 
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'token');

  }

  Future<bool> login(String email, String password) async{

    setAutenticando = true;

    final data ={
          "email": email,
          "password": password
    };

    final url = Uri.parse('${Enviroment.apiUrl}/login');

    final resp = await http.post( url,
                                  body: jsonEncode(data),
                                  headers: {
                                      'Content-Type' : 'application/json'
                                  }
                                );

    setAutenticando = false;
    
    if(resp.statusCode == 200){
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse!.usuario!;
        await _guardarToken(loginResponse.token!);
        return true;
    }else{

      return false;
    }                            

  }

    Future<bool> register(String nombre,String email, String password) async{

    setAutenticando = true;

    final data ={
          "nombre":nombre, 
          "email": email,
          "password": password
    };

    final url = Uri.parse('${Enviroment.apiUrl}/login/new');

    final resp = await http.post( url,
                                  body: jsonEncode(data),
                                  headers: {
                                      'Content-Type' : 'application/json'
                                  }
                                );

    setAutenticando = false;
    
    if(resp.statusCode == 200){
        final loginResponse = loginResponseFromJson(resp.body);
        usuario = loginResponse!.usuario!;
        await _guardarToken(loginResponse.token!);
        return true;
    }else{
      //Mapear un json a un Map sin crear un modelo 
      final bodyError = jsonDecode(resp.body); 
      msgError = bodyError['msg'];//obtener la propiedad del msg
      
      return false;
    }                            

  }

  Future _guardarToken (String token) async{
    //la key se la asignamos
    return await _storage.write(key: 'token', value: token);
  }

  Future<bool> isLoggedIn() async {

    final tokenOld = await _storage.read(key: 'token');

    if(tokenOld == null){
      logout();
      return false;
    }else{

      try {
          final url = Uri.parse('${Enviroment.apiUrl}/login/renew');

          final resp = await http.get( url,
                                      headers: {
                                            'Content-Type' : 'application/json',
                                            'x-token': tokenOld
                                      }
                                    );

          //print(resp.body);
          if(resp.statusCode == 200){
              //Tener mucho cuidado en que los parámetros que se esten regresando sean el mismo nombre
              //habia puesto tokenRenew y el model solo aceptaba token. Tuve que cambiar el backend
              final loginResponse = loginResponseFromJson(resp.body);
              usuario = loginResponse!.usuario!;
              await _guardarToken(loginResponse.token!);
              return true;
          }else{
            //Se llama al logout porque el token ya no sirve y se debe destruir
            logout();
            return false;
          } 
      } catch (e) {
         print("Error: $e");
         logout();
        return false;
      }

    }
  }

  Future logout() async{

    //Borrar token
    await _storage.delete(key: 'token');
  }

}