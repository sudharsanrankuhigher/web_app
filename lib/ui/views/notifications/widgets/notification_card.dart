import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webapp/services/notification_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'delete_confirmation_dialog.dart';

class NotificationCard extends StatefulWidget {
  final NotificationItem item;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleRead;

  const NotificationCard({
    Key? key,
    required this.item,
    required this.index,
    required this.onTap,
    required this.onDelete,
    required this.onToggleRead,
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isHovered = false;

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color categoryColor = continueButton;
    IconData categoryIcon = Icons.info_outline_rounded;
    Color alertBg = continueButton.withValues(alpha: 0.04);

    switch (widget.item.category) {
      case 'success':
        categoryColor = appGreen500;
        categoryIcon = Icons.check_circle_outline_rounded;
        alertBg = appGreen500.withValues(alpha: 0.04);
        break;
      case 'warning':
        categoryColor = pendingColor;
        categoryIcon = Icons.warning_amber_rounded;
        alertBg = pendingColor.withValues(alpha: 0.04);
        break;
      case 'alert':
        categoryColor = red;
        categoryIcon = Icons.error_outline_rounded;
        alertBg = red.withValues(alpha: 0.04);
        break;
      default:
        categoryColor = continueButton;
        categoryIcon = Icons.info_outline_rounded;
        alertBg = continueButton.withValues(alpha: 0.04);
    }

    final double activeScale = _isHovered ? 1.012 : 1.0;
    final double leftShift = _isHovered ? 4.0 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: activeScale),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          builder: (context, scaleVal, child) {
            return Transform.scale(
              scale: scaleVal,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(leftShift, 0, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.item.isRead
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE5E7EB))
                        : categoryColor.withValues(alpha: 0.25),
                    width: widget.item.isRead ? 1 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? categoryColor.withValues(alpha: 0.12)
                          : const Color(0x04000000),
                      offset: const Offset(0, 4),
                      blurRadius: _isHovered ? 12 : 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Accent Left Border Line
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 6,
                        child: Container(
                          color: widget.item.isRead
                              ? Colors.grey[300]
                              : categoryColor,
                        ),
                      ),

                      // Highlight background for unread
                      if (!widget.item.isRead)
                        Positioned.fill(
                          child: Container(color: alertBg),
                        ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 16.w, 16.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ─── Category Icon Container ───
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.item.isRead
                                    ? (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(0xFF334155)
                                        : Colors.grey[100])
                                    : categoryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                categoryIcon,
                                color: widget.item.isRead
                                    ? (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[400]
                                        : Colors.grey)
                                    : categoryColor,
                                size: 20,
                              ),
                            ),

                            horizontalSpacing16,

                            // ─── Text / Details Container ───
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                widget.item.title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: widget.item.isRead
                                                    ? fontFamilySemiBold
                                                        .size14.greyColor
                                                    : fontFamilyBold
                                                        .size14.black,
                                              ),
                                            ),
                                            if (widget.item.targetAudience !=
                                                null) ...[
                                              horizontalSpacing8,
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: continueButton
                                                      .withValues(alpha: 0.08),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: continueButton
                                                        .withValues(
                                                            alpha: 0.15),
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  widget.item.targetAudience!,
                                                  style: fontFamilyBold.size10
                                                      .copyWith(
                                                          color:
                                                              continueButton),
                                                ),
                                              ),
                                            ],
                                            if (!widget.item.isRead) ...[
                                              horizontalSpacing8,
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: categoryColor,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: categoryColor,
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      horizontalSpacing12,
                                      Text(
                                        _formatTimeAgo(widget.item.timestamp),
                                        style:
                                            fontFamilyMedium.size11.greyColor,
                                      ),
                                    ],
                                  ),
                                  verticalSpacing8,
                                  Text(
                                    widget.item.message,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: widget.item.isRead
                                        ? fontFamilyRegular.size13
                                            .copyWith(color: Colors.grey[500])
                                        : fontFamilyMedium.size13.lightText,
                                  ),
                                ],
                              ),
                            ),

                            horizontalSpacing12,

                            // ─── Actions Hover Panel ───
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Tooltip(
                                  message: widget.item.isRead
                                      ? 'Mark as unread'
                                      : 'Mark as read',
                                  child: IconButton(
                                    icon: Icon(
                                      widget.item.isRead
                                          ? Icons.mark_chat_unread_outlined
                                          : Icons.mark_chat_read_rounded,
                                      size: 18,
                                    ),
                                    color: widget.item.isRead
                                        ? Colors.grey[600]
                                        : categoryColor,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: widget.onToggleRead,
                                  ),
                                ),
                                horizontalSpacing12,
                                Tooltip(
                                  message: 'Delete notification',
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                    ),
                                    color: Colors.grey[400],
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      final confirmed =
                                          await showDeleteConfirmationDialog(
                                        context: context,
                                        title: 'Delete Notification?',
                                        message:
                                            'Are you sure you want to permanently delete this notification? This action cannot be undone.',
                                      );
                                      if (confirmed == true) {
                                        widget.onDelete();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
