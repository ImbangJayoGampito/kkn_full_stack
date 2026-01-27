import 'package:flutter/material.dart';
import 'package:client/models/page.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/getwidget.dart';

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
  void parsePage(String value, BuildContext context, int totalPages) {
    try {
      int newPage = int.parse(value);
      if (newPage > 0 && newPage <= totalPages) {
        onPageChanged(newPage);
      } else {
        GFToast.showToast(
          'Halaman tidak valid', // Combine title + message
          context,
          toastPosition: GFToastPosition
              .BOTTOM, // GFToast uses toastPosition, not Alignment
          toastDuration: 6, // Set duration to 6 seconds
          backgroundColor: GFColors.DANGER, // Red for error
          textStyle: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
        );
      }
    } catch (e) {
      GFToast.showToast(
        'Input tidak valid! Pastikan hanya nomor yang diinputkan!',
        context,
        toastPosition:
            GFToastPosition.BOTTOM, // GFToast uses toastPosition, not Alignment
        toastDuration: 6, // Set duration to 6 seconds
        backgroundColor: GFColors.DANGER, // Red for error
        textStyle: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
      );
    }
  }

  List<Widget> _buildPageButtons(
    int currentPage,
    int totalPages,
    BuildContext context,
  ) {
    List<Widget> buttons = [];

    int startPage = 1;
    int endPage = totalPages;

    if (totalPages > maxPagesToShow) {
      // Ensure current page is centered
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 40,
              child: EditableInlineText(
                placeholder: '…',
                onSave: (value) {
                  parsePage(value, context, totalPages);
                },
              ),
            ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 40,
              child: EditableInlineText(
                placeholder: '…',
                onSave: (value) {
                  parsePage(value, context, totalPages);
                },
              ),
            ),
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
          minimumSize: const Size(50, 50),
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
    final int totalPages = response.totalPages;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        ..._buildPageButtons(currentPage, totalPages, context),
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

class EditableInlineText extends StatefulWidget {
  final String placeholder;
  final Function(String) onSave;

  const EditableInlineText({
    Key? key,
    required this.placeholder,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditableInlineText> createState() => _EditableInlineTextState();
}

class _EditableInlineTextState extends State<EditableInlineText> {
  bool isEditing = false;
  String _text = '';

  final TextEditingController controller = TextEditingController(text: '');
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        // user left the TextField
        setState(() => isEditing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isEditing = true);
      },
      child: isEditing
          ? TextField(
              focusNode: focusNode,
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.done, // shows Enter/Done
              onSubmitted: (value) {
                setState(() => isEditing = false);

                widget.onSave(controller.text);
                controller.text = '';
              },
            )
          : Center(
              child: Text(
                widget.placeholder,
                style: const TextStyle(fontSize: 24),
              ),
            ),
    );
  }
}
