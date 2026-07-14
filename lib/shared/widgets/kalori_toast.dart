import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';

/// The type/variant of the custom toast.
enum KaloriToastType {
  success,
  error,
  warning,
  info,
  custom,
}

/// A standalone interactive toast card featuring an animated icon, sleek modern minimalism,
/// optional action CTA, and optional progress bar.
class AnimatedKaloriToastWidget extends StatelessWidget {
  final String title;
  final String? message;
  final KaloriToastType type;
  final IconData? customIcon;
  final Color? customIconColor;
  final Color? customBackgroundColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final bool showDismissButton;
  final Duration? progressDuration;

  const AnimatedKaloriToastWidget({
    super.key,
    required this.title,
    this.message,
    this.type = KaloriToastType.info,
    this.customIcon,
    this.customIconColor,
    this.customBackgroundColor,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.showDismissButton = true,
    this.progressDuration,
  });

  @override
  Widget build(BuildContext context) {
    final _ToastThemeConfig config = _getConfig(type);
    final IconData icon = customIcon ?? config.icon;
    final Color iconColor = customIconColor ?? config.iconColor;
    final Color badgeBg = customBackgroundColor ?? config.badgeBgColor;
    final Color borderColor = config.borderColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: KaloriSpacing.md, vertical: 6.0),
      decoration: BoxDecoration(
        color: KaloriColors.surfaceContainerLowest,
        borderRadius: KaloriRadius.borderLg,
        border: Border.all(color: borderColor.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: KaloriColors.onSurface.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: borderColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: KaloriRadius.borderLg,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(KaloriSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Icon Badge
                  _AnimatedToastIcon(
                    type: type,
                    icon: icon,
                    iconColor: iconColor,
                    backgroundColor: badgeBg,
                  ),
                  const SizedBox(width: KaloriSpacing.sm),

                  // Title & Message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 2.0),
                        Text(
                          title,
                          style: context.typography.headlineMd.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: KaloriColors.onSurface,
                            height: 1.3,
                          ),
                        ),
                        if (message != null && message!.isNotEmpty) ...[
                          const SizedBox(height: 4.0),
                          Text(
                            message!,
                            style: context.typography.bodySm.copyWith(
                              fontSize: 13.0,
                              color: KaloriColors.onSurfaceVariant.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                        if (actionLabel != null && actionLabel!.isNotEmpty) ...[
                          const SizedBox(height: 10.0),
                          InkWell(
                            onTap: () {
                              onAction?.call();
                            },
                            borderRadius: KaloriRadius.borderSm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: KaloriRadius.borderSm,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    actionLabel!,
                                    style: TextStyle(
                                      fontFamily: KaloriTypography.fontFamily,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: iconColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14.0,
                                    color: iconColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Dismiss button
                  if (showDismissButton) ...[
                    const SizedBox(width: 8.0),
                    InkWell(
                      onTap: () {
                        if (Get.isSnackbarOpen) {
                          Get.closeCurrentSnackbar();
                        }
                        onDismiss?.call();
                      },
                      borderRadius: KaloriRadius.borderFull,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18.0,
                          color: KaloriColors.outline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Optional countdown progress bar along the bottom of the card
            if (progressDuration != null && progressDuration! > Duration.zero)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _ToastProgressBar(
                  duration: progressDuration!,
                  color: iconColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _ToastThemeConfig _getConfig(KaloriToastType type) {
    switch (type) {
      case KaloriToastType.success:
        return _ToastThemeConfig(
          icon: Icons.check_circle_rounded,
          iconColor: KaloriColors.onPrimaryContainer,
          badgeBgColor: KaloriColors.primaryContainer,
          borderColor: KaloriColors.primary,
        );
      case KaloriToastType.error:
        return _ToastThemeConfig(
          icon: Icons.error_outline_rounded,
          iconColor: KaloriColors.onErrorContainer,
          badgeBgColor: KaloriColors.errorContainer,
          borderColor: KaloriColors.error,
        );
      case KaloriToastType.warning:
        return _ToastThemeConfig(
          icon: Icons.warning_amber_rounded,
          iconColor: KaloriColors.onSecondaryContainer,
          badgeBgColor: KaloriColors.secondaryContainer,
          borderColor: KaloriColors.secondary,
        );
      case KaloriToastType.info:
      case KaloriToastType.custom:
        return _ToastThemeConfig(
          icon: Icons.info_outline_rounded,
          iconColor: KaloriColors.onTertiaryContainer,
          badgeBgColor: KaloriColors.tertiaryContainer,
          borderColor: KaloriColors.tertiary,
        );
    }
  }
}

class _ToastThemeConfig {
  final IconData icon;
  final Color iconColor;
  final Color badgeBgColor;
  final Color borderColor;

  _ToastThemeConfig({
    required this.icon,
    required this.iconColor,
    required this.badgeBgColor,
    required this.borderColor,
  });
}

/// Internal stateful widget responsible for high-polish animated icon transitions.
class _AnimatedToastIcon extends StatefulWidget {
  final KaloriToastType type;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _AnimatedToastIcon({
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  State<_AnimatedToastIcon> createState() => _AnimatedToastIconState();
}

class _AnimatedToastIconState extends State<_AnimatedToastIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // Elastic pop-in when the toast first shows
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.25).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 40.0),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.95).chain(CurveTween(curve: Curves.easeInOut)), weight: 30.0),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 30.0),
    ]).animate(_controller);

    // Gentle pulse glow
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08).chain(CurveTween(curve: Curves.easeInOut)), weight: 50.0),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 50.0),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)));

    // Subtle rotation or spin depending on variant
    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate dynamic shake offset specifically for Error / Warning toasts
        double dx = 0.0;
        if (widget.type == KaloriToastType.error && _controller.value < 0.6) {
          dx = math.sin(_controller.value * math.pi * 10) * 4.0 * (1.0 - (_controller.value / 0.6));
        }

        final double scale = _scaleAnimation.value * (_controller.value > 0.5 ? _pulseAnimation.value : 1.0);

        return Transform.translate(
          offset: Offset(dx, 0.0),
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: widget.type == KaloriToastType.info ? _rotationAnimation.value * math.pi * 2 : _rotationAnimation.value,
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: KaloriRadius.borderMd,
                  boxShadow: [
                    BoxShadow(
                      color: widget.iconColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 24.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Internal animated progress indicator for auto-closing toasts.
class _ToastProgressBar extends StatefulWidget {
  final Duration duration;
  final Color color;

  const _ToastProgressBar({
    required this.duration,
    required this.color,
  });

  @override
  State<_ToastProgressBar> createState() => _ToastProgressBarState();
}

class _ToastProgressBarState extends State<_ToastProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: 1.0 - _progressController.value,
            child: Container(
              height: 3.0,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.7),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2.0)),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Helper manager to easily launch animated custom toasts from anywhere in Kalori.
class KaloriToast {
  KaloriToast._();

  /// Displays a custom animated toast notification across any active screen.
  static void show({
    required String title,
    String? message,
    KaloriToastType type = KaloriToastType.info,
    IconData? customIcon,
    Color? customIconColor,
    Color? customBackgroundColor,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    bool showProgress = true,
  }) {
    // Dismiss any open snackbar first to avoid stacking clutter
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.rawSnackbar(
      snackPosition: position,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: duration,
      animationDuration: const Duration(milliseconds: 350),
      messageText: AnimatedKaloriToastWidget(
        title: title,
        message: message,
        type: type,
        customIcon: customIcon,
        customIconColor: customIconColor,
        customBackgroundColor: customBackgroundColor,
        actionLabel: actionLabel,
        onAction: () {
          if (Get.isSnackbarOpen) {
            Get.closeCurrentSnackbar();
          }
          onAction?.call();
        },
        onDismiss: onDismiss,
        progressDuration: showProgress ? duration : null,
      ),
    );
  }

  /// Displays a green [KaloriToastType.success] animated checkmark toast.
  static void showSuccess({
    required String title,
    String? message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      title: title,
      message: message,
      type: KaloriToastType.success,
      position: position,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Displays a red [KaloriToastType.error] animated shaking warning toast.
  static void showError({
    required String title,
    String? message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      title: title,
      message: message,
      type: KaloriToastType.error,
      position: position,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Displays an amber [KaloriToastType.warning] animated alert toast.
  static void showWarning({
    required String title,
    String? message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      title: title,
      message: message,
      type: KaloriToastType.warning,
      position: position,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Displays a blue [KaloriToastType.info] animated info toast.
  static void showInfo({
    required String title,
    String? message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      title: title,
      message: message,
      type: KaloriToastType.info,
      position: position,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
