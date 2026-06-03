import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/initial_textform.dart';

import 'notifications_viewmodel.dart';
import 'package:webapp/services/notification_service.dart';
import 'widgets/notification_card.dart';

class NotificationsView extends StackedView<NotificationsViewModel> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NotificationsViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    // Fallback: If permissions is not empty, respect canView('notifications'), otherwise allow in debug/development.
    final bool hasAccess =
        PermissionHelper.instance.has('send_notifications') ||
            PermissionHelper.instance.userPermissions.isEmpty;

    // if (!hasAccess) {
    //   return Scaffold(
    //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //     body: const NoAccessWidget(),
    //   );
    // }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Section ───
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isExtended ? 24.h : 16.h,
              horizontal: 24.w,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications Center',
                          style: fontFamilyBold.size24.black,
                        ),
                        verticalSpacing4,
                        Text(
                          'Manage, filter, and track system notifications.',
                          style: fontFamilyMedium.size12.greyColor,
                        ),
                      ],
                    ),
                    if (viewModel.unreadCount > 0 &&
                        viewModel.activeSection == 'inbox')
                      ElevatedButton.icon(
                        onPressed: viewModel.markAllAsRead,
                        icon: const Icon(Icons.done_all_rounded, size: 18),
                        label: Text(
                          'Mark all as read',
                          style: fontFamilySemiBold.size13.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: continueButton,
                          foregroundColor: white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
                Divider(
                  height: 32,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF3F4F6),
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    _buildSectionTab(
                      context,
                      viewModel,
                      sectionValue: 'inbox',
                      icon: Icons.inbox_rounded,
                      label: 'Inbox',
                    ),
                    if (hasAccess) ...[
                      horizontalSpacing16,
                      _buildSectionTab(
                        context,
                        viewModel,
                        sectionValue: 'create_template',
                        icon: Icons.dashboard_customize_rounded,
                        label: 'Create Template',
                      ),
                      horizontalSpacing16,
                      _buildSectionTab(
                        context,
                        viewModel,
                        sectionValue: 'send',
                        icon: Icons.send_rounded,
                        label: 'Send Broadcast',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ─── Main Content Toggled Views ───
          Expanded(
            child: IndexedStack(
              index: viewModel.activeSection == 'inbox'
                  ? 0
                  : (viewModel.activeSection == 'send' ? 1 : 2),
              children: [
                // Section 0: Inbox View
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sub Header / Stats Panel
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 16.h),
                      child: Row(
                        children: [
                          _buildStatChip(
                            context,
                            title: 'Total',
                            count: viewModel.notifications.length,
                            color: continueButton,
                            icon: Icons.notifications_none_rounded,
                          ),
                          horizontalSpacing12,
                          _buildStatChip(
                            context,
                            title: 'Unread',
                            count: viewModel.unreadCount,
                            color: red,
                            icon: Icons.mark_chat_unread_outlined,
                            isActive: viewModel.unreadCount > 0,
                          ),
                        ],
                      ),
                    ),

                    // Filter Tabs Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton(
                                viewModel, 'all', 'All Notifications'),
                            _buildTabButton(
                              viewModel,
                              'unread',
                              'Unread (${viewModel.unreadCount})',
                            ),
                            _buildTabButton(viewModel, 'read', 'Read'),
                          ],
                        ),
                      ),
                    ),
                    verticalSpacing12,
                    // Notifications List
                    Expanded(
                      child: viewModel.filteredNotifications.isEmpty
                          ? _buildEmptyState(context, viewModel.currentFilter)
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 8.h),
                              itemCount: viewModel.filteredNotifications.length,
                              itemBuilder: (context, index) {
                                final item =
                                    viewModel.filteredNotifications[index];
                                // Smooth slide-in staggering effect using TweenAnimationBuilder
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: Duration(
                                      milliseconds: 300 + (index * 50)),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 30 * (1.0 - value)),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.h),
                                          child: NotificationCard(
                                            item: item,
                                            index: index,
                                            onTap: () {
                                              viewModel.markAsRead(item.id);
                                              _showNotificationDetails(
                                                  context, item);
                                            },
                                            onToggleRead: () => viewModel
                                                .toggleReadState(item.id),
                                            onDelete: () => viewModel
                                                .deleteNotification(item.id),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
                // Section 1: Compose Form View
                _buildBroadcastForm(context, viewModel),
                // Section 2: Create Template View
                _buildCreateTemplateForm(context, viewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTab(
    BuildContext context,
    NotificationsViewModel viewModel, {
    required String sectionValue,
    required IconData icon,
    required String label,
  }) {
    final bool isActive = viewModel.activeSection == sectionValue;
    return GestureDetector(
      onTap: () => viewModel.setActiveSection(sectionValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? continueButton.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? continueButton.withValues(alpha: 0.15)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? continueButton
                  : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[500]),
            ),
            horizontalSpacing8,
            Text(
              label,
              style: isActive
                  ? fontFamilyBold.size14.copyWith(color: continueButton)
                  : fontFamilySemiBold.size14.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBroadcastForm(
    BuildContext context,
    NotificationsViewModel viewModel,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compose Manual Broadcast',
                      style: fontFamilyBold.size18.black,
                    ),
                    verticalSpacing4,
                    Text(
                      'Dispatch a system notification dynamically to a targeted user group.',
                      style: fontFamilyMedium.size12.greyColor,
                    ),
                    const SizedBox(height: 24),
                    // Template Dropdown
                    Text(
                      'Select Notification Template (Optional)',
                      style: fontFamilySemiBold.size13.black,
                    ),
                    verticalSpacing8,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            isDark ? const Color(0xFF1E293B) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<NotificationTemplate>(
                          value: viewModel.selectedTemplate,
                          hint: Text(
                            'Choose a template to pre-fill...',
                            style: fontFamilyMedium.size12.greyColor,
                          ),
                          isExpanded: true,
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          items: [
                            DropdownMenuItem<NotificationTemplate>(
                              value: null,
                              child: Text(
                                '-- Clear Selection / Custom Message --',
                                style: fontFamilyMedium.size12
                                    .copyWith(color: Colors.red),
                              ),
                            ),
                            ...viewModel.templates.map((t) {
                              return DropdownMenuItem<NotificationTemplate>(
                                value: t,
                                child: Text(
                                  t.title,
                                  style: fontFamilyMedium.size12.black,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: viewModel.selectTemplate,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title Field
                    Text(
                      'Broadcast Title',
                      style: fontFamilySemiBold.size13.black,
                    ),
                    verticalSpacing8,
                    InitialTextForm(
                      key: const ValueKey('title_field'),
                      radius: 12,
                      hintText: 'Enter a concise notification title...',
                      controller: viewModel.titleController,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Title is required'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    // Message Field
                    Text(
                      'Detailed Message',
                      style: fontFamilySemiBold.size13.black,
                    ),
                    verticalSpacing8,
                    InitialTextForm(
                      key: const ValueKey('message_field'),
                      radius: 12,
                      maxLines: 4,
                      hintText:
                          'Write the complete announcement content here...',
                      controller: viewModel.messageController,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Message content is required'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Target Audience Selector
                    Text(
                      'Target Audience Group',
                      style: fontFamilySemiBold.size13.black,
                    ),
                    verticalSpacing8,
                    _buildAudienceSelector(viewModel),
                    const SizedBox(height: 20),

                    // Broadcast Option Selector
                    Text(
                      'Broadcast Option',
                      style: fontFamilySemiBold.size13.black,
                    ),
                    verticalSpacing8,
                    _buildBroadcastTypeSelector(viewModel),
                    const SizedBox(height: 20),

                    // If Separately selected, show custom selector
                    if (viewModel.broadcastType == 'separately') ...[
                      Text(
                        'Select Recipients (${viewModel.formTargetAudience})',
                        style: fontFamilySemiBold.size13.black,
                      ),
                      verticalSpacing8,
                      if (viewModel.isLoadingTargetOptions)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        _buildCustomRecipientSelector(context, viewModel),
                      const SizedBox(height: 20),
                    ],

                    // Scheduling Header Card & Toggle
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: isDark
                    //         ? const Color(0xFF0F172A)
                    //         : const Color(0xFFF9FAFB),
                    //     borderRadius: BorderRadius.circular(12),
                    //     border: Border.all(
                    //       color: isDark
                    //           ? const Color(0xFF334155)
                    //           : const Color(0xFFE5E7EB),
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       SwitchListTile.adaptive(
                    //         title: Row(
                    //           children: [
                    //             Icon(
                    //               Icons.calendar_month_rounded,
                    //               size: 20,
                    //               color: viewModel.isScheduled
                    //                   ? continueButton
                    //                   : Colors.grey[600],
                    //             ),
                    //             const SizedBox(width: 10),
                    //             Text(
                    //               'Schedule for Later',
                    //               style: fontFamilyBold.size13.copyWith(
                    //                 color: viewModel.isScheduled
                    //                     ? continueButton
                    //                     : (isDark
                    //                         ? Colors.grey[400]
                    //                         : Colors.grey[800]),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         subtitle: Padding(
                    //           padding: const EdgeInsets.only(left: 30.0),
                    //           child: Text(
                    //             'Set an optional custom date & time to dispatch',
                    //             style: fontFamilyMedium.size11.greyColor,
                    //           ),
                    //         ),
                    //         value: viewModel.isScheduled,
                    //         activeColor: continueButton,
                    //         onChanged: viewModel.toggleScheduled,
                    //         contentPadding: const EdgeInsets.symmetric(
                    //             horizontal: 16, vertical: 4),
                    //       ),
                    //       if (viewModel.isScheduled) ...[
                    //         Divider(
                    //             height: 1,
                    //             color: isDark
                    //                 ? const Color(0xFF334155)
                    //                 : const Color(0xFFE5E7EB)),
                    //         Padding(
                    //           padding: const EdgeInsets.all(16.0),
                    //           child: Row(
                    //             children: [
                    //               // Date Picker Button
                    //               Expanded(
                    //                 child: InkWell(
                    //                   onTap: () =>
                    //                       viewModel.selectDate(context),
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   child: Container(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         vertical: 12, horizontal: 14),
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                         color: viewModel.scheduledDate !=
                    //                                 null
                    //                             ? continueButton.withValues(
                    //                                 alpha: 0.5)
                    //                             : (isDark
                    //                                 ? const Color(0xFF475569)
                    //                                 : const Color(0xFFD1D5DB)),
                    //                       ),
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       color: isDark
                    //                           ? const Color(0xFF1E293B)
                    //                           : white,
                    //                     ),
                    //                     child: Row(
                    //                       children: [
                    //                         Icon(
                    //                           Icons.date_range_rounded,
                    //                           size: 16,
                    //                           color: viewModel.scheduledDate !=
                    //                                   null
                    //                               ? continueButton
                    //                               : Colors.grey[600],
                    //                         ),
                    //                         const SizedBox(width: 8),
                    //                         Expanded(
                    //                           child: Text(
                    //                             viewModel.scheduledDate != null
                    //                                 ? "${viewModel.scheduledDate!.day}/${viewModel.scheduledDate!.month}/${viewModel.scheduledDate!.year}"
                    //                                 : "Select Date",
                    //                             style: fontFamilyMedium.size12
                    //                                 .copyWith(
                    //                               color:
                    //                                   viewModel.scheduledDate !=
                    //                                           null
                    //                                       ? (isDark
                    //                                           ? Colors.white
                    //                                           : Colors.black87)
                    //                                       : Colors.grey[500],
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               const SizedBox(width: 12),
                    //               // Time Picker Button
                    //               Expanded(
                    //                 child: InkWell(
                    //                   onTap: () =>
                    //                       viewModel.selectTime(context),
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   child: Container(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         vertical: 12, horizontal: 14),
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                         color: viewModel.scheduledTime !=
                    //                                 null
                    //                             ? continueButton.withValues(
                    //                                 alpha: 0.5)
                    //                             : (isDark
                    //                                 ? const Color(0xFF475569)
                    //                                 : const Color(0xFFD1D5DB)),
                    //                       ),
                    //                       borderRadius:
                    //                           BorderRadius.circular(10),
                    //                       color: isDark
                    //                           ? const Color(0xFF1E293B)
                    //                           : white,
                    //                     ),
                    //                     child: Row(
                    //                       children: [
                    //                         Icon(
                    //                           Icons.access_time_rounded,
                    //                           size: 16,
                    //                           color: viewModel.scheduledTime !=
                    //                                   null
                    //                               ? continueButton
                    //                               : Colors.grey[600],
                    //                         ),
                    //                         const SizedBox(width: 8),
                    //                         Expanded(
                    //                           child: Text(
                    //                             viewModel.scheduledTime != null
                    //                                 ? viewModel.scheduledTime!
                    //                                     .format(context)
                    //                                 : "Select Time",
                    //                             style: fontFamilyMedium.size12
                    //                                 .copyWith(
                    //                               color:
                    //                                   viewModel.scheduledTime !=
                    //                                           null
                    //                                       ? (isDark
                    //                                           ? Colors.white
                    //                                           : Colors.black87)
                    //                                       : Colors.grey[500],
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 32),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            if (viewModel.broadcastType == 'separately' &&
                                viewModel.selectedTargets.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Please select at least one recipient.',
                                        style: fontFamilySemiBold.size13.white,
                                      ),
                                    ],
                                  ),
                                  backgroundColor: red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(24),
                                ),
                              );
                              return;
                            }

                            if (viewModel.isScheduled &&
                                (viewModel.scheduledDate == null ||
                                    viewModel.scheduledTime == null)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Please select both date and time to schedule.',
                                        style: fontFamilySemiBold.size13.white,
                                      ),
                                    ],
                                  ),
                                  backgroundColor: red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.all(24),
                                ),
                              );
                              return;
                            }

                            final requestPayload =
                                viewModel.lastGeneratedRequestBody;
                            _showRequestBodyDialog(
                              context,
                              requestPayload,
                              onAcknowledge: () {
                                viewModel.sendBroadcast();
                              },
                            );
                          }
                        },
                        icon: const Icon(Icons.send_rounded, size: 18),
                        label: Text(
                          'Dispatch Broadcast Alert',
                          style: fontFamilySemiBold.size14.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: continueButton,
                          foregroundColor: white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector({
    required String selectedCategory,
    required ValueChanged<String> onCategorySelected,
  }) {
    final categories = [
      {
        'value': 'info',
        'label': 'Info',
        'color': continueButton,
        'icon': Icons.info_outline_rounded
      },
      {
        'value': 'success',
        'label': 'Success',
        'color': appGreen500,
        'icon': Icons.check_circle_outline_rounded
      },
      {
        'value': 'warning',
        'label': 'Warning',
        'color': pendingColor,
        'icon': Icons.warning_amber_rounded
      },
      {
        'value': 'alert',
        'label': 'Alert',
        'color': red,
        'icon': Icons.error_outline_rounded
      },
    ];

    return Row(
      children: categories.map((cat) {
        final bool isSelected = selectedCategory == cat['value'];
        final Color catColor = cat['color'] as Color;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () => onCategorySelected(cat['value'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? catColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? catColor : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat['icon'] as IconData,
                      color: isSelected ? catColor : Colors.grey[500],
                      size: 20,
                    ),
                    verticalSpacing4,
                    Text(
                      cat['label'] as String,
                      style: isSelected
                          ? fontFamilyBold.size12.copyWith(color: catColor)
                          : fontFamilyMedium.size12
                              .copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAudienceSelector(NotificationsViewModel viewModel) {
    final audiences = [
      {'value': 'Users', 'icon': Icons.people_outline_rounded},
      {'value': 'Influencers', 'icon': Icons.campaign_outlined},
      {
        'value': 'Admin / Sub Admin',
        'icon': Icons.admin_panel_settings_outlined
      },
    ];

    return Row(
      children: audiences.map((aud) {
        final bool isSelected = viewModel.formTargetAudience == aud['value'];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () =>
                  viewModel.setFormTargetAudience(aud['value'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? continueButton.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? continueButton : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      aud['icon'] as IconData,
                      color: isSelected ? continueButton : Colors.grey[500],
                      size: 16,
                    ),
                    horizontalSpacing8,
                    Text(
                      aud['value'] as String,
                      style: isSelected
                          ? fontFamilyBold.size12
                              .copyWith(color: continueButton)
                          : fontFamilyMedium.size12
                              .copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBroadcastTypeSelector(NotificationsViewModel viewModel) {
    final types = [
      {
        'value': 'all',
        'label': 'All Recipients',
        'icon': Icons.all_inclusive_rounded
      },
      {
        'value': 'separately',
        'label': 'Select Separately',
        'icon': Icons.checklist_rtl_rounded
      },
    ];

    return Row(
      children: types.map((type) {
        final bool isSelected = viewModel.broadcastType == type['value'];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                viewModel.setBroadcastType(type['value'] as String);
                viewModel.clearSelectedTargets();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? continueButton.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? continueButton : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      type['icon'] as IconData,
                      color: isSelected ? continueButton : Colors.grey[500],
                      size: 16,
                    ),
                    horizontalSpacing8,
                    Text(
                      type['label'] as String,
                      style: isSelected
                          ? fontFamilyBold.size12
                              .copyWith(color: continueButton)
                          : fontFamilyMedium.size12
                              .copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomRecipientSelector(
    BuildContext context,
    NotificationsViewModel viewModel,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedCount = viewModel.selectedTargets.length;

    return InkWell(
      onTap: () => _showRecipientSelectionDialog(context, viewModel),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : disableColor,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedCount == 0
                  ? Text(
                      'Tap to select ${viewModel.formTargetAudience}...',
                      style: fontFamilyMedium.size12.greyColor,
                    )
                  : Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: viewModel.selectedTargets.take(3).map((item) {
                        return Chip(
                          label: Text(
                            item['name'] ?? '',
                            style: fontFamilyMedium.size11.black,
                          ),
                          visualDensity: VisualDensity.compact,
                          backgroundColor:
                              continueButton.withValues(alpha: 0.1),
                          onDeleted: () {
                            viewModel.toggleTargetSelection(item);
                          },
                        );
                      }).toList(),
                    ),
            ),
            if (selectedCount > 3) ...[
              const SizedBox(width: 6),
              Text(
                '+${selectedCount - 3} more',
                style: fontFamilyBold.size11.copyWith(color: continueButton),
              ),
            ],
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  void _showRecipientSelectionDialog(
    BuildContext context,
    NotificationsViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final searchController = TextEditingController();
            List<dynamic> filteredOptions = viewModel.targetOptions;

            void filterSearch(String query) {
              setState(() {
                filteredOptions = viewModel.targetOptions
                    .where((option) => option['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              });
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 600),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select ${viewModel.formTargetAudience}',
                        style: fontFamilyBold.size16.black,
                      ),
                      verticalSpacing12,
                      // Search Bar
                      TextField(
                        controller: searchController,
                        onChanged: filterSearch,
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                      ),
                      verticalSpacing16,
                      // Selected list count
                      Text(
                        '${viewModel.selectedTargets.length} selected',
                        style: fontFamilySemiBold.size12
                            .copyWith(color: continueButton),
                      ),
                      verticalSpacing8,
                      // Scrollable List of options
                      Expanded(
                        child: filteredOptions.isEmpty
                            ? Center(
                                child: Text(
                                  'No options found',
                                  style: fontFamilyMedium.size12.greyColor,
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredOptions.length,
                                itemBuilder: (context, index) {
                                  final option = filteredOptions[index];
                                  final bool isSelected = viewModel
                                      .selectedTargets
                                      .any((e) => e['id'] == option['id']);

                                  final image = option['image'];
                                  final hasImage =
                                      image != null && image.isNotEmpty;

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: hasImage
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              image,
                                              height: 36,
                                              width: 36,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  CircleAvatar(
                                                radius: 18,
                                                child: Text(option['name'][0]
                                                    .toUpperCase()),
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 18,
                                            child: Text(option['name'][0]
                                                .toUpperCase()),
                                          ),
                                    title: Text(
                                      option['name'],
                                      style: fontFamilyMedium.size13.black,
                                    ),
                                    trailing: Checkbox(
                                      value: isSelected,
                                      activeColor: continueButton,
                                      onChanged: (bool? checked) {
                                        setState(() {
                                          viewModel
                                              .toggleTargetSelection(option);
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        viewModel.toggleTargetSelection(option);
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                      verticalSpacing16,
                      // Done Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: continueButton,
                              foregroundColor: white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Done',
                              style: fontFamilySemiBold.size13.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    bool isActive = true,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive
            ? color.withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? color.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive ? color : Colors.grey,
          ),
          horizontalSpacing8,
          Text(
            '$title: ',
            style: fontFamilyMedium.size12.copyWith(
              color: isActive ? color : Colors.grey[700],
            ),
          ),
          Text(
            '$count',
            style: fontFamilyBold.size12.copyWith(
              color: isActive ? color : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    NotificationsViewModel viewModel,
    String filterValue,
    String label,
  ) {
    final bool isSelected = viewModel.currentFilter == filterValue;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () => viewModel.setFilter(filterValue),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isSelected
                  ? [
                      const BoxShadow(
                        color: Color(0x0C000000),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: isSelected
                  ? fontFamilySemiBold.size14.copyWith(color: continueButton)
                  : fontFamilyMedium.size14.copyWith(color: Colors.grey[600]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String filter) {
    String message = 'You have no notifications yet.';
    if (filter == 'unread') {
      message = 'You have no unread notifications!';
    } else if (filter == 'read') {
      message = 'You have no read notifications yet.';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  offset: Offset(0, 10),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: Colors.grey[300],
            ),
          ),
          verticalSpacing20,
          Text(
            'All Caught Up!',
            style: fontFamilyBold.size16.black,
          ),
          verticalSpacing8,
          Text(
            message,
            style: fontFamilyMedium.size13.greyColor,
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationItem item) {
    showDialog(
      context: context,
      builder: (context) {
        Color categoryColor = continueButton;
        IconData categoryIcon = Icons.info_outline;

        switch (item.category) {
          case 'success':
            categoryColor = appGreen500;
            categoryIcon = Icons.check_circle_outline_rounded;
            break;
          case 'warning':
            categoryColor = pendingColor;
            categoryIcon = Icons.warning_amber_rounded;
            break;
          case 'alert':
            categoryColor = red;
            categoryIcon = Icons.error_outline_rounded;
            break;
          default:
            categoryColor = continueButton;
            categoryIcon = Icons.info_outline;
        }

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          categoryIcon,
                          color: categoryColor,
                          size: 24,
                        ),
                      ),
                      horizontalSpacing16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: fontFamilyBold.size16.black,
                            ),
                            verticalSpacing4,
                            Text(
                              _formatFullDate(item.timestamp),
                              style: fontFamilyMedium.size11.greyColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing20,
                  Text(
                    item.message,
                    style:
                        fontFamilyMedium.size14.lightText.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: fontFamilySemiBold.size14
                              .copyWith(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatFullDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showRequestBodyDialog(
    BuildContext context,
    Map<String, dynamic> requestBody, {
    required VoidCallback onAcknowledge,
  }) {
    final String jsonString =
        const JsonEncoder.withIndent('  ').convert(requestBody);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: appGreen500.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: appGreen500,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Broadcast Dispatched!',
                              style: fontFamilyBold.size18.black,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Notification successfully added and sent.',
                              style: fontFamilyMedium.size12.greyColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Request Body Label & Copy Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'API HTTP Request Body',
                        style: fontFamilyBold.size13
                            .copyWith(color: Colors.grey[700]),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: jsonString));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Request payload copied to clipboard!',
                                style: fontFamilySemiBold.size12.white,
                              ),
                              backgroundColor: Colors.grey[900],
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded,
                            size: 14, color: continueButton),
                        label: Text(
                          'Copy Payload',
                          style: fontFamilySemiBold.size12
                              .copyWith(color: continueButton),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Dark Code Editor Container
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E), // Premium dark theme
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF313244)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SelectableText(
                        jsonString,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          height: 1.4,
                          color: Color(0xFFCDD6F4), // Premium text color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onAcknowledge();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: continueButton,
                          foregroundColor: white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Acknowledge',
                          style: fontFamilySemiBold.size13.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreateTemplateForm(
    BuildContext context,
    NotificationsViewModel viewModel,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Create form
              Expanded(
                flex: 4,
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.isEditingTemplate
                                ? 'Edit Template'
                                : 'Create Template',
                            style: fontFamilyBold.size18.black,
                          ),
                          verticalSpacing4,
                          Text(
                            viewModel.isEditingTemplate
                                ? 'Modify the selected message template.'
                                : 'Define reusable message templates for future broadcasts.',
                            style: fontFamilyMedium.size12.greyColor,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Template Title',
                            style: fontFamilySemiBold.size13.black,
                          ),
                          verticalSpacing8,
                          InitialTextForm(
                            key: const ValueKey('tmpl_title_field'),
                            radius: 12,
                            hintText:
                                'e.g., Welcome Message, Action Required...',
                            controller: viewModel.templateTitleController,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Template title is required'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Notification Category',
                            style: fontFamilySemiBold.size13.black,
                          ),
                          verticalSpacing8,
                          _buildCategorySelector(
                            selectedCategory: viewModel.templateCategory,
                            onCategorySelected: viewModel.setTemplateCategory,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Template Message',
                            style: fontFamilySemiBold.size13.black,
                          ),
                          verticalSpacing8,
                          InitialTextForm(
                            key: const ValueKey('tmpl_msg_field'),
                            radius: 12,
                            maxLines: 5,
                            hintText: 'Write the template message content...',
                            controller: viewModel.templateMessageController,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Template message is required'
                                : null,
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: viewModel.isBusy
                                        ? null
                                        : () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              final wasEditing =
                                                  viewModel.isEditingTemplate;
                                              await viewModel.saveTemplate();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    wasEditing
                                                        ? 'Template updated successfully!'
                                                        : 'Template saved successfully!',
                                                    style: fontFamilySemiBold
                                                        .size12.white,
                                                  ),
                                                  backgroundColor: appGreen500,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin:
                                                      const EdgeInsets.all(24),
                                                ),
                                              );
                                            }
                                          },
                                    child: viewModel.isBusy
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                viewModel.isEditingTemplate
                                                    ? Icons.update_rounded
                                                    : Icons.save_rounded,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                viewModel.isEditingTemplate
                                                    ? 'Update Template'
                                                    : 'Save Template',
                                                style: fontFamilySemiBold
                                                    .size14.white,
                                              ),
                                            ],
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: continueButton,
                                      foregroundColor: white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (viewModel.isEditingTemplate) ...[
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: viewModel.cancelEditingTemplate,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[300]
                                              : Colors.grey[700],
                                      side: BorderSide(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: fontFamilySemiBold.size14,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Right side: Templates List
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                      child: Text(
                        'Saved Templates (${viewModel.templates.length})',
                        style: fontFamilyBold.size14.black,
                      ),
                    ),
                    if (viewModel.templates.isEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.analytics_outlined,
                                    size: 36, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text(
                                  'No templates saved yet.',
                                  style: fontFamilyMedium.size12.greyColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 500,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: viewModel.templates.length,
                          itemBuilder: (context, index) {
                            final t = viewModel.templates[index];
                            return Card(
                              color: Theme.of(context).colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              _buildCategoryIcon(t.category),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  t.title,
                                                  style: fontFamilyBold
                                                      .size13.black,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit_rounded,
                                                color: continueButton,
                                                size: 16,
                                              ),
                                              onPressed: () {
                                                viewModel
                                                    .startEditingTemplate(t);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                              onPressed: () {
                                                _confirmDeleteTemplate(
                                                  context,
                                                  viewModel,
                                                  t.id,
                                                  t.title,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      t.message,
                                      style: fontFamilyMedium.size12.greyColor,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  NotificationsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NotificationsViewModel();

  @override
  void onViewModelReady(NotificationsViewModel viewModel) {
    viewModel.fetchNotifications();
    super.onViewModelReady(viewModel);
  }

  void _confirmDeleteTemplate(
    BuildContext context,
    NotificationsViewModel viewModel,
    String templateId,
    String title,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete the template '$title'? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await viewModel.deleteTemplate(templateId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Template deleted.',
                        style: fontFamilySemiBold.size12.white,
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(24),
                    ),
                  );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryIcon(String category) {
    IconData iconData = Icons.info_outline_rounded;
    Color color = continueButton;
    switch (category) {
      case 'success':
        iconData = Icons.check_circle_outline_rounded;
        color = appGreen500;
        break;
      case 'warning':
        iconData = Icons.warning_amber_rounded;
        color = pendingColor;
        break;
      case 'alert':
        iconData = Icons.error_outline_rounded;
        color = red;
        break;
    }
    return Icon(iconData, size: 14, color: color);
  }
}
