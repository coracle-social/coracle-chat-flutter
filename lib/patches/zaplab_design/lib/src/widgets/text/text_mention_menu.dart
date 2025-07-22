import 'dart:ui';
import 'package:zaplab_design/zaplab_design.dart';
import 'package:models/models.dart';

class LabTextMentionMenuItem {
  final Profile profile;
  final void Function(EditableTextState) onTap;

  const LabTextMentionMenuItem({
    required this.profile,
    required this.onTap,
  });
}

class LabTextMentionMenu extends StatefulWidget {
  final Offset position;
  final EditableTextState editableTextState;
  final List<LabTextMentionMenuItem>? menuItems;

  const LabTextMentionMenu({
    super.key,
    required this.position,
    required this.editableTextState,
    this.menuItems,
  });

  @override
  State<LabTextMentionMenu> createState() => _LabTextMentionMenuState();
}

class _LabTextMentionMenuState extends State<LabTextMentionMenu> {
  final ScrollController _scrollController = ScrollController();

  double _calculateWidth(BuildContext context) {
    final theme = LabTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width / theme.system.scale;
    final selectionX = widget.position.dx;
    final thirdOfScreen = screenWidth / 3;

    final selectionThird = (selectionX / thirdOfScreen).floor();

    switch (selectionThird) {
      case 0: // Left third
        return screenWidth * 0.5;
      case 1: // Middle third
        return screenWidth * 0.4;
      case 2: // Right third
        return screenWidth * 0.4;
      default:
        return screenWidth * 0.5;
    }
  }

  Offset _calculatePosition(
      BuildContext context, double menuWidth, double menuHeight) {
    final theme = LabTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width / theme.system.scale;
    final selectionX = widget.position.dx;
    final thirdOfScreen = screenWidth / 3;
    final selectionThird = (selectionX / thirdOfScreen).floor();

    // Calculate x offset based on which third of the screen we're in
    final double xOffset = switch (selectionThird) {
      0 => -64, // Left third - align with cursor
      1 => -(menuWidth / 2), // Middle third - center menu
      2 => -menuWidth, // Right third - align right edge with cursor
      _ => 0,
    };

    return Offset(xOffset, -menuHeight);
  }

  Widget _buildMentionItem(LabTextMentionMenuItem item) {
    final theme = LabTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => item.onTap(widget.editableTextState),
        child: LabContainer(
          height: theme.sizes.s38,
          padding: const LabEdgeInsets.symmetric(
            horizontal: LabGapSize.s10,
          ),
          child: Row(
            children: [
              LabProfilePic.s24(item.profile),
              const LabGap.s8(),
              Expanded(
                child: LabText.med14(
                  item.profile.name ?? formatNpub(item.profile.npub),
                  color: theme.colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);
    final items = widget.menuItems ?? [];
    final itemHeight = theme.sizes.s38;
    final menuHeight = items.length <= 4 ? itemHeight * items.length : 168.0;
    final menuWidth = _calculateWidth(context);
    final position = _calculatePosition(context, menuWidth, menuHeight);

    return Transform.translate(
      offset: position,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ClipRRect(
          borderRadius: theme.radius.asBorderRadius().rad8,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Stack(
              children: [
                LabContainer(
                  height: menuHeight,
                  constraints: BoxConstraints(
                    maxWidth: menuWidth,
                    maxHeight: 168.0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colors.white16,
                    borderRadius: theme.radius.asBorderRadius().rad8,
                    border: Border.all(
                      color: theme.colors.white33,
                      width: LabLineThicknessData.normal().thin,
                    ),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final item in items) ...[
                              _buildMentionItem(item),
                              if (item != items.last)
                                const LabDivider.horizontal(),
                            ],
                          ],
                        ),
                      ),
                      if (items.length > 4)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 24,
                          child: LabContainer(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0x00000000),
                                  theme.colors.black33,
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
