import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/helpers/mostrar_alerta.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_labels.dart';

class RegisterPage extends StatelessWidget {

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                                Logo(titulo:'Registrar'),
                                _Form(),
                                Labels(ruta: 'login', tituloCuenta: '¿Tienes una cuenta?', subtituloCuenta: 'Iniciar ahora',),
                                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
                             ],
            ),
          ),
        ),
      )
   );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl  = TextEditingController();
  final emailCtrl = TextEditingController();
  final pswCtrl   = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin:  const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
                      //Nombre
                      CustomInput(
                                  pIcon: Icons.perm_identity,
                                  placeHolder: 'Nombre',
                                  keyboardType: TextInputType.text, 
                                  pTextController: nameCtrl ,
                                 ),          
                      //Correo
                      CustomInput(
                                  pIcon: Icons.email_outlined,
                                  placeHolder: 'Correo',
                                  keyboardType: TextInputType.emailAddress, 
                                  pTextController: emailCtrl ,
                                 ),
                      //Password
                      CustomInput(
                                  pIcon: Icons.lock_outline,
                                  placeHolder: 'Contraseña',
                                  isPassword: true,
                                  pTextController: pswCtrl ,
                                 ),  
                      BotonAzul(
                                 textButtom: 'Registrarse', 
                                 ponPressed: authService.getAutenticando 
                                   ? null 
                                   : () async{
                                        //Ocultar teclado
                                        FocusScope.of(context).unfocus();
                                        final loginOk = await authService.register(nameCtrl.text.trim(),emailCtrl.text.trim(), pswCtrl.text.trim());
                                       
                                       //ESto porque es un StatefullWidget
                                        if(!mounted) return;

                                        if( loginOk){
                                          //Conectar al socketServer
                                           socketService.connect();
                                           Navigator.pushReplacementNamed(context,'usuario');                               
                                         }else{
                                           mostrarAlerta(context, 'Error', authService.msgError);
                                        }
                                      },

                                 pColor:  authService.getAutenticando ? Colors.grey : Colors.blue,
                               ),                    


                  ],
      ),
    );
  }
}

