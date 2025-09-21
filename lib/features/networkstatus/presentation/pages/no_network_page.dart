import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/core/localization/app_localizations.dart';
import 'package:machinetest/core/utils/responsive_helper.dart';
import '../bloc/network_bloc.dart';
import '../bloc/network_event.dart';
import '../bloc/network_state.dart';

class NoNetworkPage extends StatefulWidget {
  const NoNetworkPage({super.key});

  @override
  State<NoNetworkPage> createState() => _NoNetworkPageState();
}

class _NoNetworkPageState extends State<NoNetworkPage> {
  late final NetworkBloc _networkBloc;
  Timer? _navigationTimer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _networkBloc = context.read<NetworkBloc>();
    // Start monitoring network connectivity
    _networkBloc.add(StartNetworkMonitoring());
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _networkBloc.add(StopNetworkMonitoring());
    super.dispose();
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocListener<NetworkBloc, NetworkState>(
        listener: (context, state) {
          if (state is NetworkConnected && !_isNavigating) {
            _isNavigating = true;

            // Wait 1 second before navigating to Home
            _navigationTimer = Timer(const Duration(seconds: 1), () {
              if (mounted) _navigateToHome();
            });
          }
        },
        child: Center(
          child: ResponsiveHelper.isMobile(context)
              ? _buildMobileLayout(context, l10n)
              : _buildDesktopLayout(context, l10n),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 120, color: Colors.grey[600]),
          const SizedBox(height: 32),
          Text(
            l10n.noInternetConnection,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.checkInternetMessage,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              _isNavigating ? Colors.green[600]! : Colors.blue[600]!,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isNavigating
                ? 'Connection restored! Redirecting...'
                : 'Checking connection...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _isNavigating ? Colors.green[600] : Colors.grey[600],
              fontWeight: _isNavigating ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 160, color: Colors.grey[600]),
          const SizedBox(height: 48),
          Text(
            l10n.noInternetConnection,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.checkInternetMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isNavigating ? Colors.green[600]! : Colors.blue[600]!,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _isNavigating
                    ? 'Connection restored! Redirecting...'
                    : 'Checking connection...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _isNavigating ? Colors.green[600] : Colors.grey[600],
                  fontWeight: _isNavigating
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
