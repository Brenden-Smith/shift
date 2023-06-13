import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shift/providers/company.dart';
import 'package:shift/providers/user.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon, this.page);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final String page;
}

const List<Destination> destinations = <Destination>[
  Destination('Home', Icon(Icons.home_outlined), Icon(Icons.home), "/home"),
  Destination('Schedule', Icon(Icons.calendar_today_outlined),
      Icon(Icons.calendar_today), "/schedule"),
  Destination('Team', Icon(Icons.groups_outlined), Icon(Icons.groups), "/team"),
  Destination('Settings', Icon(Icons.settings_outlined), Icon(Icons.settings),
      "/settings"),
];

class Layout extends StatefulWidget {
  const Layout({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.bottomSheet,
    this.bottomAppBar,
  }) : super(key: key);
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final PreferredSizeWidget? bottomAppBar;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late bool showNavigationDrawer;

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    final large = MediaQuery.of(context).size.width >= 450;
    final companyData = Provider.of<CompanyDataProvider>(context).data;
    return AppBar(
      title: Text(companyData?["displayName"] ?? "Shift",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      bottom: widget.bottomAppBar,
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      centerTitle: !large,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              Navigator.of(context).pushNamed("/");
              await FirebaseAuth.instance.signOut();
            },
          ),
        ),
      ],
    );
  }

  Widget buildBottomBarScaffold() {
    final selectedIndex = destinations.indexWhere(
        (element) => element.page == ModalRoute.of(context)!.settings.name);

    return Scaffold(
      appBar: buildAppBar(context),
      bottomSheet: widget.bottomSheet,
      body: SafeArea(
        child: widget.body,
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (int index) {
          Navigator.of(context).pushNamed(destinations[index].page.toString());
        },
        destinations: destinations.map(
          (Destination destination) {
            return NavigationDestination(
              label: destination.label,
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              tooltip: destination.label,
            );
          },
        ).toList(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }

  Widget buildDrawerScaffold(BuildContext context) {
    bool extended = true;
    final selectedIndex = destinations.indexWhere(
        (element) => element.page == ModalRoute.of(context)!.settings.name);
    return Scaffold(
      key: scaffoldKey,
      appBar: buildAppBar(context),
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: NavigationRail(
                  minWidth: 50,
                  extended: extended,
                  destinations: destinations.map(
                    (Destination destination) {
                      return NavigationRailDestination(
                        label: Text(destination.label),
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                      );
                    },
                  ).toList(),
                  selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                  useIndicator: true,
                  onDestinationSelected: (int index) {
                    Navigator.of(context).pushNamed(destinations[index].page);
                  }),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: widget.body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer
        ? buildDrawerScaffold(context)
        : buildBottomBarScaffold();
  }
}
