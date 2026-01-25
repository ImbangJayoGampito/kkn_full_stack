import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:client/widgets/search.dart';
import 'package:client/providers/settings_provider.dart';
import 'package:client/widgets/toggles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<SearchItem> allItems;
  late List<SearchItem> filteredItems;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    allItems = [
      SearchItem(
        widgetBuilder: (context) => TogglePill(
          title: 'Dark Mode',
          value: settings.isDarkMode,
          key: GlobalKey(),
          onChanged: (value) {
            settings.setDarkMode(value);
            // refresh UI
          },
        ),
        textsInside: ['Dark Mode'],
      ),
      SearchItem(
        widgetBuilder: (context) => TogglePill(
          title: 'Notifications',
          value: false,
          key: GlobalKey(),
          onChanged: (value) {
            // refresh UI
          },
        ),
        textsInside: ['Notifications'],
      ),
    ];

    filteredItems = List.from(allItems);
  }

  void filterItems(String query) {
    setState(() {
      searchQuery = query;
      filteredItems = allItems
          .where(
            (item) => item.textsInside.any(
              (text) => text.toLowerCase().contains(query.toLowerCase()),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(child: LocalSearchCard(items: filteredItems)),
    );
  }
}
