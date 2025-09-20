import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:machinetest/core/database/db_helper.dart';
import 'package:machinetest/features/auth/data/respositories/auth_respository.dart';
import 'package:machinetest/core/localization/app_localizations.dart';
import 'package:machinetest/core/providers/language_provider.dart';
import 'package:machinetest/core/utils/responsive_helper.dart';
import 'package:machinetest/features/notifications/presentation/widgets/notification_debug_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DBHelper _dbHelper = DBHelper();
  final AuthRespository _authRepository = AuthRespository();
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      final profile = await _dbHelper.getUser(user.uid);
      setState(() {
        _userProfile = profile;
      });
    }
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    // Use the language provider to change language
    Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).changeLanguage(languageCode);
  }

  Future<void> _signOut() async {
    try {
      await _authRepository.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.signOutFailed}: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String languageCode) {
              _changeLanguage(context, languageCode);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('English'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'hi',
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('हिन्दी'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body: _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: ResponsiveHelper.getPadding(context),
              child: ResponsiveHelper.isMobile(context)
                  ? _buildMobileLayout(context, l10n)
                  : _buildDesktopLayout(context, l10n),
            ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: 32),
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          child: _userProfile!['avatar'] != null
              ? ClipOval(
                  child: Image.network(
                    _userProfile!['avatar'],
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(Icons.person, size: 60, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),
        Text(
          _userProfile!['name'] ?? l10n.unknownUser,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _userProfile!['email'] ?? l10n.noEmail,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 48),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileItem(
                  icon: Icons.person,
                  label: l10n.name,
                  value: _userProfile!['name'] ?? l10n.notProvided,
                ),
                const Divider(),
                _buildProfileItem(
                  icon: Icons.email,
                  label: l10n.email,
                  value: _userProfile!['email'] ?? l10n.notProvided,
                ),
                const Divider(),
                _buildProfileItem(
                  icon: Icons.fingerprint,
                  label: l10n.userId,
                  value: _userProfile!['uid'] ?? l10n.notProvided,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        const NotificationDebugWidget(),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            label: Text(l10n.signOut),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey.shade300,
              child: _userProfile!['avatar'] != null
                  ? ClipOval(
                      child: Image.network(
                        _userProfile!['avatar'],
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(Icons.person, size: 80, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            Text(
              _userProfile!['name'] ?? l10n.unknownUser,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _userProfile!['email'] ?? l10n.noEmail,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 64),
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.person,
                      label: l10n.name,
                      value: _userProfile!['name'] ?? l10n.notProvided,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.email,
                      label: l10n.email,
                      value: _userProfile!['email'] ?? l10n.notProvided,
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.fingerprint,
                      label: l10n.userId,
                      value: _userProfile!['uid'] ?? l10n.notProvided,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            const NotificationDebugWidget(),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
                label: Text(l10n.signOut),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
