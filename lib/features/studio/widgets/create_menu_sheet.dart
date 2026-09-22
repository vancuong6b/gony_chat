import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../screens/create_character_screen.dart';

class CreateMenuSheet extends StatelessWidget {
  const CreateMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMenuItem(
                  icon: Icons.face_rounded,
                  label: 'Nhân vật',
                  color: AppColors.accentBlue,
                  gradient: AppColors.blueGradient,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateCharacterScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuItem(
                  icon: Icons.image_rounded,
                  label: 'Ảnh',
                  color: AppColors.accentYellow,
                  gradient: AppColors.pinkGradient,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMenuItem(
                  icon: Icons.group_rounded,
                  label: 'Chat nhóm',
                  color: AppColors.accentGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuItem(
                  icon: Icons.public_rounded,
                  label: 'Thế giới',
                  color: AppColors.accentPink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuItem(
                  icon: Icons.send_rounded,
                  label: 'Bài đăng',
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    List<Color>? gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient != null ? LinearGradient(colors: gradient) : null,
                color: gradient == null ? color : null,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}