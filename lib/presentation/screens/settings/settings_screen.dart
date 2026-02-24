import 'package:flutter/material.dart';

/// Settings screen with a form to configure an AI provider.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController(text: 'Mock Provider');
  final _urlCtrl = TextEditingController(text: 'https://api.example.com');
  final _keyCtrl = TextEditingController();
  final _modelCtrl = TextEditingController(text: 'mock-model-v1');

  bool _obscureKey = true;
  bool _saved = false;

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
    // For now, just show a snackbar. Persistence comes in a later phase.
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Row(
                    children: [
                      Icon(Icons.dns_outlined, color: cs.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Provider Configuration',
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Configure the connection to your AI provider.',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 28),

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
                    decoration: const InputDecoration(
                      hintText: 'https://api.openai.com/v1',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // API Key
                  _FieldLabel('API Key'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _keyCtrl,
                    obscureText: _obscureKey,
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

                  // Model Name
                  _FieldLabel('Model Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _modelCtrl,
                    validator: _validateRequired,
                    decoration: const InputDecoration(
                      hintText: 'e.g. gpt-4o, llama3',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _saved
                          ? FilledButton.icon(
                              key: const ValueKey('saved'),
                              onPressed: null,
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text('Saved'),
                              style: FilledButton.styleFrom(
                                backgroundColor: cs.primaryContainer,
                                foregroundColor: cs.onPrimaryContainer,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Save Configuration'),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
