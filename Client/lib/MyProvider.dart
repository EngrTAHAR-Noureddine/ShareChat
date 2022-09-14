// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Message{
  String from;
  String message;

  Message({required this.from , required this.message});
}

class MyProvider with ChangeNotifier{
  static final MyProvider _singleton = MyProvider._internal();

  factory MyProvider() {
    return _singleton;
  }

  MyProvider._internal();


  final textSenderController = TextEditingController();
  bool? asServer = false;
  ServerSocket? server;
  Socket? remoteServer;
  Socket? client;
  String ipv4 = "";
  List<Message> listWords =[];
  String address = "localhost";

  getAddress()async{
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print('${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');

        if(addr.type.name == "IPv4") address = addr.address;
      }
    }
  }

  // Server with Dart Socket
  Future<void> createServer()async{
    await getAddress();
    server = await ServerSocket.bind(address, 4567);
    if (server!=null){
      print("server created ; IP : ${server!.address}:${server!.port} ");
      listenToClient();
    }

  }

  void listenToClient(){
    server?.listen((newClient) {
      remoteServer = newClient;
      handleConnection();
    });
  }

  void handleConnection() {
    print('Connection from ${remoteServer?.remoteAddress.address}:${remoteServer?.remotePort}');

    // listen for events from the client
    remoteServer?.listen(

      // handle data from the client
    (Uint8List data) async {
        listWords.add(Message(from: "${remoteServer?.remoteAddress.address}:${remoteServer?.remotePort}", message: String.fromCharCodes(data)));
        notifyListeners();
        // if (message == 'Knock, knock.') {
        //   client.write('Who is there?');
        // } else if (message.length < 10) {
        //   client.write('$message who?');
        // } else {
        //   client.write('Very funny.');
        //   client.close();
        // }
      },

      // handle errors
      onError: (error) {
        print(error);
        remoteServer?.close();
      },

      // handle the client closing the connection
      onDone: () {
        print('Client left');
        remoteServer?.close();
      },
    );
  }

  Future<void> createClient()async{
    await getAddress();
    client = await Socket.connect('192.168.1.47', 4567);
    print('Connected to: ${client?.remoteAddress.address}:${client?.remotePort}');
    listenToRemoteServer();
    // remoteServer = IO.io('http://localhost:8080', <String, dynamic>{
    //   //"transports": ["websocket"],
    //   "autoConnect": false,
    // });
    // remoteServer?.connect();
    // print("socket is connected : ${remoteServer?.connected}");
    //remoteServer?.on('fromServer', (data) => print("from Server : $data"));

  }

  void sendData(){
    print("Send Data : ${textSenderController.text}");

    remoteServer?.write("send :  ${textSenderController.text}");
    client?.write("send :  ${textSenderController.text}");

    textSenderController.clear();
    notifyListeners();
  }

  void listenToRemoteServer(){
    client?.listen(

      // handle data from the server
     (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        print('Server: $serverResponse');
        listWords.add(Message(from: "Server :${client?.remoteAddress.address}:${client?.remotePort}", message: serverResponse));
        notifyListeners();
      },

      // handle errors
      onError: (error) {
        print(error);
        client?.destroy();
      },

      // handle server ending connection
      onDone: () {
        print('Server left.');
        client?.destroy();
      },
    );
  }


  // void changeToServer(bool? value)async{
  //     print("value : $value");
  //     asServer = value;
  //
  //     if(asServer == true){
  //       remoteServer?.close();
  //       createServer();
  //     }else{
  //      await  createRemoteServer();
  //       server?.close();
  //     }
  //
  //     notifyListeners();
  // }
  //
  // void sendData(){
  //
  //
  //   print("Send Data : ${textSenderController.text}");
  //   client?.write('Send : ${textSenderController.text}');
  //   remoteServer?.write('Send : ${textSenderController.text}');
  //   notifyListeners();
  // }


}