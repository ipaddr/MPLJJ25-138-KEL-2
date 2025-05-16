import 'package:flutter/material.dart';
import 'home_page.dart';
import 'analysis_page.dart';
import 'schedule_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _selectedIndex = 3;

  bool _lokasiService = true;
  bool _cuacaNotif = true;
  bool _pasarNotif = false;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AnalysisPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SchedulePage()),
        );
        break;
      case 3:
        // sudah di halaman ini
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      'assets/profile_placeholder.png',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kebun Budi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Farm ID: #12345',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit, color: Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 24),

            sectionCard(
              title: 'Settings Umum',
              children: [
                settingTile(
                  Icons.language,
                  'Bahasa',
                  trailing: const Text('Indonesia'),
                ),
                switchTile(
                  icon: Icons.location_on,
                  title: 'Lokasi Service',
                  value: _lokasiService,
                  onChanged: (val) => setState(() => _lokasiService = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            sectionCard(
              title: 'Notifikasi',
              children: [
                switchTile(
                  icon: Icons.cloud,
                  title: 'Pemberitahuan Cuaca',
                  value: _cuacaNotif,
                  onChanged: (val) => setState(() => _cuacaNotif = val),
                ),
                switchTile(
                  icon: Icons.storefront,
                  title: 'Pembaruan Pasar',
                  value: _pasarNotif,
                  onChanged: (val) => setState(() => _pasarNotif = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            sectionCard(
              title: 'Akun',
              children: [
                settingTile(Icons.storage, 'Penggunaan Data'),
                settingTile(Icons.help_outline, 'Bantuan & Support'),
                settingTile(Icons.privacy_tip, 'Kebijakan Privasi'),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Version 2.1.0', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 36),
        unselectedIconTheme: const IconThemeData(size: 24),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget sectionCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget settingTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
