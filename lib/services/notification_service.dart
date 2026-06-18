import 'package:flutter/material.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String category; // 'info', 'success', 'warning', 'alert'
  final String? targetAudience; // 'Users', 'Influencers', 'Admin / Sub Admin'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.category,
    this.targetAudience,
    this.isRead = false,
  });
}

class NotificationService extends ChangeNotifier {
  static final NotificationService instance = NotificationService._internal();

  NotificationService._internal();

  final List<NotificationItem> _notifications = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final data = await locator<ApiService>().getNotificationList();
      if (data != null && data['notification_list'] != null) {
        final List<dynamic> list = data['notification_list'];
        _notifications.clear();
        for (var item in list) {
          _notifications.add(
            NotificationItem(
              id: item['id']?.toString() ?? '',
              title: item['title'] ?? '',
              message: item['message'] ?? '',
              timestamp: item['created_at'] != null
                  ? DateTime.tryParse(item['created_at'].toString()) ??
                      DateTime.now()
                  : DateTime.now(),
              category: item['category'] ?? 'info',
              isRead: (item['admin_status'] ?? 0) !=
                  0, // status: 0 is unread, others are read
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching notifications from backend: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<NotificationItem> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final wasRead = _notifications[index].isRead;
    if (wasRead) return;

    // Optimistically update locally
    _notifications[index].isRead = true;
    notifyListeners();

    try {
      final intId = int.tryParse(id);
      if (intId != null) {
        await locator<ApiService>().readNotification(intId);
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      // Rollback on error
      final rollbackIndex = _notifications.indexWhere((n) => n.id == id);
      if (rollbackIndex != -1) {
        _notifications[rollbackIndex].isRead = wasRead;
        notifyListeners();
      }
    }
  }

  Future<void> toggleReadState(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final wasRead = _notifications[index].isRead;
    final targetRead = !wasRead;

    // Optimistically update locally
    _notifications[index].isRead = targetRead;
    notifyListeners();

    try {
      final intId = int.tryParse(id);
      if (intId != null) {
        if (targetRead) {
          await locator<ApiService>().readNotification(intId);
        } else {
          await locator<ApiService>().readNotification(intId);
          // Backend doesn't support unread API, but we keep the local state change.
          // We can optionally call an endpoint or just log.
          debugPrint(
              'Backend does not support unreading. Local toggle updated.');
        }
      }
    } catch (e) {
      debugPrint('Error toggling notification read state: $e');
      // Rollback on error
      final rollbackIndex = _notifications.indexWhere((n) => n.id == id);
      if (rollbackIndex != -1) {
        _notifications[rollbackIndex].isRead = wasRead;
        notifyListeners();
      }
    }
  }

  Future<void> markAllAsRead() async {
    final List<String> unreadIds =
        _notifications.where((n) => !n.isRead).map((n) => n.id).toList();

    if (unreadIds.isEmpty) return;

    // Optimistically update all to read
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();

    try {
      await locator<ApiService>().readAllNotifications();
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      // Rollback on error
      for (var n in _notifications) {
        if (unreadIds.contains(n.id)) {
          n.isRead = false;
        }
      }
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final removedItem = _notifications[index];
    final removedIndex = index;

    // Optimistically delete locally
    _notifications.removeAt(index);
    notifyListeners();

    try {
      final intId = int.tryParse(id);
      if (intId != null) {
        await locator<ApiService>().deleteNotification(intId);
      }
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      // Rollback on error
      _notifications.insert(removedIndex, removedItem);
      notifyListeners();
    }
  }

  void sendManualNotification({
    required String title,
    required String message,
    required String category,
    required String targetAudience,
    DateTime? customTimestamp,
  }) {
    final newItem = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: customTimestamp ?? DateTime.now(),
      category: category,
      targetAudience: targetAudience,
      isRead: false,
    );
    _notifications.insert(0, newItem);
    notifyListeners();
  }

  void clear() {
    _notifications.clear();
    _isLoading = false;
    notifyListeners();
  }
}
