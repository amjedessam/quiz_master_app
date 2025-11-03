import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),

            const SizedBox(height: 20),

            // Settings Sections
            _buildSettingsSection(
              title: 'الحساب',
              items: [
                _buildSettingItem(
                  icon: Icons.edit,
                  title: 'تعديل الملف الشخصي',
                  onTap: controller.editProfile,
                ),
                _buildSettingItem(
                  icon: Icons.lock,
                  title: 'تغيير كلمة المرور',
                  onTap: controller.changePassword,
                ),
              ],
            ),

            _buildSettingsSection(
              title: 'الإعدادات',
              items: [
                _buildSwitchItem(
                  icon: Icons.notifications,
                  title: 'الإشعارات',
                  value: controller.notificationsEnabled,
                  onChanged: (_) => controller.toggleNotifications(),
                ),
                _buildSwitchItem(
                  icon: Icons.dark_mode,
                  title: 'الوضع الليلي',
                  value: controller.isDarkMode,
                  onChanged: (_) => controller.toggleDarkMode(),
                ),
              ],
            ),

            _buildSettingsSection(
              title: 'الدعم',
              items: [
                _buildSettingItem(
                  icon: Icons.info,
                  title: 'عن التطبيق',
                  onTap: controller.aboutApp,
                ),
                _buildSettingItem(
                  icon: Icons.help,
                  title: 'مركز المساعدة',
                  onTap: controller.contactSupport,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('تسجيل الخروج'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                controller.user.value?.avatar ?? '',
              ),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              controller.user.value?.name ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4), // Email
            Text(
              controller.user.value?.email ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),

            const SizedBox(height: 20),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('69', 'الاختبارات'),
                Container(width: 1, height: 40, color: Colors.white30),
                _buildStatColumn('78.5%', 'المعدل'),
                Container(width: 1, height: 40, color: Colors.white30),
                _buildStatColumn('12', 'أيام متتالية'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Obx(
      () => SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title),
        value: value.value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}
