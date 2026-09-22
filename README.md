# 💬 Gony Chat – AI Persona Roleplay Messaging App

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=google%20gemini&logoColor=white" alt="Gemini" />
  <img src="https://img.shields.io/badge/Riverpod-2.5-blue?style=for-the-badge" alt="Riverpod" />
  <img src="https://img.shields.io/badge/SQLite-sqflite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
</p>

**Gony Chat** là ứng dụng di động cho phép người dùng tạo và trò chuyện nhập vai với các nhân vật AI ảo mang nhiều cá tính, bối cảnh và ngoại hình khác nhau, được xây dựng trên nền tảng **Flutter** và tích hợp mô hình **Google Gemini 2.5 Flash**.

---

## ✨ Tính Năng Nổi Bật (Key Features)

- 🤖 **Trò chuyện nhập vai cùng AI (Roleplay AI Chat)**:
  - Tích hợp mô hình `gemini-2.5-flash` qua thư viện `google_generative_ai`.
  - Cơ chế **System Prompt Engineering** chi tiết: mô phỏng chính xác tính cách, thân phận, bối cảnh, mối quan hệ và hành động cảm xúc trong ngoặc đơn `(cười nhẹ)`, `(ôm bạn)`.
  - Quản lý cửa sổ hội thoại (context window) 20 tin nhắn gần nhất để tối ưu chi phí token và độ chính xác của phản hồi.
- 🎨 **Studio sáng tạo nhân vật (Character Creator Studio)**:
  - Cho phép người dùng tự thiết kế nhân vật AI theo ý muốn: tải ảnh đại diện từ thiết bị, chọn giới tính, bối cảnh, quan hệ, tính cách, ngoại hình và lời mở đầu.
- 🌐 **Khám phá & Cộng đồng (Discovery & Community)**:
  - Khám phá danh sách nhân vật, lọc theo danh mục, thẻ gợi ý (tags) và bảng xếp hạng.
  - Tìm kiếm nhanh nhân vật theo tên hoặc từ khóa chủ đề.
- 💾 **Lưu trữ Offline với SQLite**:
  - Toàn bộ nhân vật và lịch sử hội thoại được lưu trữ cục bộ với `sqflite`.
  - Thiết kế lược đồ dữ liệu hỗ trợ **Database Migration** (`onUpgrade` từ v1 đến v3) an toàn.
- 🎨 **Giao diện hiện đại (Modern Dark/Light UI)**:
  - Màn hình chat toàn cảnh với ảnh nền nhân vật chìm, bóng mờ thẩm mỹ và khung tin nhắn tối ưu hiển thị.

---

## 🏗 Kiến Trúc Dự Án (Architecture & Tech Stack)

Dự án áp dụng cấu trúc **Feature-First** (tách theo tính năng), giúp mã nguồn sạch sẽ, dễ bảo trì và mở rộng:

```text
lib/
├── core/                   # Cấu hình chung, giao diện nền tảng, dịch vụ dùng chung
│   ├── constants/          # Màu sắc, icon, chuỗi ký tự
│   ├── routing/            # Khai báo GoRouter
│   ├── services/           # AiService (Gemini), DatabaseService (SQLite)
│   ├── theme/              # Chủ đề giao diện sáng/tối
│   └── utils/              # Mock data & tiện ích
├── features/               # Các module tính năng độc lập
│   ├── chat/               # Màn hình chat, lịch sử hội thoại, tin nhắn
│   ├── community/          # Trang cộng đồng, bảng xếp hạng, nhân vật
│   ├── profile/            # Trang cá nhân và cài đặt ứng dụng
│   ├── search/             # Tìm kiếm nhân vật và thẻ tag
│   └── studio/             # Studio tạo nhân vật và kịch bản mới
└── shared/                 # Thành phần điều hướng chung (Bottom Navigation)
```

### Công nghệ sử dụng:
- **Framework**: Flutter 3.x / Dart 3.x
- **State Management**: `flutter_riverpod` (StateNotifierProvider, Provider family)
- **Routing**: `go_router`
- **Local Database**: `sqflite` & `path`
- **AI Engine**: `google_generative_ai` (Gemini Flash API)
- **Media & UI**: `image_picker`, `cached_network_image`, `flutter_staggered_grid_view`

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng (Getting Started)

### 1. Yêu cầu hệ thống
- Flutter SDK (>= 3.11.5)
- Android Studio / VS Code
- Thiết bị Android thật hoặc Android Emulator

### 2. Cài đặt
```bash
# Clone repository
git clone https://github.com/<your-username>/gony_chat.git
cd gony_chat

# Tải các thư viện phụ thuộc
flutter pub get
```

### 3. Cấu hình Gemini API Key & Khởi chạy

Lấy API Key miễn phí tại [Google AI Studio](https://aistudio.google.com/app/apikey).

**Cách 1: Chạy với biến môi trường (Khuyên dùng)**
```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

**Cách 2: Cấu hình trực tiếp trong code**
Mở file `lib/core/services/ai_service.dart` và cập nhật giá trị mặc định của `_apiKey`:
```dart
static const String _apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: 'YOUR_GEMINI_API_KEY_HERE', // Điền key vào đây khi chạy local
);
```

---

## 📱 Tác Giả (Author)
- **Phạm Văn Cường**
- Email: [vancuong6b@gmail.com](mailto:vancuong6b@gmail.com)
- GitHub: [@your-username](https://github.com/)
