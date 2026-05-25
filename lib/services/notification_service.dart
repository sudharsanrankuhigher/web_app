import 'package:flutter/material.dart';

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

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New Client Request Approved',
      message:
          'Influencer marketing proposal for "FitLife Campaign" has been successfully approved by the client.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      category: 'success',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Subscription Expiring Soon',
      message:
          'Company "GlobalTech Solutions" premium subscription plan is expiring in 3 days. Send renewal reminder.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'warning',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Failed Payout Alert',
      message:
          'Monthly payout transaction of \$1,250.00 failed for top influencer "@creative_mind". Retrying.',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      category: 'alert',
      isRead: false,
    ),
    NotificationItem(
      id: '4',
      title: 'System Maintenance Scheduled',
      message:
          'Platform updates and server optimization will take place on Sunday at 02:00 AM. Expect brief downtime.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: 'info',
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Campaign Milestones Achieved',
      message:
          'Promote Project "Summer Launch 2026" achieved its target of 500,000 views today.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      category: 'success',
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'New Ticket Support Request',
      message:
          'Influencer "@tech_geek" has submitted a critical ticket regarding payment processor delay.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      category: 'warning',
      isRead: true,
    ),
    NotificationItem(
      id: '7',
      title: 'Security System Updated',
      message:
          'Role permissions policies and firewalls were updated to standard security compliance V3.',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      category: 'info',
      isRead: true,
    ),
  ];

  List<NotificationItem> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void toggleReadState(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = !_notifications[index].isRead;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    bool updated = false;
    for (var n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        updated = true;
      }
    }
    if (updated) {
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
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
}
