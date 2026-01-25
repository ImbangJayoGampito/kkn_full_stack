import 'package:flutter/material.dart';
import 'package:client/models/page.dart';

class Pagination<T> extends StatelessWidget {
  final PaginatedResponse<T> response;
  final ValueChanged<int> onPageChanged;
  final int maxPagesToShow;

  const Pagination({
    Key? key,
    required this.response,
    required this.onPageChanged,
    this.maxPagesToShow = 5, // Number of page buttons to show
  }) : super(key: key);

  List<Widget> _buildPageButtons(int currentPage, int totalPages) {
    List<Widget> buttons = [];

    int startPage = 1;
    int endPage = totalPages;

    if (totalPages > maxPagesToShow) {
      // Ensure current page is centered when possible
      int middle = (maxPagesToShow / 2).floor();
      startPage = currentPage - middle;
      endPage = currentPage + middle;

      if (startPage < 1) {
        startPage = 1;
        endPage = maxPagesToShow;
      }

      if (endPage > totalPages) {
        endPage = totalPages;
        startPage = totalPages - maxPagesToShow + 1;
      }
    }

    if (startPage > 1) {
      buttons.add(_pageButton(1, currentPage));
      if (startPage > 2) {
        buttons.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('…'),
          ),
        );
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      buttons.add(_pageButton(i, currentPage));
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        buttons.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('…'),
          ),
        );
      }
      buttons.add(_pageButton(totalPages, currentPage));
    }

    return buttons;
  }

  Widget _pageButton(int page, int currentPage) {
    final bool isCurrent = page == currentPage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isCurrent ? Colors.blue : Colors.grey[200],
          foregroundColor: isCurrent ? Colors.white : Colors.black,
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
        ),
        onPressed: isCurrent ? null : () => onPageChanged(page),
        child: Text(page.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int currentPage = response.currentPage;
    final int totalPages = response.lastPage;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        ..._buildPageButtons(currentPage, totalPages),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
