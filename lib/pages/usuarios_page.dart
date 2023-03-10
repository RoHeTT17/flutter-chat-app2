import 'package:chat_app/services/chat_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/usuarios_service.dart';

import 'package:chat_app/models/usuario.dart';


class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

 final usuarioService = UsuariosService();
 RefreshController _refreshController = RefreshController(initialRefresh: false);

List<Usuario> usuarios=[];
//  final usuarios =[
//                     Usuario(online: true,  email: 'email1@test.com', nombre: 'Roger', uid: '1'),
//                     Usuario(online: false, email: 'email2@test.com', nombre: 'Tete', uid: '2'),
//                     Usuario(online: true,  email: 'email3@test.com', nombre: 'Lili', uid: '3'),
//                     Usuario(online: false, email: 'email4@test.com', nombre: 'Jona', uid: '4'),
//                     Usuario(online: true,  email: 'email5@test.com', nombre: 'Issac', uid: '5'),
//                  ];


@override
  void initState() {
    // Cargar desde el inicio los usuarios
    _cargarUSuarios();  
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
            centerTitle: true,
            title: Text(usuario.nombre, style: const TextStyle(color: Colors.black54),),
            elevation: 1,
            backgroundColor: Colors.white,
            leading: IconButton(onPressed:(() {
                //Desconectar el socket server
                socketService.disconnect();
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
              
            }),
            icon: const Icon(Icons.exit_to_app,color: Colors.black54,),
          ),
      actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child:  socketService.getSeverStatus == ServerStatus.online 
                    
                            ? Icon(Icons.check_circle, color: Colors.blue[400],)
                            : const Icon(Icons.offline_bolt, color: Colors.red,),
                  )
               ],
      ),
      
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUSuarios,
        header: WaterDropHeader( 
                                 complete: Icon (Icons.check, color: Colors.blue[400],),
                                 waterDropColor: Colors.blue,
                               ),
        child: _listViewUsuario()
      )
  
    );
  }

  ListView _listViewUsuario() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder:(context, index) {
        
        return _UsuarioListTile(usuario: usuarios[index]);
      }, 
      separatorBuilder: ((context, index) => const Divider()) , 
      itemCount: usuarios.length
    
    );
  }
  
  _cargarUSuarios() async{
    // monitor network fetch
    //await Future.delayed (const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    usuarios = await usuarioService.getUsuarios();
  
    _refreshController.refreshCompleted();

    setState(() {});

  }
}

class _UsuarioListTile extends StatelessWidget {
  
  final Usuario usuario;
  
  const _UsuarioListTile({
    Key? key,
    required this.usuario,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(backgroundColor: Colors.blue[100],child: Text(usuario.nombre.substring(0,2)),),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100)
          ),
        ),
      onTap: () {
        //Instanciar el service. listen el false sino no cambia de pagina
        final chatService = Provider.of<ChatService>(context,listen: false);
        //Asignar el usuario al que estamos seleccionado
        chatService.usuarioPara = usuario;

        Navigator.pushNamed(context, 'chat');
        
      },  
    );
  }
}