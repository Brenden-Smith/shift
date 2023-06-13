import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shift/components/NewShiftDialog.dart';
import 'package:shift/components/NewUserDialog.dart';
import 'package:shift/components/SadError.dart';
import 'package:shift/layout.dart';
import 'package:shift/providers/company.dart';
import 'package:intl/intl.dart';
import 'package:shift/providers/user.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class OverlappingAvatars extends StatelessWidget {
  const OverlappingAvatars({
    Key? key,
    required this.avatars,
    this.overlap = 16.0,
  }) : super(key: key);

  final List<Widget> avatars;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40 * avatars.length.toDouble() - overlap * (avatars.length - 1),
      child: Stack(
        children: [
          for (int i = 0; i < avatars.length; i++)
            Positioned(
              left: i * overlap,
              child: avatars[i],
            ),
        ],
      ),
    );
  }
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Layout(
        floatingActionButton: Consumer<UserDataProvider>(
          builder: (context, userData, child) =>
              userData.userData?["role"] == "admin"
                  ? FloatingActionButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => const NewShiftDialog(),
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
        bottomAppBar: TabBar(
          // Background color
          labelColor: Theme.of(context).secondaryHeaderColor,
          tabs: const [
            Tab(icon: Icon(Icons.list)),
            Tab(icon: Icon(Icons.calendar_today)),
          ],
        ),
        body: Consumer<CompanyDataProvider>(
          builder: (context, companyData, child) {
            final shiftsStream = FirebaseFirestore.instance
                .collection("companies")
                .doc(companyData.id)
                .collection("shifts")
                .orderBy("start")
                .snapshots();

            return StreamBuilder(
              stream: shiftsStream,
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
                return TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final document = snapshot.data!.docs[index];
                        final DateTime date = document["start"].toDate();
                        final unit = document["unit"];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0 ||
                                document["start"].toDate().day !=
                                    snapshot.data!.docs[index - 1]["start"]
                                        .toDate()
                                        .day) ...[
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  "${DateFormat.MMMM().format(date)} ${date.day}, ${date.year}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                            ListTile(
                              title: Text(unit),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // MM-DD-YYYY HH:MM - MM-DD-YYYY HH:MM
                                    "${DateFormat.MMMd().add_jm().format(document["start"].toDate())} - ${DateFormat.MMMd().add_jm().format(document["end"].toDate())}",
                                  ),
                                  const Text("Need 1 paramedic and 1 EMT",
                                      style: TextStyle(
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                              // Trailing CircleAvatar group where each avatar slightly overlaps the next
                              trailing: OverlappingAvatars(
                                avatars: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: const Text("1"),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: const Text("1"),
                                  ),
                                ],
                                overlap: 16.0,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const Center(child: Text("Calendar")),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
