import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/services/notification_service.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';

class NotificationTemplate {
  final String id;
  final String title;
  final String message;
  final String category;

  NotificationTemplate({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'category': category,
      };

  factory NotificationTemplate.fromJson(Map<String, dynamic> json) =>
      NotificationTemplate(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        category: json['category'] ?? 'info',
      );
}

class NotificationsViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final templateTitleController = TextEditingController();
  final templateMessageController = TextEditingController();

  List<NotificationTemplate> _templates = [];
  List<NotificationTemplate> get templates => _templates;

  String _templateCategory = 'info';
  String get templateCategory => _templateCategory;

  void setTemplateCategory(String value) {
    _templateCategory = value;
    notifyListeners();
  }

  NotificationTemplate? _selectedTemplate;
  NotificationTemplate? get selectedTemplate => _selectedTemplate;

  void selectTemplate(NotificationTemplate? template) {
    _selectedTemplate = template;
    if (template != null) {
      titleController.text = template.title;
      messageController.text = template.message;
      _formCategory = template.category;
    } else {
      titleController.clear();
      messageController.clear();
      _formCategory = 'info';
    }
    notifyListeners();
  }

  NotificationsViewModel() {
    NotificationService.instance.addListener(notifyListeners);
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    setBusy(true);
    try {
      final res = await locator<ApiService>().getTemplateList();
      List<dynamic> list = [];
      if (res is List) {
        list = res;
      } else if (res is Map) {
        list = res['data'] ?? res['template_list'] ?? res['templates'] ?? [];
      }

      _templates = list.map((item) {
        final String id = (item['id'] ?? '').toString();
        final String title = item['title'] ?? '';
        final String message = item['description'] ?? item['message'] ?? '';
        final String category = item['category'] ?? 'info';
        return NotificationTemplate(
          id: id,
          title: title,
          message: message,
          category: category,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading templates from backend: $e');
      await _loadTemplatesFromPrefs();
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> _loadTemplatesFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? templatesJson = prefs.getString('notification_templates');
      if (templatesJson != null) {
        final List<dynamic> decoded = jsonDecode(templatesJson);
        _templates =
            decoded.map((item) => NotificationTemplate.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading templates from prefs: $e');
    }
  }

  NotificationTemplate? _editingTemplate;
  NotificationTemplate? get editingTemplate => _editingTemplate;
  bool get isEditingTemplate => _editingTemplate != null;

  void startEditingTemplate(NotificationTemplate template) {
    _editingTemplate = template;
    templateTitleController.text = template.title;
    templateMessageController.text = template.message;
    _templateCategory = template.category;
    notifyListeners();
  }

  void cancelEditingTemplate() {
    _editingTemplate = null;
    templateTitleController.clear();
    templateMessageController.clear();
    _templateCategory = 'info';
    notifyListeners();
  }

  Future<void> saveTemplate() async {
    final title = templateTitleController.text.trim();
    final message = templateMessageController.text.trim();
    if (title.isEmpty || message.isEmpty) return;

    setBusy(true);
    try {
      final Map<String, dynamic> requestData = {
        'title': title,
        'description': message,
        'category': _templateCategory,
      };

      if (_editingTemplate != null) {
        requestData['id'] = _editingTemplate!.id;
      }

      final response = await locator<ApiService>().storeTemplate(requestData);

      _editingTemplate = null;
      templateTitleController.clear();
      templateMessageController.clear();
      _templateCategory = 'info';

      // Fetch fresh list from backend
      final res = await locator<ApiService>().getTemplateList();
      List<dynamic> list = [];
      if (res is List) {
        list = res;
      } else if (res is Map) {
        list = res['data'] ?? res['template_list'] ?? res['templates'] ?? [];
      }

      _templates = list.map((item) {
        final String id = (item['id'] ?? '').toString();
        final String title = item['title'] ?? '';
        final String message = item['description'] ?? item['message'] ?? '';
        final String category = item['category'] ?? 'info';
        return NotificationTemplate(
          id: id,
          title: title,
          message: message,
          category: category,
        );
      }).toList();

      await _saveTemplatesToPrefs();
    } catch (e) {
      debugPrint('Error saving template to backend: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> deleteTemplate(String id) async {
    final intId = int.tryParse(id);
    if (intId == null) return;

    setBusy(true);
    try {
      await locator<ApiService>().deleteTemplate(intId);
      _templates.removeWhere((t) => t.id == id);
      if (_selectedTemplate?.id == id) {
        _selectedTemplate = null;
      }
      if (_editingTemplate?.id == id) {
        cancelEditingTemplate();
      }
      await _saveTemplatesToPrefs();
    } catch (e) {
      debugPrint('Error deleting template from backend: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> _saveTemplatesToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded =
          jsonEncode(_templates.map((t) => t.toJson()).toList());
      await prefs.setString('notification_templates', encoded);
    } catch (e) {
      debugPrint('Error saving templates: $e');
    }
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
    templateTitleController.dispose();
    templateMessageController.dispose();
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
  String _formTargetAudience = 'Users'; // 'Users', 'Influencers'

  // Broadcast Type and targeting options
  String _broadcastType = 'all'; // 'all', 'separately'
  String get broadcastType => _broadcastType;

  bool _isLoadingTargetOptions = false;
  bool get isLoadingTargetOptions => _isLoadingTargetOptions;

  List<dynamic> _usersList = [];
  List<dynamic> _influencersList = [];

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
    final index =
        _selectedTargets.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      _selectedTargets.removeAt(index);
    } else {
      _selectedTargets.add(item);
    }
    notifyListeners();
  }

  List<dynamic> get targetOptions {
    if (_formTargetAudience == 'Users') {
      return _usersList.map((user) {
        if (user is Map) {
          return {
            'id': user['id'],
            'name': user['name'] ?? '',
            'image': '',
          };
        }
        return {
          'id': user.id,
          'name': user.name ?? '',
          'image': '',
        };
      }).toList();
    } else if (_formTargetAudience == 'Influencers') {
      return _influencersList.map((influencer) {
        if (influencer is Map) {
          return {
            'id': influencer['id'],
            'name': influencer['name'] ?? '',
            'image': influencer['image'] ?? influencer['profile_image'] ?? '',
          };
        }
        return {
          'id': influencer.id,
          'name': influencer.name ?? '',
          'image': influencer.image ?? '',
        };
      }).toList();
    }
    return [];
  }

  Future<void> fetchTargetOptions() async {
    _isLoadingTargetOptions = true;
    notifyListeners();

    // Fetch users (clients)
    try {
      final res = await locator<ApiService>().getAdminUserList({
        'user': 'client',
        'fcm_token': 1,
      });
      _usersList = (res is Map && res['data'] != null)
          ? res['data']
          : (res is List ? res : []);
    } catch (e) {
      _usersList = [];
      debugPrint('Error fetching users: $e');
    }

    // Fetch influencers
    try {
      final res = await locator<ApiService>().getAdminUserList({
        'user': 'influencer',
        'fcm_token': 1,
      });
      _influencersList = (res is Map && res['data'] != null)
          ? res['data']
          : (res is List ? res : []);
    } catch (e) {
      _influencersList = [];
      debugPrint('Error fetching influencers: $e');
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

  // Get generated Request Body Map matching PHP requirements
  Map<String, dynamic> get lastGeneratedRequestBody {
    final String targetType =
        _formTargetAudience == 'Users' ? 'client' : 'influencer';
    final bool isAllUser = _broadcastType == 'all';
    final List<int> selectedUserIds = _broadcastType == 'separately'
        ? _selectedTargets
            .map<int>((item) => int.tryParse(item['id'].toString()) ?? 0)
            .toList()
        : [];

    return {
      'type': targetType,
      'title': titleController.text.trim(),
      'description': messageController.text.trim(),
      'id': int.tryParse(_selectedTemplate?.id ?? '') ?? 0,
      'user': selectedUserIds,
      'all_user': isAllUser,
      'category': _formCategory,
    };
  }

  // Submit Compose Form
  Future<void> sendBroadcast() async {
    if (titleController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) return;

    // Output Request Body in developer logs
    debugPrint('Generated Request Body: $lastGeneratedRequestBody');

    setBusy(true);
    try {
      // 1. Send the broadcast payload to the PHP backend API
      await locator<ApiService>()
          .sendBroadcastNotification(lastGeneratedRequestBody);

      // 2. Add to local notifications list on success
      NotificationService.instance.sendManualNotification(
        title: titleController.text.trim(),
        message: messageController.text.trim(),
        category: _formCategory,
        targetAudience: _formTargetAudience,
        customTimestamp: combinedScheduledDateTime,
      );

      // Reset composer state
      formKey.currentState?.reset();
      titleController.clear();
      messageController.clear();
      _selectedTemplate = null;
      _formCategory = 'info';
      _formTargetAudience = 'Users';
      _broadcastType = 'all';
      _selectedTargets.clear();
      _isScheduled = false;
      _scheduledDate = null;
      _scheduledTime = null;
      _activeSection =
          'inbox'; // Back to inbox to see the sent notification at top!

      // 3. Refresh notifications list
      await fetchNotifications();
    } catch (e) {
      debugPrint('Error sending broadcast notification: $e');
      rethrow;
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }
}
