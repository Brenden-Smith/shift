import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shift/components/SadError.dart';
import 'package:shift/layout.dart';

class ProfilePage extends StatelessWidget {
  final String id;
  ProfilePage({Key? key, required this.id}) : super(key: key);
  late final _userStream =
      FirebaseFirestore.instance.collection("users").doc(id).snapshots();

  @override
  Widget build(BuildContext context) {
    return Layout(
        isSubPage: true,
        body: StreamBuilder(
            stream: _userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SadError();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    Spacer(flex: 1),
                    Center(child: CircularProgressIndicator()),
                    Spacer(flex: 1)
                  ],
                );
              }

              return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                      child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: snapshot.data
                                              ?.data()?["photoURL"] !=
                                          null
                                      ? NetworkImage(
                                          snapshot.data?.data()?["photoURL"])
                                      : null,
                                  child:
                                      snapshot.data?.data()?["photoURL"] != null
                                          ? null
                                          : const Icon(Icons.person),
                                ),
                                const SizedBox(width: 24),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          snapshot.data?.data()?["displayName"],
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "${snapshot.data?.data()?["medicID"].contains("P") ? "Paramedic" : "EMT"} • ${snapshot.data?.data()?["medicID"]}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.email)),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.phone)),
                                        ],
                                      )
                                    ])
                              ]),
                              const SizedBox(height: 24),
                              const Text("Shifts",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ))));
            }));
  }
}
