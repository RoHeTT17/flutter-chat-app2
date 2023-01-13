import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';

class LoadingPage extends StatelessWidget {

  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder:(context, snapshot) {
          return const Center(
                              child: Text('Espere...'),
                             ); 
        },
      ),
   );
  }

Future checkLoginState (BuildContext context, [bool mounted = true])async{

    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if(!mounted) return;

    if(autenticado){
      //Conectar al socket server
      //Navigator.pushReplacementNamed(context, 'usuario');
      //Con opción a animación
      Navigator.pushReplacement(
                                context, 
                                PageRouteBuilder(pageBuilder: (_ , __ , ___) => const UsuariosPage(),
                                transitionDuration: const Duration(milliseconds: 200)
      ));
    }else{
      //Navigator.pushReplacementNamed(context, 'login');
            Navigator.pushReplacement(
                                context, 
                                PageRouteBuilder(pageBuilder: (_ , __ , ___) => const LoginPage(),
                                transitionDuration: const Duration(milliseconds: 0)
      ));
    }
}

}