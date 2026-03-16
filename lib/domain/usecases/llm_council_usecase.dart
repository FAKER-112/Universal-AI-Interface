import 'dart:async';

import 'package:ai_client_service/data/models/chat_message.dart';
import 'package:ai_client_service/data/models/council_member.dart';
import 'package:ai_client_service/domain/repositories/ai_repository.dart';

class LLMCouncilUsecase {
  LLMCouncilUsecase(this._repository);
  final AIRepository _repository;

  /// Runs the user prompt through the LLM Council and returns the final synthesized answer.
  Stream<String> executeCouncil(
    List<ChatMessage> history,
    String finalUserPrompt,
    List<CouncilMember> councilMembers,
  ) async* {
    if (councilMembers.isEmpty) {
      // Fallback if no members are configured
      yield* _repository.sendMessage(history, finalUserPrompt);
      return;
    }

    // Yield our custom <council> tag instead of <think> to enable custom UI parsing
    yield "<council>\nRouting prompt...\n";

    // Step 1: Parallel Calls
    final futures = councilMembers.map((member) async {
      final modifiedPrompt =
          "${member.systemPrompt}\n\nUser query: $finalUserPrompt";
      final stream = _repository.sendMessage([], modifiedPrompt);
      final buffer = StringBuffer();
      await for (final token in stream) {
        buffer.write(token);
      }
      return "||${member.name}||${buffer.toString().trim()}";
    });

    yield "Model responses incoming...\n";

    final councilResponses = await Future.wait(futures);

    // Step 2: Aggregation
    final aggregatorContext = StringBuffer();
    aggregatorContext.writeln("The user originally asked: $finalUserPrompt");
    aggregatorContext.writeln(
      "\nHere are the opinions of the council members:\n",
    );
    for (final response in councilResponses) {
      aggregatorContext.writeln(response);
      yield "$response\n";
    }

    // Close the council block now that synthesis starts
    yield "Aggregating insights...\n</council>\n\n";

    final synthesizePrompt =
        "${aggregatorContext.toString()}\n\nPlease synthesize these perspectives and formulate the final best answer directly addressing the original user query.";

    // Step 3: Summarizer LLM
    final finalStream = _repository.sendMessage(history, synthesizePrompt);
    yield* finalStream;
  }
}
