import 'package:flutter/material.dart';

class ZapExpandableTile extends StatefulWidget {
  final Widget header;
  final Widget expandedChild;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double elevation;
  final Function(bool)? onExpandChanged;
  final bool? isExpanded;
  final Widget? trailingIcon;

  const ZapExpandableTile({
    super.key,
    required this.header,
    required this.expandedChild,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 250),
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.elevation = 2,
    this.onExpandChanged,
    this.isExpanded,
    this.trailingIcon,
  });

  @override
  State<ZapExpandableTile> createState() => _ZapExpandableTileState();
}

class _ZapExpandableTileState extends State<ZapExpandableTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(ZapExpandableTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != null && widget.isExpanded != _isExpanded) {
      setState(() {
        _isExpanded = widget.isExpanded!;
      });
    }
  }

  void _toggleExpanded() {
    final newExpandedState = !_isExpanded;
    setState(() => _isExpanded = newExpandedState);
    widget.onExpandChanged?.call(newExpandedState);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(12),
      color: widget.backgroundColor,
      child: InkWell(
        onTap: _toggleExpanded,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: widget.header),
                  widget.trailingIcon ??
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                ],
              ),
              // ANIMATED EXPANSION
              AnimatedCrossFade(
                duration: widget.animationDuration,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: widget.expandedChild,
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }
}