import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/presentation/providers/provider_config_provider.dart';
import 'package:ai_client_service/services/provider_factory.dart';

/// A slide-out right-side panel for editing AI model configuration.
///
/// Matches the "Edit Component" reference design with Component Details,
/// Model Configuration, and Model Parameters sections.
class ModelConfigPanel extends ConsumerStatefulWidget {
  const ModelConfigPanel({super.key});

  @override
  ConsumerState<ModelConfigPanel> createState() => _ModelConfigPanelState();
}

class _ModelConfigPanelState extends ConsumerState<ModelConfigPanel> {
  final _formKey = GlobalKey<FormState>();

  // Component Details
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;

  // Model Configuration
  late TextEditingController _modelCtrl;
  late TextEditingController _keyCtrl;
  late TextEditingController _orgCtrl;
  late TextEditingController _urlCtrl;
  late TextEditingController _timeoutCtrl;
  late TextEditingController _retriesCtrl;

  // Model Parameters
  late TextEditingController _tempCtrl;
  late TextEditingController _maxTokensCtrl;
  late TextEditingController _topPCtrl;
  late TextEditingController _freqPenCtrl;
  late TextEditingController _presPenCtrl;

  bool _obscureKey = true;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _syncFromConfig(ref.read(providerConfigProvider));
  }

  void _syncFromConfig(ProviderConfig c) {
    _nameCtrl = TextEditingController(text: c.name);
    _descCtrl = TextEditingController(text: c.description);
    _modelCtrl = TextEditingController(text: c.modelName);
    _keyCtrl = TextEditingController(text: c.apiKey);
    _orgCtrl = TextEditingController(text: c.organization);
    _urlCtrl = TextEditingController(text: c.baseUrl);
    _timeoutCtrl = TextEditingController(text: c.timeout.toString());
    _retriesCtrl = TextEditingController(text: c.maxRetries.toString());
    _tempCtrl = TextEditingController(text: c.temperature.toString());
    _maxTokensCtrl = TextEditingController(text: c.maxTokens.toString());
    _topPCtrl = TextEditingController(text: c.topP.toString());
    _freqPenCtrl = TextEditingController(text: c.frequencyPenalty.toString());
    _presPenCtrl = TextEditingController(text: c.presencePenalty.toString());
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _descCtrl,
      _modelCtrl,
      _keyCtrl,
      _orgCtrl,
      _urlCtrl,
      _timeoutCtrl,
      _retriesCtrl,
      _tempCtrl,
      _maxTokensCtrl,
      _topPCtrl,
      _freqPenCtrl,
      _presPenCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  ProviderConfig _buildConfig() {
    final current = ref.read(providerConfigProvider);
    return current.copyWith(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      modelName: _modelCtrl.text.trim(),
      apiKey: _keyCtrl.text.trim(),
      organization: _orgCtrl.text.trim(),
      baseUrl: _urlCtrl.text.trim(),
      timeout: int.tryParse(_timeoutCtrl.text) ?? 30,
      maxRetries: int.tryParse(_retriesCtrl.text) ?? 3,
      temperature: double.tryParse(_tempCtrl.text) ?? 0.7,
      maxTokens: int.tryParse(_maxTokensCtrl.text) ?? 4096,
      topP: double.tryParse(_topPCtrl.text) ?? 1.0,
      frequencyPenalty: double.tryParse(_freqPenCtrl.text) ?? 0.0,
      presencePenalty: double.tryParse(_presPenCtrl.text) ?? 0.0,
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(providerConfigProvider.notifier).update(_buildConfig());
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Configuration saved'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _testing = true);
    try {
      final repo = RepositoryFactory.create(_buildConfig());
      final models = await repo.fetchModels();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected! Found ${models.length} models.'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed: ${e.toString().replaceFirst("Exception: ", "")}',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  void _onTypeChanged(ProviderType? type) {
    if (type == null) return;
    ref.read(providerConfigProvider.notifier).setType(type);
    final config = ref.read(providerConfigProvider);
    _nameCtrl.text = config.name;
    _urlCtrl.text = config.baseUrl;
    _modelCtrl.text = config.modelName;
    _keyCtrl.text = config.apiKey;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final config = ref.watch(providerConfigProvider);

    return Container(
      width: 480,
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- Header ----
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                  style: IconButton.styleFrom(
                    backgroundColor: cs.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Edit Component',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // ---- Body ----
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Title row with Test button
                  Row(
                    children: [
                      Text(
                        _nameCtrl.text.isEmpty ? 'New Model' : _nameCtrl.text,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: _testing ? null : _testConnection,
                        icon: _testing
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: cs.primary,
                                ),
                              )
                            : Icon(
                                Icons.play_circle_outline,
                                size: 16,
                                color: cs.primary,
                              ),
                        label: Text(_testing ? 'Testing...' : 'Test'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          textStyle: tt.labelSmall,
                          side: BorderSide(color: cs.outlineVariant),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =============================================
                  // Component Details
                  // =============================================
                  _SectionFrame(
                    label: 'Component Details',
                    children: [
                      // Provider Type selector
                      _FieldLabel('Type'),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ProviderType>(
                          segments: const [
                            ButtonSegment(
                              value: ProviderType.openai,
                              label: Text('OpenAI'),
                              icon: Icon(Icons.cloud_outlined, size: 16),
                            ),
                            ButtonSegment(
                              value: ProviderType.ollama,
                              label: Text('Ollama'),
                              icon: Icon(Icons.computer, size: 16),
                            ),
                          ],
                          selected: {config.type},
                          onSelectionChanged: (s) => _onTypeChanged(s.first),
                          showSelectedIcon: false,
                          style: SegmentedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _FieldLabel('Name'),
                      const SizedBox(height: 6),
                      _Input(controller: _nameCtrl, hint: 'New Model'),

                      const SizedBox(height: 16),

                      _FieldLabel('Description'),
                      const SizedBox(height: 6),
                      _Input(
                        controller: _descCtrl,
                        hint: 'OpenAI GPT-4o-mini',
                        maxLines: 3,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =============================================
                  // Model Configuration
                  // =============================================
                  _SectionFrame(
                    label: 'Model Configuration',
                    children: [
                      _LabelWithTooltip(
                        'Model',
                        'The model ID to use for completions',
                      ),
                      const SizedBox(height: 6),
                      _Input(
                        controller: _modelCtrl,
                        hint: config.type == ProviderType.openai
                            ? 'gpt-4o-mini'
                            : 'llama3',
                      ),

                      if (config.type == ProviderType.openai) ...[
                        const SizedBox(height: 16),
                        _LabelWithTooltip('API Key', 'Your OpenAI API key'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _keyCtrl,
                          obscureText: _obscureKey,
                          style: tt.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'sk-...',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: cs.outlineVariant),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: cs.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureKey
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureKey = !_obscureKey),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        _LabelWithTooltip(
                          'Organization',
                          'Optional OpenAI organization ID',
                        ),
                        const SizedBox(height: 6),
                        _Input(controller: _orgCtrl),
                      ],

                      const SizedBox(height: 16),
                      _LabelWithTooltip('Base URL', 'API endpoint base URL'),
                      const SizedBox(height: 6),
                      _Input(
                        controller: _urlCtrl,
                        hint: config.type == ProviderType.openai
                            ? 'https://api.openai.com/v1'
                            : 'http://localhost:11434',
                      ),

                      const SizedBox(height: 16),
                      _LabelWithTooltip(
                        'Timeout',
                        'Connection timeout in seconds',
                      ),
                      const SizedBox(height: 6),
                      _Input(controller: _timeoutCtrl, isNumber: true),

                      const SizedBox(height: 16),
                      _LabelWithTooltip(
                        'Max Retries',
                        'Maximum number of retry attempts on failure',
                      ),
                      const SizedBox(height: 6),
                      _Input(controller: _retriesCtrl, isNumber: true),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =============================================
                  // Model Parameters
                  // =============================================
                  _SectionFrame(
                    label: 'Model Parameters',
                    children: [
                      _LabelWithTooltip(
                        'Temperature',
                        'Controls randomness. 0 = deterministic, 2 = very random',
                      ),
                      const SizedBox(height: 6),
                      _Input(controller: _tempCtrl, isDecimal: true),

                      const SizedBox(height: 16),
                      _LabelWithTooltip(
                        'Max Tokens',
                        'Maximum number of tokens to generate',
                      ),
                      const SizedBox(height: 6),
                      _Input(controller: _maxTokensCtrl, isNumber: true),

                      const SizedBox(height: 16),
                      _LabelWithTooltip(
                        'Top P',
                        'Nucleus sampling threshold (0-1)',
                      ),
                      const SizedBox(height: 6),
                      _Input(controller: _topPCtrl, isDecimal: true),

                      const SizedBox(height: 16),
                      _LabelWithTooltip(
                        'Frequency Penalty',
                        'Penalizes tokens based on frequency (-2 to 2)',
                      ),
                      const SizedBox(height: 6),
                      _Input(controller: _freqPenCtrl, isDecimal: true),

                      const SizedBox(height: 16),
                      _LabelWithTooltip(
                        'Presence Penalty',
                        'Penalizes tokens based on presence (-2 to 2)',
                      ),
                      const SizedBox(height: 6),
                      _Input(controller: _presPenCtrl, isDecimal: true),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ---- Footer ----
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

/// Field group with a bordered outline and label.
class _SectionFrame extends StatelessWidget {
  const _SectionFrame({required this.label, required this.children});
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.primary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _LabelWithTooltip extends StatelessWidget {
  const _LabelWithTooltip(this.text, this.tooltip);
  final String text;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          text,
          style: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Tooltip(
          message: tooltip,
          child: Icon(
            Icons.help_outline,
            size: 14,
            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.isNumber = false,
    this.isDecimal = false,
  });

  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final bool isNumber;
  final bool isDecimal;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber || isDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : null,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Public helper to show the panel
// ---------------------------------------------------------------------------

/// Opens the model configuration panel as a modal side-sheet from the right.
void showModelConfigPanel(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Model Config',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (ctx, anim, secondAnim) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          elevation: 16,
          shadowColor: Colors.black26,
          child: const ModelConfigPanel(),
        ),
      );
    },
    transitionBuilder: (ctx, anim, secondAnim, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
      return SlideTransition(position: slide, child: child);
    },
  );
}
