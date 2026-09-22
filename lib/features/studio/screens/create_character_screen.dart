import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../community/models/character.dart';
import '../../community/providers/character_provider.dart';

class CreateCharacterScreen extends ConsumerStatefulWidget {
  const CreateCharacterScreen({super.key});

  @override
  ConsumerState<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends ConsumerState<CreateCharacterScreen> {
  final _picker = ImagePicker();
  File? _image;

  bool isFree = true;
  String gender = 'Nữ';
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _introductionController = TextEditingController();
  final _openingController = TextEditingController();
  final _greetingController = TextEditingController();

  String background = 'Đời thường';
  String relationship = 'Bạn thân';
  String personality = 'Hiền lành';
  String plot = 'Xuyên không';
  String appearance = 'Tóc dài';
  String identity = 'Học sinh';
  String ability = 'Ca hát';

  final List<String> backgroundOptions = ['Đời thường', 'Phiêu lưu', 'Cổ trang', 'Khoa học viễn tưởng', 'Kỳ ảo'];
  final List<String> relationshipOptions = ['Bạn thân', 'Bạn học', 'Lớp trưởng', 'Thanh mai trúc mã', 'Người yêu cũ', 'Kẻ thù'];
  final List<String> personalityOptions = ['Hiền lành', 'Ngoan ngoãn', 'Lạnh lùng', 'Vui vẻ', 'Bí ẩn', 'Nóng tính'];
  final List<String> plotOptions = ['Xuyên không', 'Trùng sinh', 'Mất trí nhớ', 'Du hành thời gian', 'Không có'];
  final List<String> appearanceOptions = ['Tóc đuôi ngựa', 'Tóc dài', 'Hình xăm', 'Kính mắt', 'Áo choàng', 'Đồng phục'];
  final List<String> identityOptions = ['Học sinh', 'Bác sĩ', 'Y tá', 'Kỹ sư', 'Ca sĩ', 'Nhà văn'];
  final List<String> abilityOptions = ['Ca hát', 'Chơi nhạc', 'Suy luận', 'Võ thuật', 'Nấu ăn', 'Không có'];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên nhân vật')));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ảnh nhân vật')));
      return;
    }

    final newCharacter = Character(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      imageUrl: _image!.path,
      description: _descriptionController.text,
      creatorName: 'Bạn',
      creatorAvatarUrl: 'https://picsum.photos/seed/you/100/100',
      chatCount: '0',
      tags: ['Mới'],
      role: gender,
      scenario: _openingController.text,
      isPremium: !isFree,
      starRating: !isFree ? 0 : null,
      background: background,
      relationship: relationship,
      personality: personality,
      plot: plot,
      appearance: appearance,
      identity: identity,
      ability: ability,
      introduction: _introductionController.text,
      greeting: _greetingController.text,
    );

    ref.read(characterListProvider.notifier).addCharacter(newCharacter);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 Đã tạo nhân vật thành công!'), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Tạo nhân vật mới',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 3,
            width: double.infinity,
            child: LinearProgressIndicator(
              value: 0.2,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: 'Loại nhân vật',
                    child: Row(
                      children: [
                        _buildToggleBtn('Miễn phí', isFree, () => setState(() => isFree = true)),
                        const SizedBox(width: 12),
                        _buildToggleBtn('Trả phí', !isFree, () => setState(() => isFree = false)),
                      ],
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Hình ảnh nhân vật',
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: _image != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, color: AppColors.textTertiary),
                            const SizedBox(height: 8),
                            Text('Chọn ảnh', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Tên nhân vật',
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: 'Nhập tên...'),
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Giới tính',
                    child: Row(
                      children: [
                        _buildToggleBtn('Nam', gender == 'Nam', () => setState(() => gender = 'Nam')),
                        const SizedBox(width: 8),
                        _buildToggleBtn('Nữ', gender == 'Nữ', () => setState(() => gender = 'Nữ')),
                        const SizedBox(width: 8),
                        _buildToggleBtn('Khác', gender == 'Khác', () => setState(() => gender = 'Khác')),
                      ],
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Cài đặt nhân vật',
                    child: Column(
                      children: [
                        _buildDropdown('Bối cảnh', backgroundOptions, background, (val) => setState(() => background = val!)),
                        const SizedBox(height: 12),
                        _buildDropdown('Mối quan hệ', relationshipOptions, relationship, (val) => setState(() => relationship = val!)),
                        const SizedBox(height: 12),
                        _buildDropdown('Tính cách', personalityOptions, personality, (val) => setState(() => personality = val!)),
                        const SizedBox(height: 12),
                        _buildDropdown('Tình tiết', plotOptions, plot, (val) => setState(() => plot = val!)),
                        const SizedBox(height: 12),
                        _buildDropdown('Ngoại hình', appearanceOptions, appearance, (val) => setState(() => appearance = val!)),
                        const SizedBox(height: 12),
                        _buildDropdown('Thân phận', identityOptions, identity, (val) => setState(() => identity = val!)),
                        const SizedBox(height: 12),
                        _buildDropdown('Năng lực', abilityOptions, ability, (val) => setState(() => ability = val!)),
                      ],
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Mô tả nhân vật',
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(hintText: 'Kể về nhân vật của bạn...'),
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Giới thiệu',
                    child: TextField(
                      controller: _introductionController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'Giới thiệu ngắn...'),
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Lời mở đầu',
                    child: TextField(
                      controller: _openingController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'Bối cảnh câu chuyện...'),
                    ),
                  ),
                  _buildSectionCard(
                    title: 'Lời chào',
                    child: Column(
                      children: [
                        TextField(
                          controller: _greetingController,
                          maxLines: 2,
                          decoration: const InputDecoration(hintText: 'Lời chào đầu tiên...'),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '💡 Dùng {nickname} để gọi tên người dùng',
                            style: TextStyle(color: AppColors.primary, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Hoàn tất', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleBtn(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
            // Không dùng labelText để tránh lỗi, tiêu đề đã có bên ngoài
          ),
        ),
      ),
    );
  }
}