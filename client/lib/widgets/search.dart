import 'package:flutter/material.dart';

class SearchItem {
  final List<String> textsInside;
  final GlobalKey key; // preserve state
  final Widget Function(GlobalKey key) widgetBuilder;

  SearchItem({
    required this.textsInside,
    required this.widgetBuilder,
    GlobalKey? key,
  }) : key = key ?? GlobalKey();

  bool filter(String query) {
    return textsInside.any(
      (text) => text.toLowerCase().contains(query.toLowerCase()),
    );
  }

  Widget buildWidget() {
    return widgetBuilder(key); // always build with the same key
  }
}

class SearchCard extends StatefulWidget {
  final List<SearchItem> items;
  const SearchCard({Key? key, required this.items}) : super(key: key);

  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  List<SearchItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => item.filter(query)).toList();
    });
  }

 @override
Widget build(BuildContext context) {
  return Center(
    child: Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 500, // optional: limit max height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Bar
                TextField(
                  onChanged: filterItems,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // List of items
                filteredItems.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: filteredItems
                            .map(
                              (item) => Padding(
                                key: item.key, 
                                padding: const EdgeInsets.only(bottom: 12),
                                child: item.buildWidget(),
                              ),
                            )
                            .toList(),
                      )
                    : Center(
                        child: Text(
                          'No results',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ),

                const SizedBox(height: 20),

                // Back button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali ke Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
