import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

/// Supported AI provider backends.
enum ProviderType {
  @JsonValue('openai')
  openai,
  @JsonValue('ollama')
  ollama,
}

/// Configuration for an AI provider (e.g. OpenAI, Ollama).
@freezed
abstract class ProviderConfig with _$ProviderConfig {
  const factory ProviderConfig({
    required String id,
    required String name,
    required ProviderType type,
    required String baseUrl,
    @Default('') String apiKey,
    required String modelName,
  }) = _ProviderConfig;

  factory ProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$ProviderConfigFromJson(json);
}
