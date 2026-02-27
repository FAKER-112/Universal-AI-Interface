import 'package:flutter/material.dart';

import 'package:ai_client_service/data/models/provider.dart';

/// A model selector dropdown that displays pinned models in a primary panel,
/// with an expandable "More models" section for unpinned ones.
///
/// Match the Qwen-style reference design with model name, description,
/// checkmark on the active model, and pin/unpin support.
class ModelSelector extends StatefulWidget {
  const ModelSelector({
    super.key,
    required this.currentConfig,
    required this.allConfigs,
    required this.onModelChanged,
    required this.onTogglePin,
    this.onEditCurrent,
    this.onSaveAsPreset,
  });

  final ProviderConfig currentConfig;
  final List<ProviderConfig> allConfigs;
  final ValueChanged<ProviderConfig> onModelChanged;
  final ValueChanged<String> onTogglePin;
  final VoidCallback? onEditCurrent;
  final VoidCallback? onSaveAsPreset;

  @override
  State<ModelSelector> createState() => _ModelSelectorState();
}

class _ModelSelectorState extends State<ModelSelector> {
  final _overlayController = OverlayPortalController();
  final _link = LayerLink();

  void _toggle() {
    if (_overlayController.isShowing) {
      _overlayController.hide();
    } else {
      _overlayController.show();
    }
  }

  void _close() {
    _overlayController.hide();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (_) => _buildOverlay(context),
        child: GestureDetector(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.memory, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  widget.currentConfig.modelName,
                  style: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: [
        // Dismiss barrier
        Positioned.fill(
          child: GestureDetector(
            onTap: _close,
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
        ),

        // Dropdown panel
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 6),
          child: _ModelDropdownPanel(
            allConfigs: widget.allConfigs,
            currentConfig: widget.currentConfig,
            onModelSelected: (config) {
              widget.onModelChanged(config);
              _close();
            },
            onTogglePin: widget.onTogglePin,
            onEditCurrent: widget.onEditCurrent != null
                ? () {
                    _close();
                    widget.onEditCurrent!();
                  }
                : null,
            onSaveAsPreset: widget.onSaveAsPreset != null
                ? () {
                    _close();
                    widget.onSaveAsPreset!();
                  }
                : null,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dropdown Panel (StatefulWidget -- manages expand/collapse internally so
// toggling the section does NOT trigger a rebuild of the host overlay tree,
// which was the root cause of the brief red-screen glitch.)
// ---------------------------------------------------------------------------

class _ModelDropdownPanel extends StatefulWidget {
  const _ModelDropdownPanel({
    required this.allConfigs,
    required this.currentConfig,
    required this.onModelSelected,
    required this.onTogglePin,
    this.onEditCurrent,
    this.onSaveAsPreset,
  });

  final List<ProviderConfig> allConfigs;
  final ProviderConfig currentConfig;
  final ValueChanged<ProviderConfig> onModelSelected;
  final ValueChanged<String> onTogglePin;
  final VoidCallback? onEditCurrent;
  final VoidCallback? onSaveAsPreset;

  @override
  State<_ModelDropdownPanel> createState() => _ModelDropdownPanelState();
}

class _ModelDropdownPanelState extends State<_ModelDropdownPanel> {
  bool _expanded = false;

  List<ProviderConfig> get _pinnedModels =>
      widget.allConfigs.where((c) => c.isPinned).toList();

  List<ProviderConfig> get _unpinnedModels =>
      widget.allConfigs.where((c) => !c.isPinned).toList();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final pinned = _pinnedModels;
    final unpinned = _unpinnedModels;

    return Material(
      elevation: 12,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(14),
      color: cs.surfaceContainer,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 360,
          maxHeight: 520,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: Row(
                  children: [
                    Text(
                      'Model',
                      style: tt.labelMedium?.copyWith(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              ),

              // Pinned models
              ...pinned.map(
                (config) => _ModelRow(
                  config: config,
                  isSelected: config.id == widget.currentConfig.id,
                  onTap: () => widget.onModelSelected(config),
                  onTogglePin: () => widget.onTogglePin(config.id),
                ),
              ),

              // "Expand more models" button
              if (unpinned.isNotEmpty) ...[
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _expanded = !_expanded),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.apps,
                            size: 16,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Expand more models',
                              style: tt.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: _expanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // Expanded unpinned models
              if (_expanded && unpinned.isNotEmpty) ...[
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.outlineVariant.withValues(alpha: 0.2),
                ),
                ...unpinned.map(
                  (config) => _ModelRow(
                    config: config,
                    isSelected: config.id == widget.currentConfig.id,
                    onTap: () => widget.onModelSelected(config),
                    onTogglePin: () => widget.onTogglePin(config.id),
                  ),
                ),
              ],

              // Actions divider
              if (widget.onEditCurrent != null ||
                  widget.onSaveAsPreset != null) ...[
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
                if (widget.onEditCurrent != null)
                  _ActionRow(
                    icon: Icons.tune,
                    label: 'Edit current',
                    onTap: widget.onEditCurrent!,
                  ),
                if (widget.onSaveAsPreset != null)
                  _ActionRow(
                    icon: Icons.save_outlined,
                    label: 'Save as preset',
                    onTap: widget.onSaveAsPreset!,
                  ),
              ],

              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Model Row
// ---------------------------------------------------------------------------

class _ModelRow extends StatelessWidget {
  const _ModelRow({
    required this.config,
    required this.isSelected,
    required this.onTap,
    required this.onTogglePin,
  });

  final ProviderConfig config;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Model info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.name,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? cs.primary : cs.onSurface,
                      ),
                    ),
                    if (config.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        config.description,
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.55),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Pin icon
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  onPressed: onTogglePin,
                  padding: EdgeInsets.zero,
                  iconSize: 14,
                  tooltip: config.isPinned ? 'Unpin model' : 'Pin model',
                  icon: Icon(
                    config.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: config.isPinned
                        ? cs.primary.withValues(alpha: 0.7)
                        : cs.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                ),
              ),

              // Checkmark
              if (isSelected) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.check, size: 18, color: cs.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action Row
// ---------------------------------------------------------------------------

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 16, color: cs.onSurfaceVariant),
              const SizedBox(width: 10),
              Text(label, style: tt.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
