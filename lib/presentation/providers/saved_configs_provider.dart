import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/data/models/provider.dart';

/// Manages a list of saved model configurations that the user can quickly
/// switch between from the model dropdown.
class SavedConfigsNotifier extends StateNotifier<List<ProviderConfig>> {
  SavedConfigsNotifier()
    : super([
        const ProviderConfig(
          id: 'openai-default',
          name: 'GPT-4o mini',
          type: ProviderType.openai,
          baseUrl: 'https://api.openai.com/v1',
          modelName: 'gpt-4o-mini',
        ),
        const ProviderConfig(
          id: 'ollama-default',
          name: 'Llama 3',
          type: ProviderType.ollama,
          baseUrl: 'http://localhost:11434',
          modelName: 'llama3',
        ),
      ]);

  void add(ProviderConfig config) {
    state = [...state, config];
  }

  void remove(String id) {
    state = state.where((c) => c.id != id).toList();
  }

  void update(ProviderConfig config) {
    state = state.map((c) => c.id == config.id ? config : c).toList();
  }
}

final savedConfigsProvider =
    StateNotifierProvider<SavedConfigsNotifier, List<ProviderConfig>>((ref) {
      return SavedConfigsNotifier();
    });
