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
    @Default('') String description,
    @Default('') String organization,
    // Model parameters
    @Default(0.7) double temperature,
    @Default(4096) int maxTokens,
    @Default(1.0) double topP,
    @Default(0.0) double frequencyPenalty,
    @Default(0.0) double presencePenalty,
    @Default(30) int timeout,
    @Default(3) int maxRetries,
  }) = _ProviderConfig;

  factory ProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$ProviderConfigFromJson(json);
}
