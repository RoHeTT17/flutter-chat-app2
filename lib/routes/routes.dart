
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/loading_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'usuario' : ( BuildContext context) => UsuariosPage(),
  'chat'    : ( BuildContext context) => ChatPage(),
  'login'   : ( BuildContext context) => const LoginPage(),
  'register': ( BuildContext context) => RegisterPage(),
  'loading' : ( BuildContext context) => LoadingPage(),

};