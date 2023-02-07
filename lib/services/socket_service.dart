import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting
}


class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get getSeverStatus => _serverStatus;
  IO.Socket get getSocket => _socket;

  /*
  //Esto se ejecuta cuando se esta creando una instancia. Esto no nos sirve porque la
    primera instancia esta en el main por el Provider. Lo que queremos es que se conecte
    hasta que pase el login.

  SocketService(){
      _initConfig();
  }

  void _initConfig(){*/
  //Es async para que espere a la validación del token por parte del servidor.
  void connect() async{
    
    //Obtener el token del storage
    final token = await AuthService.getToken();

    // Dart client
    //_socket = IO.io('http://172.16.2.46:3001/',{
    _socket = IO.io(Enviroment.socketUrl,{
      'transports' : ['websocket'], //Define el tipo de comunicación con el server
      'autoConnect': true, // para que se conecte de forma automatica. Si fuera false, se usuaría el comando sockect.onConnect()
      'forceNew' : true,    /* 
                              Como vamos autenticar nuestra comunicación con sockets, es importante esta porpiedad.
                              Consume mas recursos del backend porque cuando un cliente se desconecta y después
                              se vuelve a conectar crea una nueva instancia (sesión), es mas por la validación del
                              token.
                           */
      'extraHeaders':{ // Los extraHeaders reciben un mapa en el cual se pueden mandar cualquier cantidad de headers
                       'x-token': token
                     }     
    });

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   //print('******nuevo-mensaje*****: $payload');
    //   print('Cliente: '+ payload['cliente'] ?? 'No definido');
    //   print('Mensaje: '+ payload['mensaje'] ?? 'No definido');
    // });


  }

  void disconnect (){
    _socket.disconnect();
  }
  

}