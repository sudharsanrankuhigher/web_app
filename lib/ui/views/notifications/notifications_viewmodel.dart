import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/services/notification_service.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';

class NotificationsViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  NotificationsViewModel() {
    NotificationService.instance.addListener(notifyListeners);
  }

  Future<void> fetchNotifications() async {
    setBusy(true);
    await NotificationService.instance.fetchNotifications();
    setBusy(false);
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    NotificationService.instance.removeListener(notifyListeners);
    super.dispose();
  }

  // Navigation state between Inbox and Send Broadcast form
  String _activeSection = 'inbox'; // 'inbox', 'send'
  String get activeSection => _activeSection;

  void setActiveSection(String section) {
    _activeSection = section;
    if (_activeSection == 'send') {
      fetchTargetOptions();
    }
    notifyListeners();
  }

  // Inbox Filter State
  String _currentFilter = 'all'; // 'all', 'unread', 'read'
  String get currentFilter => _currentFilter;

  List<NotificationItem> get notifications =>
      NotificationService.instance.notifications;

  List<NotificationItem> get filteredNotifications {
    final list = NotificationService.instance.notifications;
    if (_currentFilter == 'unread') {
      return list.where((n) => !n.isRead).toList();
    } else if (_currentFilter == 'read') {
      return list.where((n) => n.isRead).toList();
    }
    return list;
  }

  int get unreadCount => NotificationService.instance.unreadCount;

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Inbox Actions
  Future<void> markAsRead(String id) async {
    await NotificationService.instance.markAsRead(id);
  }

  Future<void> toggleReadState(String id) async {
    await NotificationService.instance.toggleReadState(id);
  }

  Future<void> markAllAsRead() async {
    await NotificationService.instance.markAllAsRead();
  }

  Future<void> deleteNotification(String id) async {
    await NotificationService.instance.deleteNotification(id);
  }

  // Compose Broadcast Form State
  String _formCategory = 'info'; // 'info', 'success', 'warning', 'alert'
  String _formTargetAudience =
      'Users'; // 'Users', 'Influencers', 'Admin / Sub Admin'

  // Broadcast Type and targeting options
  String _broadcastType = 'all'; // 'all', 'separately'
  String get broadcastType => _broadcastType;

  bool _isLoadingTargetOptions = false;
  bool get isLoadingTargetOptions => _isLoadingTargetOptions;

  List<dynamic> _usersList = [];
  List<dynamic> _influencersList = [];
  List<dynamic> _subAdminsList = [];

  List<dynamic> _selectedTargets = [];
  List<dynamic> get selectedTargets => _selectedTargets;

  void setBroadcastType(String value) {
    _broadcastType = value;
    notifyListeners();
  }

  void clearSelectedTargets() {
    _selectedTargets.clear();
    notifyListeners();
  }

  void setSelectedTargets(List<dynamic> selected) {
    _selectedTargets = selected;
    notifyListeners();
  }

  void toggleTargetSelection(dynamic item) {
    final index = _selectedTargets.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      _selectedTargets.removeAt(index);
    } else {
      _selectedTargets.add(item);
    }
    notifyListeners();
  }

  List<dynamic> get targetOptions {
    if (_formTargetAudience == 'Users') {
      return _usersList
          .map((user) => {
                'id': user.id,
                'name': user.name ?? '',
                'image': '',
              })
          .toList();
    } else if (_formTargetAudience == 'Influencers') {
      return _influencersList
          .map((influencer) => {
                'id': influencer.id,
                'name': influencer.name ?? '',
                'image': influencer.image ?? '',
              })
          .toList();
    } else if (_formTargetAudience == 'Admin / Sub Admin') {
      return _subAdminsList
          .map((subAdmin) => {
                'id': subAdmin.id,
                'name': subAdmin.name ?? '',
                'image': subAdmin.profileImage ?? '',
              })
          .toList();
    }
    return [];
  }

  Future<void> fetchTargetOptions() async {
    _isLoadingTargetOptions = true;
    notifyListeners();

    // Fetch users
    try {
      final now = DateTime.now();
      final formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}";
      final res =
          await locator<ApiService>().getUsers({"month": formattedDate});
      _usersList = res.data ?? [];
    } catch (e) {
      _usersList = [];
      debugPrint('Error fetching users: $e');
    }

    // Fetch influencers
    try {
      final res = await locator<ApiService>().getAllInfluencer();
      _influencersList = res.data ?? [];
    } catch (e) {
      _influencersList = [];
      debugPrint('Error fetching influencers: $e');
    }

    // Fetch sub-admins
    try {
      final res = await locator<ApiService>().getAllSubAdmin();
      _subAdminsList = res;
    } catch (e) {
      _subAdminsList = [];
      debugPrint('Error fetching sub admins: $e');
    }

    _isLoadingTargetOptions = false;
    notifyListeners();
  }

  // Scheduling State
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  DateTime? _scheduledDate;
  DateTime? get scheduledDate => _scheduledDate;

  TimeOfDay? _scheduledTime;
  TimeOfDay? get scheduledTime => _scheduledTime;

  String get formTitle => titleController.text;
  String get formMessage => messageController.text;
  String get formCategory => _formCategory;
  String get formTargetAudience => _formTargetAudience;

  void setFormCategory(String value) {
    _formCategory = value;
    notifyListeners();
  }

  void setFormTargetAudience(String value) {
    _formTargetAudience = value;
    _selectedTargets.clear(); // Reset selections when audience group changes
    notifyListeners();
  }

  void toggleScheduled(bool value) {
    _isScheduled = value;
    if (!_isScheduled) {
      _scheduledDate = null;
      _scheduledTime = null;
    }
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5), // continueButton color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _scheduledDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _scheduledTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _scheduledTime = picked;
      notifyListeners();
    }
  }

  void clearSchedule() {
    _scheduledDate = null;
    _scheduledTime = null;
    _isScheduled = false;
    notifyListeners();
  }

  DateTime? get combinedScheduledDateTime {
    if (!_isScheduled || _scheduledDate == null || _scheduledTime == null) {
      return null;
    }
    return DateTime(
      _scheduledDate!.year,
      _scheduledDate!.month,
      _scheduledDate!.day,
      _scheduledTime!.hour,
      _scheduledTime!.minute,
    );
  }

  // Get generated Request Body Map (with isRead: false)
  Map<String, dynamic> get lastGeneratedRequestBody {
    final datetime = combinedScheduledDateTime;
    return {
      'title': formTitle.trim(),
      'message': formMessage.trim(),
      'category': _formCategory,
      'targetAudience': _formTargetAudience,
      'broadcastType': _broadcastType,
      if (_broadcastType == 'separately')
        'selectedTargets': _selectedTargets
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList(),
      'isRead': false,
      if (datetime != null) 'scheduledAt': datetime.toIso8601String(),
    };
  }

  // Submit Compose Form
  void sendBroadcast() {
    if (formTitle.trim().isEmpty || formMessage.trim().isEmpty) return;

    // Output Request Body in developer logs
    debugPrint('Generated Request Body: $lastGeneratedRequestBody');

    NotificationService.instance.sendManualNotification(
      title: formTitle.trim(),
      message: formMessage.trim(),
      category: _formCategory,
      targetAudience: _formTargetAudience,
      customTimestamp: combinedScheduledDateTime,
    );

    // Reset composer state
    formKey.currentState?.reset();
    titleController.clear();
    messageController.clear();
    _formCategory = 'info';
    _formTargetAudience = 'Users';
    _broadcastType = 'all';
    _selectedTargets.clear();
    _isScheduled = false;
    _scheduledDate = null;
    _scheduledTime = null;
    _activeSection =
        'inbox'; // Back to inbox to see the sent notification at top!

    notifyListeners();
  }
}
