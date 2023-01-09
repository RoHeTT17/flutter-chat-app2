import 'package:chat_app/widgets/boton_azul.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/custom_logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_labels.dart';



class LoginPage extends StatelessWidget {

  const LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                                Logo(titulo: 'Messenger',),
                                _Form(),
                                Labels(ruta: 'register', tituloCuenta: '¿No tienes cuenta?' ,subtituloCuenta: 'Crear una ahora!',),
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
  @override
  Widget build(BuildContext context) {

    final emailCtrl = TextEditingController();
    final pswCtrl = TextEditingController();

    return Container(
      margin:  const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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
                      BotonAzul(textButtom: 'Ingrese', ponPressed: () => print(emailCtrl.text),),                    


                  ],
      ),
    );
  }
}

