import 'package:client_one/MyProvider.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                  child: const Text("Server"),
                  onPressed: ()async{
                    MyProvider().asServer = true;
                    await MyProvider().createServer();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                  }),
              MaterialButton(
                  child: const Text("Client"),
                  onPressed: ()async{
                    MyProvider().asServer = false;
                    await MyProvider().createClient();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
