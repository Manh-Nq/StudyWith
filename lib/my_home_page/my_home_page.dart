import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IO.Socket socket;

  @override
  void initState() {
    initSocket();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                socket.emit(
                  "position-change",
                  jsonEncode(
                    {"test": "hello"},
                  ),
                );
              },
              child: Text("send"))
        ],
      ),
    );
  }

  void initSocket() {
    try {
      socket = IO.io(
        "http://192.168.2.11:3000",
        // "http://127.0.0.1:3000",
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
        },
      );
      socket.connect();
      socket.on("position-change", (data) {
        print("data from server: $data");
      });
      socket.onConnect((data) {
        print("onConnect: ${socket.id}");
      });
      socket.onConnectError((err) {});
    } catch (e) {
      print(e);
    }
  }
}
