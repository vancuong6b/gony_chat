import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool receiveNotifications = false;
  bool floatingStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Cài đặt',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App Logo & Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF80D0FF), Color(0xFFAD95FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'GonyChat',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'v1.11',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings List
            _buildSwitchTile(Icons.notifications_none_rounded, 'Nhận thông báo', receiveNotifications, (val) => setState(() => receiveNotifications = val)),
            _buildSwitchTile(Icons.layers_outlined, 'Thanh trạng thái Tạo nổi', floatingStatus, (val) => setState(() => floatingStatus = val)),
            _buildMenuTile(Icons.nightlight_outlined, 'Cài đặt sở thích', 'Nữ'),
            _buildMenuTile(Icons.language_rounded, 'Ngôn ngữ', 'Tiếng Việt'),
            _buildMenuTile(Icons.chat_bubble_outline_rounded, 'Phản hồi', ''),
            _buildMenuTile(Icons.notifications_active_outlined, 'Cài đặt thông báo', ''),
            _buildMenuTile(Icons.privacy_tip_outlined, 'Chính sách quyền riêng tư', ''),
            _buildMenuTile(Icons.description_outlined, 'Điều khoản sử dụng', ''),
            _buildMenuTile(Icons.person_outline_rounded, 'Tài khoản & Bảo mật', ''),
            _buildMenuTile(Icons.delete_outline_rounded, 'Xóa bộ nhớ đệm', ''),
            _buildMenuTile(Icons.restore_rounded, 'Khôi phục giao dịch mua', ''),

            const SizedBox(height: 32),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F5F5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF00B0FF),
            activeThumbColor: Colors.white, // Fixed deprecated
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String trailingText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          if (trailingText.isNotEmpty) ...[
            Text(
              trailingText,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(width: 4),
          ],
          const Icon(Icons.arrow_forward_ios, color: Color(0xFFEEEEEE), size: 14),
        ],
      ),
    );
  }
}
