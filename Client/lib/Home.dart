import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyProvider.dart';

class Home extends StatelessWidget {
   Home({Key? key}) : super(key: key);

   Widget _checkBox(BuildContext context){
     return Container(
       margin: const EdgeInsets.symmetric(horizontal: 20),
       child: Row(
         children: [
           Checkbox(
             checkColor: Colors.white,
             fillColor: MaterialStateProperty.resolveWith(getColor),
             value: context.watch<MyProvider>().asServer,
             onChanged: (bool? value) => print(value)//MyProvider().changeToServer(value),
           ),
           const Text("As Server"),
         ],
       ),
     );
   }
   Widget _writeText(BuildContext context){
     return Expanded(
         flex:1,
         child:Container(
           color: Colors.green,
           padding: const EdgeInsets.all(20),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               TextField(
                 controller: context.read<MyProvider>().textSenderController,
                 decoration: const InputDecoration(
                     labelText: "Message"
                 ),
               ),
               MaterialButton(
                 onPressed: MyProvider().sendData,
                 color: Colors.blue,
                 child: const Text("Send",style: TextStyle(color: Colors.white),),
               )
             ],
           ),
         ));
   }
   Widget _chatField(BuildContext context){
     return Expanded(
         flex:2,
         child: Container(
           color: Colors.red,
           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
           child: ListView.builder(
                itemCount: context.read<MyProvider>().listWords.length,
                 itemBuilder: (ctx, i) => ListTile(
                         leading: const Icon(Icons.person),
                         title: Text("From :${context.read<MyProvider>().listWords[i].from}" ) ,
                         subtitle: Text("Message :${context.read<MyProvider>().listWords[i].message}" ) ,
                 )
             ),
           // child: Selector<MyProvider, List<String>>(
           //   selector: (_, my) => my.listWords,
           //   builder: (_, items, __) => ListView.builder(
           //      itemCount: items.length,
           //       itemBuilder: (ctx, i) => ListTile(
           //               leading: const Icon(Icons.person),
           //               title: Text( items[i] ) ,
           //               )
           //   ),
           // )
         )
         );
   }


  @override
  Widget build(BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("YOUR IP ADRESS : ${MyProvider().address} "),
                    actions: [
                      _checkBox(context)
                    ],
                  ),
                  body:  Row(
                    children: [

                      _writeText(context),
                      _chatField(context)

                    ],
                  ),
                );

  }


   Color getColor(Set<MaterialState> states) {
     const Set<MaterialState> interactiveStates = <MaterialState>{
       MaterialState.pressed,
       MaterialState.hovered,
       MaterialState.focused,
     };
     if (states.any(interactiveStates.contains)) {
       return Colors.blue;
     }
     return Colors.red;
   }
}
