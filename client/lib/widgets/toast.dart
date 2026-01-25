import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showCustomToast({
  required BuildContext context,
  required ToastificationType type,
  required String title,
  required String message,
  Alignment alignment = Alignment.topCenter,
  Duration duration = const Duration(seconds: 4),
  ToastificationStyle style = ToastificationStyle.flatColored,
}) {
  // Map ToastType to ToastificationType and icon color
  final toastType = type == ToastificationType.success
      ? ToastificationType.success
      : type == ToastificationType.error
      ? ToastificationType.error
      : type == ToastificationType.warning
      ? ToastificationType.warning
      : ToastificationType.info;

  final iconColor = type == ToastificationType.success
      ? Colors.green
      : type == ToastificationType.error
      ? Colors.red
      : type == ToastificationType.warning
      ? Colors.orange
      : Colors.blue;

  final toastification = Toastification();
  final colorScheme = Theme.of(context).colorScheme;
  toastification.show(
    context: context,
    type: toastType,
    style: style,
    alignment: alignment,
    autoCloseDuration: duration,
    title: Row(
      children: [
        Icon(
          toastType == ToastificationType.success
              ? Icons.check_circle
              : toastType == ToastificationType.error
              ? Icons.error
              : toastType == ToastificationType.warning
              ? Icons.warning
              : Icons.info,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    ),
    description: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
      ),
      child: SelectableText(
        message,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.4,
          color: colorScheme.onSurfaceVariant.withOpacity(0.85),
        ),
      ),
    ),
    closeButtonShowType: CloseButtonShowType.always,
    closeButton: ToastCloseButton(
      showType: CloseButtonShowType.onHover,
      buttonBuilder: (context, onClose) {
        return OutlinedButton.icon(
          onPressed: onClose,
          icon: const Icon(Icons.close, size: 20),
          label: const Text('Close'),
        );
      },
    ),
  );
}
