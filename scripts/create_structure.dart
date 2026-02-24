// import 'dart:io';

// void main() async {
//   final basePath = Directory('lib');
  
//   // Define your structure: path -> optional placeholder file content
//   final structure = {
//     'lib/main.dart': '''// Main entry point
// import 'package:flutter/material.dart';
// import 'presentation/screens/chat/chat_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AI Chat App',
//       theme: ThemeData.light(),
//       home: const ChatScreen(),
//     );
//   }
// }
// ''',
//     'lib/core/constants': null,
//     'lib/core/constants/app_constants.dart': '// App-wide constants',
    
//     'lib/core/theme': null,
//     'lib/core/theme/app_theme.dart': '// Theme configuration',
    
//     'lib/core/utils': null,
//     'lib/core/utils/logger.dart': '// Utility logger',
    
//     'lib/core/security': null,
//     'lib/core/security/secure_storage.dart': '// SecureStorage wrapper',
    
//     'lib/data/models': null,
//     'lib/data/models/chat_message.dart': '// ChatMessage model',
//     'lib/data/models/provider.dart': '// Provider model',
    
//     'lib/data/repositories': null,
//     'lib/data/repositories/chat_repository.dart': '// Abstract repository interface',
    
//     'lib/data/datasources': null,
//     'lib/data/datasources/chat_remote_datasource.dart': '// API calls',
//     'lib/data/datasources/chat_local_datasource.dart': '// Local DB calls',
    
//     'lib/data/dtos': null,
//     'lib/data/dtos/chat_message_dto.dart': '// DTO for JSON serialization',
    
//     'lib/domain/usecases': null,
//     'lib/domain/usecases/send_message.dart': '// Business logic: SendMessage',
    
//     'lib/presentation/providers': null,
//     'lib/presentation/providers/chat_provider.dart': '// Riverpod state providers',
    
//     'lib/presentation/screens/chat': null,
//     'lib/presentation/screens/chat/chat_screen.dart': '// Chat UI',
    
//     'lib/presentation/screens/settings': null,
//     'lib/presentation/screens/settings/settings_screen.dart': '// Settings UI',
    
//     'lib/presentation/screens/history': null,
//     'lib/presentation/screens/history/history_screen.dart': '// History UI',
    
//     'lib/presentation/widgets': null,
//     'lib/presentation/widgets/message_bubble.dart': '// Reusable UI component',
    
//     'lib/services/ai_adapters': null,
//     'lib/services/ai_adapters/openai_adapter.dart': '// OpenAI API adapter',
//     'lib/services/ai_adapters/ollama_adapter.dart': '// Ollama adapter',
//   };

//   int created = 0;
//   int skipped = 0;

//   for (final entry in structure.entries) {
//     final path = entry.key;
//     final content = entry.value;
    
//     final file = File(path);
//     final dir = File(path).parent;
    
//     // Create directory if it doesn't exist
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//       print('📁 Created: ${dir.path}');
//       created++;
//     } else {
//       skipped++;
//     }
    
//     // Create file with placeholder if it doesn't exist
//     if (content != null && !await file.exists()) {
//       await file.writeAsString(content);
//       print('📄 Created: $path');
//       created++;
//     } else if (content != null) {
//       print('⏭️  Skipped (exists): $path');
//       skipped++;
//     }
//   }

//   print('\n✅ Done! Created: $created items, Skipped: $skipped items');
// }