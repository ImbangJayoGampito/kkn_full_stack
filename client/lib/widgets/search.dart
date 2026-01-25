import 'package:flutter/material.dart';
import 'package:client/models/products.dart';
import 'package:client/utils/error_handling.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'package:client/models/page.dart';
import 'package:client/widgets/error.dart';
import 'package:client/widgets/pagination.dart';
import 'dart:async';

class PaginatedSearchCard<T> extends StatefulWidget {
  final T Function(Map<String, dynamic>) fromJsonT;
  final String endpoint;
  final SearchItem Function(T) searchBuilder;

  String token;
  PaginatedSearchCard({
    Key? key,
    required this.fromJsonT,
    required this.endpoint,
    required this.searchBuilder,
    this.token = '',
  }) : super(key: key);
  @override
  _PaginatedSearchCardState<T> createState() => _PaginatedSearchCardState<T>();
}

class _PaginatedSearchCardState<T> extends State<PaginatedSearchCard<T>> {
  Timer? _debounce;
  final Duration _cooldown = const Duration(milliseconds: 500);
  Result<PaginatedResponse<T>, String> _pageResult = Err('No data');
  List<SearchItem> _searchWidgets = [];
  bool isLoading = true;
  String _query = '';
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchSearchQuery();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchPage(int page) async {
    // Cancel any existing timer
    _debounce?.cancel();

    // Start a new timer
    _debounce = Timer(_cooldown, () async {
      setState(() {
        isLoading = true;
      });
      final result = PaginatedResponse.fetch<T>(
        endpoint: widget.endpoint,
        fromJsonT: widget.fromJsonT,
        queryParameters: {'page': page.toString(), 'search': _query},
      );

      // Update state safely
      if (!mounted) return;
      setSearchResult(result: result);
    });
  }

  Future<void> setSearchResult({
    required Future<Result<PaginatedResponse<T>, String>> result,
    bool showToast = true,
  }) async {
    Result<PaginatedResponse<T>, String> productFuture = await result;
    if (productFuture is Ok<PaginatedResponse<T>, String>) {
      setState(() {
        _searchWidgets = productFuture.value.data.map((item) {
          return widget.searchBuilder(item);
        }).toList();
      });
    } else if (productFuture is Err<PaginatedResponse<T>, String>) {
      if (showToast) {
        GFToast.showToast(
          'Error! ${productFuture.error}',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          backgroundColor: GFColors.DANGER,
          textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        );
      }
    }
    setState(() {
      _pageResult = productFuture;
      isLoading = false;
    });
  }

  void setQuery(String query) {
    _query = query;
    _fetchSearchQuery();
  }

  Future<void> _fetchSearchQuery() async {
    // Cancel any existing timer
    _debounce?.cancel();

    // Start a new timer
    _debounce = Timer(_cooldown, () async {
      setState(() {
        isLoading = true;
      });
      final result = PaginatedResponse.fetch<T>(
        endpoint: widget.endpoint,
        fromJsonT: widget.fromJsonT,
        queryParameters: {'search': _query},
      );

      // Update state safely
      if (!mounted) return;
      setSearchResult(result: result);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardContent = [SearchWidget(onUpdate: setQuery)];
    cardContent.add(SizedBox(height: 16));
    if (isLoading) {
      cardContent.add(CircularProgressIndicator());
      cardContent.add(SizedBox(height: 16));
    } else {
      if (_searchWidgets.isEmpty) {
        cardContent.add(Text('No results found'));
      } else if (_pageResult is Ok<PaginatedResponse<T>, String>) {
        final paginatedData =
            (_pageResult as Ok<PaginatedResponse<T>, String>).value;
        cardContent.add(
          Pagination<T>(
            response: paginatedData, // current paginated data
            maxPagesToShow: 5, // optional, defaults to 5
            onPageChanged: (newPage) {
              // this is where ValueChanged<int> is applied
              fetchPage(newPage); // fetch the selected page
            },
          ),
        );
        cardContent.add(ShowResultWidget(items: _searchWidgets));
        cardContent.add(SizedBox(height: 16));
        cardContent.add(
          Pagination<T>(
            response: paginatedData, // current paginated data
            maxPagesToShow: 5, // optional, defaults to 5
            onPageChanged: (newPage) {
              // this is where ValueChanged<int> is applied
              fetchPage(newPage); // fetch the selected page
            },
          ),
        );
      } else if (_pageResult is Err<PaginatedResponse<T>, String>) {
        final error = (_pageResult as Err<PaginatedResponse<T>, String>).error;
        cardContent.add(ErrorView(error: 'Error! $error'));
      }
    }
    cardContent.add(
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Kembali ke Home'),
      ),
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: cardContent),
        ),
      ),
    );
  }
}

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

class LocalSearchCard extends StatefulWidget {
  final List<SearchItem> items;
  const LocalSearchCard({Key? key, required this.items}) : super(key: key);

  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<LocalSearchCard> {
  List<SearchItem> filteredItems = []; // Store filtered items
  final TextEditingController _controller =
      TextEditingController(); // Controller for the search input

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items; // Initialize filtered items with all items
  }

  // This method filters the items based on the query
  void filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.filter(query)) // Filter the items
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search input
              SearchWidget(onUpdate: (query) => filterItems(query)),

              const SizedBox(height: 12),

              // List of items
              ShowResultWidget(items: filteredItems),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowResultWidget extends StatelessWidget {
  final List<SearchItem> items;
  const ShowResultWidget({Key? key, required this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return items.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: items
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
  }
}

class SearchWidget extends StatefulWidget {
  final void Function(String) onUpdate;
  const SearchWidget({Key? key, required this.onUpdate}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String query = '';
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void handleQueryChange(String query) {
    setState(() {
      this.query = query; // Update the query state
    });

    widget.onUpdate(query); // Notify the parent with the updated query
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Theme.of(context).colorScheme.surfaceVariant,
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                    controller: _controller,
                    onChanged: handleQueryChange,
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
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.5),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
