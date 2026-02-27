import 'package:isar/isar.dart';

part 'isar_provider_config.g.dart';

/// Isar collection that persists saved model provider configurations.
///
/// API keys are NOT stored here; they live in FlutterSecureStorage.
@collection
class IsarProviderConfig {
  Id id = Isar.autoIncrement;

  /// Application-level unique identifier (UUID).
  @Index(unique: true)
  late String configId;

  late String name;

  /// "openai" or "ollama".
  late String type;

  late String baseUrl;

  late String modelName;

  String description = '';

  String organization = '';

  // --- Model parameters ---

  double temperature = 0.7;

  int maxTokens = 4096;

  double topP = 1.0;

  double frequencyPenalty = 0.0;

  double presencePenalty = 0.0;

  int timeout = 30;

  int maxRetries = 3;

  bool isPinned = true;
}
