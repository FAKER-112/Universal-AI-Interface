import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/data/models/provider.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Holds the active provider configuration. Changing this triggers a new
/// AIRepository to be created via the factory.
class ProviderConfigNotifier extends StateNotifier<ProviderConfig> {
  ProviderConfigNotifier()
    : super(
        const ProviderConfig(
          id: 'default',
          name: 'OpenAI',
          type: ProviderType.openai,
          baseUrl: 'https://api.openai.com/v1',
          apiKey: '',
          modelName: 'gpt-4o-mini',
        ),
      );

  void update(ProviderConfig config) {
    state = config;
  }

  void setApiKey(String key) {
    state = state.copyWith(apiKey: key);
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
      return ProviderConfigNotifier();
    });
