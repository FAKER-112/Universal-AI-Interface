import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:ai_client_service/main.dart';
import 'package:ai_client_service/data/models/council_member.dart';

const kCouncilMembersKey = 'llm_council_members';

class CouncilMembersNotifier extends StateNotifier<List<CouncilMember>> {
  CouncilMembersNotifier(this._prefs) : super([]) {
    _load();
  }

  final SharedPreferences _prefs;

  void _load() {
    final jsonString = _prefs.getString(kCouncilMembersKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        state = jsonList
            .map((j) => CouncilMember.fromJson(j as Map<String, dynamic>))
            .toList();
      } catch (e) {
        state = _defaultMembers();
      }
    } else {
      state = _defaultMembers();
    }
  }

  List<CouncilMember> _defaultMembers() {
    return [
      CouncilMember(
        id: const Uuid().v4(),
        name: 'Fact Checker',
        systemPrompt:
            'You are a meticulous fact-checker. Analyze the premise and identify any factual inaccuracies or assumptions. Provide corrections if needed.',
      ),
      CouncilMember(
        id: const Uuid().v4(),
        name: "Devil's Advocate",
        systemPrompt:
            "You are playing Devil's Advocate. Argue against the user's perspective or the primary assumption of the prompt. Provide the strongest counter-arguments.",
      ),
      CouncilMember(
        id: const Uuid().v4(),
        name: 'UX Designer',
        systemPrompt:
            'You are an expert UX designer. Review the prompt from a user experience, accessibility, and interface clarity perspective.',
      ),
    ];
  }

  Future<void> _save(List<CouncilMember> members) async {
    state = members;
    final jsonString = jsonEncode(members.map((m) => m.toJson()).toList());
    await _prefs.setString(kCouncilMembersKey, jsonString);
  }

  Future<void> addMember(CouncilMember member) async {
    final updated = [...state, member];
    await _save(updated);
  }

  Future<void> updateMember(CouncilMember member) async {
    final updated = state.map((m) => m.id == member.id ? member : m).toList();
    await _save(updated);
  }

  Future<void> removeMember(String id) async {
    final updated = state.where((m) => m.id != id).toList();
    await _save(updated);
  }
}

final councilMembersProvider =
    StateNotifierProvider<CouncilMembersNotifier, List<CouncilMember>>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return CouncilMembersNotifier(prefs);
    });
