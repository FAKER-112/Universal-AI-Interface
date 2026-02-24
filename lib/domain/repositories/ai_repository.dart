import 'package:ai_client_service/data/models/chat_message.dart';

/// Contract for any AI provider backend (real or mock).
abstract class AIRepository {
  /// Sends the conversation [history] plus a new [prompt] to the AI provider
  /// and returns a stream of text chunks (tokens) as they arrive.
  Stream<String> sendMessage(List<ChatMessage> history, String prompt);

  /// Returns the list of model names available from this provider.
  Future<List<String>> fetchModels();
}
