import 'package:flutter/material.dart';
import 'package:webapp/widgets/floating_notification_widget.dart';

class FloatingOverlayService {
  // Singleton pattern instance
  static final FloatingOverlayService instance =
      FloatingOverlayService._internal();
  FloatingOverlayService._internal();

  OverlayEntry? _overlayEntry;
  final ValueNotifier<int> badgeCountNotifier = ValueNotifier<int>(0);
  bool _isVisible = false;

  /// Whether the floating widget is currently displayed
  bool get isVisible => _isVisible && _overlayEntry != null;

  /// Shows the floating notification widget on the current screen overlay.
  /// Needs a valid [BuildContext] to access the Overlay.
  void show(BuildContext context, {void Function(BuildContext context)? onTap}) {
    if (_overlayEntry != null) {
      // Already shown, do not create duplicate entries
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return FloatingNotificationWidget(
          badgeCountNotifier: badgeCountNotifier,
          onTap: onTap,
        );
      },
    );

    try {
      Overlay.of(context).insert(_overlayEntry!);
      _isVisible = true;
    } catch (e) {
      debugPrint('Error inserting Floating Overlay Entry: $e');
      _overlayEntry = null;
    }
  }

  /// Removes and completely destroys the floating notification widget overlay.
  void remove() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }

  /// Hides the floating widget overlay temporarily (removes it from tree).
  void hide() {
    remove();
  }

  /// Updates the unread count badge on the floating notification widget dynamically.
  void updateBadgeCount(int count) {
    badgeCountNotifier.value = count;
  }
}
