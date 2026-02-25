import 'package:flutter/material.dart';

/// Dropdown chip that displays the current AI model and allows switching.
class ModelSelector extends StatelessWidget {
  const ModelSelector({
    super.key,
    required this.currentModel,
    required this.availableModels,
    required this.onModelChanged,
  });

  final String currentModel;
  final List<String> availableModels;
  final ValueChanged<String> onModelChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return PopupMenuButton<String>(
      onSelected: onModelChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => availableModels
          .map(
            (model) => PopupMenuItem<String>(
              value: model,
              child: Row(
                children: [
                  Icon(
                    Icons.memory,
                    size: 16,
                    color: model == currentModel
                        ? cs.primary
                        : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    model,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: model == currentModel
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: model == currentModel ? cs.primary : cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (model == currentModel)
                    Icon(Icons.check, size: 16, color: cs.primary),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.memory, size: 16, color: cs.primary),
            const SizedBox(width: 6),
            Text(
              currentModel,
              style: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
