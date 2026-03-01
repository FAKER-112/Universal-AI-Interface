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

    // Since we want to use the `<think>` tag UI we just built,
    // we can yield the parallel responses as "thinking" process!
    yield "<think>\nGathering council members...\n";

    // Step 1: Parallel Calls
    final futures = councilMembers.map((member) async {
      final modifiedPrompt =
          "${member.systemPrompt}\n\nUser query: $finalUserPrompt";
      final stream = _repository.sendMessage([], modifiedPrompt);
      final buffer = StringBuffer();
      await for (final token in stream) {
        buffer.write(token);
      }
      return "--- ${member.name}'s perspective ---\n${buffer.toString().trim()}\n";
    });

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

    // Close the thinking block now that synthesis starts
    yield "Synthesizing final answer...\n</think>\n\n";

    final synthesizePrompt =
        "${aggregatorContext.toString()}\n\nPlease synthesize these perspectives and formulate the final best answer directly addressing the original user query.";

    // Step 3: Summarizer LLM
    final finalStream = _repository.sendMessage(history, synthesizePrompt);
    yield* finalStream;
  }
}
