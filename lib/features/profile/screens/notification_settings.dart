import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Trạng thái các nút Switch
  bool recommendNewCharacters = true;
  bool characterSendMessage = true;
  bool messageMilestones = true;
  bool connectionMilestones = true;
  bool characterScriptUpdated = true;
  bool newFollower = true;
  bool newCreationNotification = true;
  bool createNewScript = true;
  bool newPostFromFollowed = true;
  bool comment = true;
  bool commentLiked = true;

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
          'Cài đặt thông báo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Nhân vật'),
          _buildSwitchTile('Đề xuất nhân vật mới', recommendNewCharacters, (val) => setState(() => recommendNewCharacters = val)),
          _buildSwitchTile('Nhân vật gửi tin nhắn', characterSendMessage, (val) => setState(() => characterSendMessage = val)),
          
          const SizedBox(height: 12),
          _buildSectionHeader('Sáng tạo của tôi'),
          _buildSwitchTile('Cột mốc tin nhắn', messageMilestones, (val) => setState(() => messageMilestones = val)),
          _buildSwitchTile('Cột mốc kết nối', connectionMilestones, (val) => setState(() => connectionMilestones = val)),
          _buildSwitchTile('Nhân vật của tôi đã cập nhật kịch bản', characterScriptUpdated, (val) => setState(() => characterScriptUpdated = val)),
          
          const SizedBox(height: 12),
          _buildSectionHeader('Dòng thời gian'),
          _buildSwitchTile('Người theo dõi mới', newFollower, (val) => setState(() => newFollower = val)),
          _buildSwitchTile('Thông báo sáng tạo mới', newCreationNotification, (val) => setState(() => newCreationNotification = val)),
          _buildSwitchTile('Tạo kịch bản mới', createNewScript, (val) => setState(() => createNewScript = val)),
          _buildSwitchTile('Bài đăng mới từ người đang theo dõi', newPostFromFollowed, (val) => setState(() => newPostFromFollowed = val)),
          
          const SizedBox(height: 12),
          _buildSectionHeader('Bình luận'),
          _buildSwitchTile('Bình luận', comment, (val) => setState(() => comment = val)),
          _buildSwitchTile('Bình luận đã nhận được lượt thích', commentLiked, (val) => setState(() => commentLiked = val)),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white, // Fixed deprecated warning
            activeTrackColor: const Color(0xFF00B0FF),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }
}
