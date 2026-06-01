import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = "Search...",
    this.onClear,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChanged);
    _showClearButton = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChanged);
    }
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClearButton != hasText) {
      setState(() {
        _showClearButton = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Harmonized premium search colors matching modern dashboards (e.g. Stripe, Slack)
    final fillColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final hintColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const focusColor = Color(0xFF00BE93); // Beautiful brand green

    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: fontFamilyRegular.size13.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fillColor,
        hintText: widget.hintText,
        hintStyle: fontFamilyRegular.size13.copyWith(color: hintColor),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          size: 20,
        ),
        suffixIcon: _showClearButton
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                onPressed: () {
                  _controller.clear();
                  if (widget.onChanged != null) {
                    widget.onChanged!("");
                  }
                  if (widget.onClear != null) {
                    widget.onClear!();
                  }
                },
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: focusColor, width: 1.5),
        ),
      ),
    );
  }
}
