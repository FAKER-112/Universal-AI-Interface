import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/presentation/providers/provider_config_provider.dart';
import 'package:ai_client_service/presentation/providers/theme_provider.dart';
import 'package:ai_client_service/services/provider_factory.dart';

/// Settings screen with appearance controls and provider configuration form.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _urlCtrl;
  late TextEditingController _keyCtrl;
  late TextEditingController _modelCtrl;

  bool _obscureKey = true;
  bool _saved = false;
  bool _testing = false;

  static const _fontOptions = [
    'Inter',
    'Roboto',
    'Roboto Mono',
    'JetBrains Mono',
    'Fira Code',
    'Source Sans 3',
  ];

  @override
  void initState() {
    super.initState();
    final config = ref.read(providerConfigProvider);
    _nameCtrl = TextEditingController(text: config.name);
    _urlCtrl = TextEditingController(text: config.baseUrl);
    _keyCtrl = TextEditingController(text: config.apiKey);
    _modelCtrl = TextEditingController(text: config.modelName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _urlCtrl.dispose();
    _keyCtrl.dispose();
    _modelCtrl.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) return 'URL is required';
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        (!uri.isScheme('http') && !uri.isScheme('https')) ||
        uri.host.isEmpty) {
      return 'Enter a valid http:// or https:// URL';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final currentConfig = ref.read(providerConfigProvider);
    final updated = currentConfig.copyWith(
      name: _nameCtrl.text.trim(),
      baseUrl: _urlCtrl.text.trim(),
      apiKey: _keyCtrl.text.trim(),
      modelName: _modelCtrl.text.trim(),
    );

    ref.read(providerConfigProvider.notifier).update(updated);

    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Provider configuration saved'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _testing = true);

    // Build a temporary config from the form values
    final currentConfig = ref.read(providerConfigProvider);
    final testConfig = currentConfig.copyWith(
      name: _nameCtrl.text.trim(),
      baseUrl: _urlCtrl.text.trim(),
      apiKey: _keyCtrl.text.trim(),
      modelName: _modelCtrl.text.trim(),
    );

    try {
      final repo = RepositoryFactory.create(testConfig);
      final models = await repo.fetchModels();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connection successful! Found ${models.length} models.',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection failed: $msg'),
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

    // Sync controllers with the new defaults
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
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final providerConfig = ref.watch(providerConfigProvider);

    final isDarkActive =
        settings.themeMode == ThemeMode.dark ||
        (settings.themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===========================================================
                // APPEARANCE
                // ===========================================================
                _SectionHeader(
                  icon: Icons.palette_outlined,
                  label: 'Appearance',
                ),
                const SizedBox(height: 6),
                Text(
                  'Customize the look and feel of the application.',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 20),

                // -- Theme Mode --
                _FieldLabel('Theme Mode'),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.brightness_auto, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode_outlined, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode_outlined, size: 18),
                      ),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (s) => notifier.setThemeMode(s.first),
                    showSelectedIcon: false,
                  ),
                ),
                const SizedBox(height: 20),

                // -- Dark variant --
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: isDarkActive
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Dark Theme'),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<DarkVariant>(
                          segments: const [
                            ButtonSegment(
                              value: DarkVariant.dim,
                              label: Text('Dim'),
                              icon: Icon(Icons.nights_stay_outlined, size: 18),
                            ),
                            ButtonSegment(
                              value: DarkVariant.lightsOut,
                              label: Text('Lights Out'),
                              icon: Icon(Icons.brightness_1_outlined, size: 18),
                            ),
                          ],
                          selected: {settings.darkVariant},
                          onSelectionChanged: (s) =>
                              notifier.setDarkVariant(s.first),
                          showSelectedIcon: false,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),

                // -- Font Family --
                _FieldLabel('Font Family'),
                const SizedBox(height: 8),
                _FontFamilySelector(
                  currentFamily: settings.fontFamily,
                  options: _fontOptions,
                  onChanged: notifier.setFontFamily,
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),

                // ===========================================================
                // PROVIDER CONFIGURATION
                // ===========================================================
                _SectionHeader(
                  icon: Icons.dns_outlined,
                  label: 'Provider Configuration',
                ),
                const SizedBox(height: 6),
                Text(
                  'Configure the connection to your AI provider.',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 28),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Provider Type
                      _FieldLabel('Provider Type'),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ProviderType>(
                          segments: const [
                            ButtonSegment(
                              value: ProviderType.openai,
                              label: Text('OpenAI'),
                              icon: Icon(Icons.cloud_outlined, size: 18),
                            ),
                            ButtonSegment(
                              value: ProviderType.ollama,
                              label: Text('Ollama'),
                              icon: Icon(Icons.computer, size: 18),
                            ),
                          ],
                          selected: {providerConfig.type},
                          onSelectionChanged: (s) => _onTypeChanged(s.first),
                          showSelectedIcon: false,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Provider Name
                      _FieldLabel('Provider Name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameCtrl,
                        validator: _validateRequired,
                        decoration: const InputDecoration(
                          hintText: 'e.g. OpenAI, Ollama',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Base URL
                      _FieldLabel('Base URL'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _urlCtrl,
                        validator: _validateUrl,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          hintText: providerConfig.type == ProviderType.openai
                              ? 'https://api.openai.com/v1'
                              : 'http://localhost:11434',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // API Key (shown only for OpenAI)
                      if (providerConfig.type == ProviderType.openai) ...[
                        _FieldLabel('API Key'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _keyCtrl,
                          obscureText: _obscureKey,
                          validator: providerConfig.type == ProviderType.openai
                              ? _validateRequired
                              : null,
                          decoration: InputDecoration(
                            hintText: 'sk-...',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureKey
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureKey = !_obscureKey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Model Name
                      _FieldLabel('Model Name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _modelCtrl,
                        validator: _validateRequired,
                        decoration: InputDecoration(
                          hintText: providerConfig.type == ProviderType.openai
                              ? 'e.g. gpt-4o, gpt-4o-mini'
                              : 'e.g. llama3, mistral, codellama',
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action buttons row
                      Row(
                        children: [
                          // Test Connection
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _testing ? null : _testConnection,
                              icon: _testing
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: cs.primary,
                                      ),
                                    )
                                  : const Icon(Icons.wifi_tethering, size: 18),
                              label: Text(
                                _testing ? 'Testing...' : 'Test Connection',
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Save
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: _saved
                                  ? FilledButton.icon(
                                      key: const ValueKey('saved'),
                                      onPressed: null,
                                      icon: const Icon(
                                        Icons.check_circle,
                                        size: 18,
                                      ),
                                      label: const Text('Saved'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: cs.primaryContainer,
                                        foregroundColor: cs.onPrimaryContainer,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    )
                                  : FilledButton(
                                      key: const ValueKey('save'),
                                      onPressed: _save,
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Save Configuration'),
                                    ),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: cs.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          label,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
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
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Font family selector using radio-style list tiles.
class _FontFamilySelector extends StatelessWidget {
  const _FontFamilySelector({
    required this.currentFamily,
    required this.options,
    required this.onChanged,
  });

  final String currentFamily;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < options.length; i++) ...[
            ListTile(
              title: Text(
                options[i],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: options[i] == currentFamily
                  ? Icon(Icons.check, size: 20, color: cs.primary)
                  : null,
              dense: true,
              visualDensity: VisualDensity.compact,
              selected: options[i] == currentFamily,
              selectedTileColor: cs.primary.withValues(alpha: 0.08),
              onTap: () => onChanged(options[i]),
            ),
            if (i < options.length - 1)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: cs.outlineVariant.withValues(alpha: 0.2),
              ),
          ],
        ],
      ),
    );
  }
}
