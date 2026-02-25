import 'package:ai_client_service/data/models/provider.dart';
import 'package:ai_client_service/domain/repositories/ai_repository.dart';
import 'package:ai_client_service/services/ai_adapters/openai_adapter.dart';
import 'package:ai_client_service/services/ai_adapters/ollama_adapter.dart';

/// Creates the correct [AIRepository] based on the provider configuration.
class RepositoryFactory {
  const RepositoryFactory._();

  /// Returns an [AIRepository] for the given [config].
  static AIRepository create(ProviderConfig config) {
    return switch (config.type) {
      ProviderType.openai => OpenAIRepository(
        baseUrl: config.baseUrl,
        apiKey: config.apiKey,
        model: config.modelName,
      ),
      ProviderType.ollama => OllamaRepository(
        baseUrl: config.baseUrl,
        model: config.modelName,
      ),
    };
  }
}
