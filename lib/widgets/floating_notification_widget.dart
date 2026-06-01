import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/ui/common/shared/styles.dart';

class FloatingNotificationWidget extends StatefulWidget {
  final ValueNotifier<int> badgeCountNotifier;
  final void Function(BuildContext context)? onTap;

  const FloatingNotificationWidget({
    Key? key,
    required this.badgeCountNotifier,
    this.onTap,
  }) : super(key: key);

  @override
  State<FloatingNotificationWidget> createState() =>
      _FloatingNotificationWidgetState();
}

class _FloatingNotificationWidgetState extends State<FloatingNotificationWidget>
    with TickerProviderStateMixin {
  Offset _position = const Offset(20, 100);
  bool _isInitialized = false;
  final double _widgetSize = 58.0;

  late AnimationController _animationController;
  Animation<Offset>? _snapAnimation;

  // For the bell shake micro-animation
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Bell shake animation setup
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.15), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.1), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.easeInOut,
      ),
    );

    // Shake the bell whenever unread badge count increases/changes
    widget.badgeCountNotifier.addListener(_onBadgeCountChanged);

    _initPosition();
  }

  void _onBadgeCountChanged() {
    if (widget.badgeCountNotifier.value > 0) {
      _shakeController.forward(from: 0.0);
    }
  }

  Future<void> _initPosition() async {
    _prefs = locator<SharedPreferences>();
    final double? x = _prefs.getDouble('floating_notification_x');
    final double? y = _prefs.getDouble('floating_notification_y');

    setState(() {
      if (x != null && y != null) {
        _position = Offset(x, y);
      } else {
        // Default starting position: bottom-right
        _position = const Offset(300, 500);
      }
      _isInitialized = true;
    });

    // Initial shake if count is already > 0
    if (widget.badgeCountNotifier.value > 0) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    widget.badgeCountNotifier.removeListener(_onBadgeCountChanged);
    _animationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _snapToEdge(double screenWidth) {
    final double midX = screenWidth / 2;
    double targetX;
    if (_position.dx + _widgetSize / 2 < midX) {
      // Snap to Left Edge (with safety margin)
      targetX = 16.0;
    } else {
      // Snap to Right Edge (with safety margin)
      targetX = screenWidth - _widgetSize - 16.0;
    }

    final double startY = _position.dy;

    _snapAnimation = Tween<Offset>(
      begin: _position,
      end: Offset(targetX, startY),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack, // Premium bouncy-snap feel
      ),
    )..addListener(() {
        setState(() {
          _position = _snapAnimation!.value;
        });
      });

    _animationController.forward(from: 0.0).then((_) {
      // Save coordinate coordinates to SharedPreferences
      _prefs.setDouble('floating_notification_x', _position.dx);
      _prefs.setDouble('floating_notification_y', _position.dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const SizedBox.shrink();

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    // Boundary padding constraints (status bars and navigation overlays)
    final double topPadding = mediaQuery.padding.top + 12;
    final double bottomPadding = mediaQuery.padding.bottom + 12;

    // Clamp coordinates safely within the display resolution bounds
    double clampedX = _position.dx.clamp(0.0, screenWidth - _widgetSize);
    double clampedY = _position.dy
        .clamp(topPadding, screenHeight - bottomPadding - _widgetSize);

    if (clampedX != _position.dx || clampedY != _position.dy) {
      _position = Offset(clampedX, clampedY);
    }

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (_animationController.isAnimating) {
            _animationController.stop();
          }
          setState(() {
            _position += details.delta;
            // Apply live boundary constraints to follow touch drags
            double newX = _position.dx.clamp(0.0, screenWidth - _widgetSize);
            double newY = _position.dy
                .clamp(topPadding, screenHeight - bottomPadding - _widgetSize);
            _position = Offset(newX, newY);
          });
        },
        onPanEnd: (DragEndDetails details) {
          _snapToEdge(screenWidth);
        },
        onTap: widget.onTap != null ? () => widget.onTap!(context) : null,
        child: ValueListenableBuilder<int>(
          valueListenable: widget.badgeCountNotifier,
          builder: (context, badgeCount, _) {
            return Material(
              color: Colors.transparent,
              type: MaterialType.transparency,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Sleek, gradient circular floating button
                  Container(
                    width: _widgetSize,
                    height: _widgetSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          continueButton, // Color(0xFF2B5CFF)
                          continueButton.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: continueButton.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _shakeAnimation.value,
                          child: child,
                        );
                      },
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),

                  // Elastic scaling red badge unread count
                  if (badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.elasticOut,
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        builder: (context, scaleVal, child) {
                          return Transform.scale(
                            scale: scaleVal,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF416C), // Vibrant magenta-rose
                                Color(0xFFFF4B2B), // Vibrant sunset red
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF416C).withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$badgeCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Inter_Bold',
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
