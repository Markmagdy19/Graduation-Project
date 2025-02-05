import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/apis.dart';
import '../generated/l10n.dart';
import '../helper/dialogs.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../ui/pages/chat.dart';
import '../widgets/chat_user_card.dart';


//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: FocusScope.of(context).unfocus,
      child: WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: S.of(context).Name_Email),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              //when search text changes then updated search list
              onChanged: (val) {
                //search logic
                _searchList.clear();

                for (var i in _list) {
                  if (i.name
                      .toString()
                      .toLowerCase()
                      .contains(val.toLowerCase()) ||
                      i.email
                          .toString()
                          .toLowerCase()
                          .contains(val.toLowerCase())) {
                    _searchList.add(i);
                    setState(() {
                      _searchList;
                    });
                  }
                }
              },
            )
                : Text(S.of(context).Hospital_Chat),
            actions: [
              //search user button
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),

              //more features button

            ],
          ),

          //floating buttons
          floatingActionButton: Stack(
            children: <Widget>[
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    _addChatUserDialog();
                  },
                  child: const Icon(Icons.add_comment_rounded),
                ),
              ),
              Positioned(
                bottom: 80.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Gpchat()));
                  },
                  child: Image.asset("images/4977982.png"),
                ),
              ),
            ],
          ),

          //body
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),
            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

              //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return FutureBuilder<
                      List<
                          Map<String, DocumentSnapshot<Map<String, dynamic>>>>>(
                    future: APIs.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _list = snapshot.data
                            ?.map((e) =>
                            ChatUser.fromJson(e[e.keys.first]!.data()!))
                            .toList() ??
                            [];
                        print(snapshot.data!.length);
                        if (snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _isSearching
                                  ? _searchList.length
                                  : _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (!_isSearching) {
                                  _list[index].id =
                                      snapshot.data![index].keys.first;
                                }
                                if (_isSearching) {
                                  _searchList[index].id =
                                      snapshot.data![index].keys.first;
                                }
                                return ChatUserCard(
                                    user: _isSearching
                                        ? _searchList[index]
                                        : _list[index]);
                              });
                        } else {
                          return Center(
                            child: Text(S.of(context).No_Connections_Found,
                                style: const TextStyle(fontSize: 20)),
                          );
                        }
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString(),
                              style: const TextStyle(fontSize: 20)),
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          //title
          title: Row(
            children: [
              const Icon(
                Icons.person_add,
                color: Colors.blue,
                size: 28,
              ),
              Text(S.of(context).Add_User)
            ],
          ),
          //content
          content: TextFormField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
                hintText: S.of(context).Email_Id,
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                },
                child: Text(S.of(context).Cancel,
                    style: const TextStyle(color: Colors.blue, fontSize: 16))),
            //add button
            MaterialButton(
                onPressed: () async {
                  //hide alert dialog
                  Navigator.pop(context);
                  if (email.isNotEmpty) {
                    await APIs.addChatUser(email).then((value) {
                      if (!value) {
                        Dialogs.showSnackbar(
                            context, S.of(context).User_not_exist);
                      }
                    });
                  }
                },
                child: Text(
                  S.of(context).Add,
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}
