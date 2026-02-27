import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_client_service/data/datasources/chat_local_datasource.dart';
import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/main.dart';

/// Default model presets that are seeded into the database on first launch.
const _defaultConfigs = <ProviderConfig>[
  ProviderConfig(
    id: 'openai-default',
    name: 'GPT-4o mini',
    type: ProviderType.openai,
    baseUrl: 'https://api.openai.com/v1',
    modelName: 'gpt-4o-mini',
    description: 'Fast, affordable small model for lightweight tasks',
    isPinned: true,
  ),
  ProviderConfig(
    id: 'openai-gpt4o',
    name: 'GPT-4o',
    type: ProviderType.openai,
    baseUrl: 'https://api.openai.com/v1',
    modelName: 'gpt-4o',
    description: 'High-intelligence flagship model for complex tasks',
    isPinned: true,
  ),
  ProviderConfig(
    id: 'ollama-default',
    name: 'Llama 3',
    type: ProviderType.ollama,
    baseUrl: 'http://localhost:11434',
    modelName: 'llama3',
    description: 'Open-source model by Meta, great for local inference',
    isPinned: true,
  ),
  ProviderConfig(
    id: 'openai-gpt35',
    name: 'GPT-3.5 Turbo',
    type: ProviderType.openai,
    baseUrl: 'https://api.openai.com/v1',
    modelName: 'gpt-3.5-turbo',
    description: 'Legacy model, fast and cost-effective',
    isPinned: false,
  ),
  ProviderConfig(
    id: 'ollama-llama31',
    name: 'Llama 3.1',
    type: ProviderType.ollama,
    baseUrl: 'http://localhost:11434',
    modelName: 'llama3.1',
    description: 'Latest Llama release with improved reasoning',
    isPinned: false,
  ),
  ProviderConfig(
    id: 'ollama-mistral',
    name: 'Mistral',
    type: ProviderType.ollama,
    baseUrl: 'http://localhost:11434',
    modelName: 'mistral',
    description: 'Efficient 7B model by Mistral AI',
    isPinned: false,
  ),
];

/// Manages a list of saved model configurations that the user can quickly
/// switch between from the model dropdown. Persists to Isar.
class SavedConfigsNotifier extends StateNotifier<List<ProviderConfig>> {
  SavedConfigsNotifier(this._localDb) : super(const []) {
    _loadFromDb();
  }

  final LocalDataSource _localDb;

  /// Loads configs from Isar. If the DB is empty (first launch), seeds it
  /// with the default presets.
  Future<void> _loadFromDb() async {
    var configs = await _localDb.getAllConfigs();
    if (configs.isEmpty) {
      // First launch -- seed defaults.
      for (final c in _defaultConfigs) {
        await _localDb.saveConfig(c);
      }
      configs = _defaultConfigs.toList();
    }
    state = configs;
  }

  Future<void> add(ProviderConfig config) async {
    await _localDb.saveConfig(config);
    state = [...state, config];
  }

  Future<void> remove(String id) async {
    await _localDb.deleteConfig(id);
    state = state.where((c) => c.id != id).toList();
  }

  Future<void> update(ProviderConfig config) async {
    await _localDb.saveConfig(config);
    state = state.map((c) => c.id == config.id ? config : c).toList();
  }

  Future<void> togglePin(String id) async {
    final toggled = state.map((c) {
      if (c.id == id) return c.copyWith(isPinned: !c.isPinned);
      return c;
    }).toList();
    state = toggled;

    // Persist the updated config.
    final updated = toggled.firstWhere((c) => c.id == id);
    await _localDb.saveConfig(updated);
  }
}

final savedConfigsProvider =
    StateNotifierProvider<SavedConfigsNotifier, List<ProviderConfig>>((ref) {
      final localDb = ref.watch(localDataSourceProvider);
      return SavedConfigsNotifier(localDb);
    });
