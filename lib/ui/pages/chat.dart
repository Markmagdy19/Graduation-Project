import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../widgets/Chat_messages.dart';
import '../../widgets/new_messages.dart';


class Gpchat extends StatelessWidget {
  const Gpchat({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title:  Text(S.of(context).Hospital_Group),
          actions: [
            IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
            },
              icon: const Icon(Icons.exit_to_app),

              color: Theme.of(context).colorScheme.primary,
            ),

          ],
        ),
        body:const Column(
          children: [

            Expanded(child: chatMessages(),
            ),
            NewMessage(),
          ],
        ));

  }




}