
import 'dart:io';

class Enviroment{
    static String apiUrl    = Platform.isAndroid ? 'http://172.16.2.46:3001/api' : 'http://localhost:3001/api';
    static String socketUrl = Platform.isAndroid ? 'http://172.16.2.46:3001' : 'http://localhost:3001';

}