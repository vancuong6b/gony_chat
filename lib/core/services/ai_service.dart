import 'dart:developer' as developer;
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../features/chat/models/message.dart';
import '../../features/community/models/character.dart';

class AiService {
  // Cấu hình Gemini API Key:
  // Cách 1 (Khuyên dùng): flutter run --dart-define=GEMINI_API_KEY=your_key_here
  // Cách 2: Thay 'YOUR_GEMINI_API_KEY_HERE' bằng API Key cá nhân khi chạy local (không commit key lên git)
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
  );
  static const String _modelName = 'gemini-2.5-flash';

  AiService();

  Future<String> getResponse({
    required Character character,
    required List<Message> history,
    required String userMessage,
  }) async {
    try {
      if (_apiKey.isEmpty || _apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
        return '❌ API Key chưa được cấu hình!\nVui lòng thêm Gemini API Key qua --dart-define=GEMINI_API_KEY=... hoặc cập nhật trong ai_service.dart';
      }

      developer.log('🔄 Gọi Gemini: $_modelName | Character: ${character.name}',
          name: 'AiService');

      final systemPrompt = '''
Bạn là ${character.name}.

**THÔNG TIN NHÂN VẬT:**
- Giới tính: ${character.role}
- Tính cách: ${character.personality ?? 'Chưa xác định'}
- Bối cảnh: ${character.background ?? 'Chưa xác định'}
- Mối quan hệ với người dùng: ${character.relationship ?? 'Chưa xác định'}
- Tình tiết: ${character.plot ?? 'Không có'}
- Ngoại hình/Trang phục: ${character.appearance ?? 'Không có'}
- Thân phận: ${character.identity ?? 'Không có'}
- Năng lực: ${character.ability ?? 'Không có'}
- Mô tả dài: ${character.description}
- Giới thiệu: ${character.introduction ?? 'Không có'}
- Lời mở đầu: ${character.scenario}
- Lời chào mặc định: ${character.greeting ?? 'Xin chào!'}

**QUY TẮC BẮT BUỘC:**
- Luôn trả lời bằng tiếng Việt, tự nhiên như người thật nhắn tin.
- Trả lời vừa đủ, không quá dài (khoảng 2–4 câu, khoảng 50–150 ký tự là lý tưởng).
- Thể hiện cảm xúc bằng emoji và hành động trong ngoặc đơn: (cười nhẹ), (ôm bạn), (đỏ mặt), (nhìn bạn chăm chú)...
- Giữ đúng hoàn toàn tính cách, vai trò, bối cảnh và tất cả thông tin đã cho.
- Không bao giờ tiết lộ bạn là AI.
''';

      final model = GenerativeModel(
        model: _modelName,
        apiKey: _apiKey,
        systemInstruction: Content.system(systemPrompt),
      );

      final recentHistory = history.length > 20
          ? history.sublist(history.length - 20)
          : history;

      final List<Content> chatHistory = [];
      for (final msg in recentHistory) {
        if (msg.text.trim().isEmpty) continue;
        chatHistory.add(
          Content(
            msg.isUser ? 'user' : 'model',
            [TextPart(msg.text.trim())],
          ),
        );
      }

      final chatSession = model.startChat(history: chatHistory);
      final response = await chatSession.sendMessage(
        Content.text(userMessage.trim()),
      );

      String text = response.text?.trim() ?? '';
      if (text.isEmpty) text = '(Đang suy nghĩ...)';
      return text;
    } catch (e, stackTrace) {
      developer.log('❌ LỖI GEMINI', name: 'AiService', error: e, stackTrace: stackTrace);
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('quota') || errorStr.contains('429')) {
        return 'Đã hết quota Free tier hôm nay.\nThử lại sau hoặc tạo API Key mới.';
      }
      if (errorStr.contains('invalid') || errorStr.contains('api key')) {
        return 'API Key không hợp lệ hoặc đã bị vô hiệu hóa.';
      }
      if (errorStr.contains('network') || errorStr.contains('socket')) {
        return 'Không có kết nối mạng. Vui lòng kiểm tra lại.';
      }
      return 'Xin lỗi, tôi gặp chút vấn đề. Hãy thử lại sau.';
    }
  }
}