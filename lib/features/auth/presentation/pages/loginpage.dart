import 'package:flutter/material.dart';
import 'package:machinetest/core/database/db_helper.dart';
import 'package:machinetest/features/auth/data/respositories/auth_respository.dart';
import 'package:machinetest/core/localization/app_localizations.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    final authrepo = AuthRespository();
    final dbhelper = DBHelper();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              final user = await authrepo.signInWithGoogle();
              if (user != null) {
                await dbhelper.insertUser({
                  'uid': user.uid,
                  'name': user.displayName ?? "",
                  'email': user.email ?? "",
                });
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.signInFailed)));
              }
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("${l10n.error}: $e")));
            }
          },
          icon: const Icon(Icons.login),
          label: Text(l10n.signInWithGoogle),
        ),
      ),
    );
  }
}
