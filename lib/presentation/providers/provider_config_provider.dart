import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/core/security/secure_storage.dart';
import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/main.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Holds the active provider configuration. Changing this triggers a new
/// AIRepository to be created via the factory.
///
/// API keys are loaded from SecureStorage and saved back when changed.
class ProviderConfigNotifier extends StateNotifier<ProviderConfig> {
  ProviderConfigNotifier(this._secureStorage)
    : super(
        const ProviderConfig(
          id: 'default',
          name: 'OpenAI',
          type: ProviderType.openai,
          baseUrl: 'https://api.openai.com/v1',
          apiKey: '',
          modelName: 'gpt-4o-mini',
        ),
      ) {
    _loadApiKey();
  }

  final SecureStorageDataSource _secureStorage;

  /// Load the API key from secure storage for the current config.
  Future<void> _loadApiKey() async {
    final key = await _secureStorage.readApiKey(state.id);
    if (key != null && key.isNotEmpty) {
      state = state.copyWith(apiKey: key);
    }
  }

  void update(ProviderConfig config) {
    state = config;
    // Load the API key for the new config from secure storage.
    _loadApiKeyFor(config.id);
  }

  Future<void> _loadApiKeyFor(String configId) async {
    final key = await _secureStorage.readApiKey(configId);
    if (key != null && key.isNotEmpty && state.id == configId) {
      state = state.copyWith(apiKey: key);
    }
  }

  /// Sets the API key in state AND persists it to secure storage.
  Future<void> setApiKey(String key) async {
    state = state.copyWith(apiKey: key);
    await _secureStorage.writeApiKey(state.id, key);
  }

  void setModel(String model) {
    state = state.copyWith(modelName: model);
  }

  void setType(ProviderType type) {
    // When switching type, also switch the default base URL
    final baseUrl = switch (type) {
      ProviderType.openai => 'https://api.openai.com/v1',
      ProviderType.ollama => 'http://localhost:11434',
    };

    final name = switch (type) {
      ProviderType.openai => 'OpenAI',
      ProviderType.ollama => 'Ollama',
    };

    final model = switch (type) {
      ProviderType.openai => 'gpt-4o-mini',
      ProviderType.ollama => 'llama3',
    };

    state = state.copyWith(
      type: type,
      baseUrl: baseUrl,
      name: name,
      modelName: model,
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final providerConfigProvider =
    StateNotifierProvider<ProviderConfigNotifier, ProviderConfig>((ref) {
      final secureStorage = ref.watch(secureStorageProvider);
      return ProviderConfigNotifier(secureStorage);
    });
