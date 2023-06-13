import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shift/components/NewUserDialog.dart';
import 'package:shift/components/SadError.dart';
import 'package:shift/layout.dart';
import 'package:shift/providers/user.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .orderBy("displayName")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Layout(
        floatingActionButton: Consumer<UserDataProvider>(
          builder: (context, userData, child) =>
              userData.userData?["role"] == "admin"
                  ? FloatingActionButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => const NewUserDialog(),
                        );
                      },
                      backgroundColor: Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor,
                      child: Icon(Icons.add,
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .foregroundColor),
                    )
                  : Container(),
        ),
        body: StreamBuilder(
            stream: _usersStream,
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
              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['displayName']),
                  subtitle: Text(data['email']),
                  enabled: true,
                  enableFeedback: true,
                  onTap: () {
                    print(data);
                  },
                  leading: CircleAvatar(
                    backgroundImage: data["photoURL"] != null
                        ? NetworkImage(data["photoURL"])
                        : null,
                    child: data["photoURL"] != null
                        ? null
                        : const Icon(Icons.person),
                  ),
                  trailing: data["role"] == "admin"
                      ? CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.yellow.shade600,
                          child: const Icon(Icons.star, color: Colors.white),
                        )
                      : null,
                );
              }).toList());
            }));
  }
}
