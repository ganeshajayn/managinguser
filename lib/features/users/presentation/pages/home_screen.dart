import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:machinetest/core/services/notification_service.dart';
import 'package:machinetest/features/users/domain/entities/user_entities.dart'
    show UserEntity;
import 'package:machinetest/features/users/presentation/bloc/bloc/user_bloc.dart';
import 'package:machinetest/core/localization/app_localizations.dart';
import 'package:machinetest/core/providers/language_provider.dart';
import 'package:machinetest/core/utils/responsive_helper.dart';
import 'package:machinetest/features/networkstatus/presentation/bloc/network_bloc.dart';
import 'package:machinetest/features/networkstatus/presentation/bloc/network_event.dart';
import 'package:machinetest/features/networkstatus/presentation/bloc/network_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 1;
  bool _isOnline = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUsersEvent(page));

    context.read<NetworkBloc>().add(StartNetworkMonitoring());

    _checkPendingNotification();
  }

  void _checkPendingNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationService = NotificationService();
      final pendingRoute = notificationService.pendingRoute;

      if (pendingRoute != null && mounted) {
        notificationService.clearPendingRoute();
        Navigator.pushNamed(context, pendingRoute);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _refreshData() {
    if (mounted && context.mounted) {
      try {
        context.read<UserBloc>().add(GetUsersEvent(page));
      } catch (e) {
        print('Refresh error: $e');
      }
    }
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).changeLanguage(languageCode);
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final jobController = TextEditingController();
    final l10n = AppLocalizations.of(context);

    if (!_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.noInternetConnection}. ${l10n.checkInternetMessage}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(l10n.createUser),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.name),
              ),
              TextField(
                controller: jobController,
                decoration: InputDecoration(labelText: l10n.job),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final data = {
                  "name": nameController.text,
                  "job": jobController.text,
                };
                context.read<UserBloc>().add(CreateUserEvent(data));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added Successfully"),
                    backgroundColor: Colors.lightGreen,
                  ),
                );
              },
              child: Text(l10n.save),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(int id) {
    final nameController = TextEditingController();
    final jobController = TextEditingController();
    final l10n = AppLocalizations.of(context);

    if (!_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.noInternetConnection}. ${l10n.checkInternetMessage}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(l10n.updateUser),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.name),
              ),
              TextField(
                controller: jobController,
                decoration: InputDecoration(labelText: l10n.job),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final data = {
                  "name": nameController.text,
                  "job": jobController.text,
                };
                context.read<UserBloc>().add(UpdateUserEvent(id, data));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Updated successfully"),
                    backgroundColor: Colors.lightGreen,
                  ),
                );
              },
              child: Text(l10n.update),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if (state is NetworkDisconnected && mounted) {
          setState(() {
            _isOnline = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/no-network');
            }
          });
        } else if (state is NetworkConnected && mounted) {
          setState(() {
            _isOnline = true;
          });

          _refreshTimer?.cancel();
          _refreshTimer = Timer(const Duration(milliseconds: 500), () {
            _refreshData();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(l10n.users),
          backgroundColor: Colors.green,
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
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserCreated ||
                state is UserUpdated ||
                state is UserDeleted) {
              context.read<UserBloc>().add(GetUsersEvent(page)); // refresh list
            }
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${l10n.error}: ${state.message}")),
              );
            }
          },
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              if (ResponsiveHelper.isMobile(context)) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    UserEntity user = state.users[index];
                    return _buildUserCard(context, user, l10n);
                  },
                );
              } else {
                return GridView.builder(
                  padding: ResponsiveHelper.getPadding(context),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.getCrossAxisCount(context),
                    childAspectRatio: ResponsiveHelper.isTablet(context)
                        ? 1.2
                        : 1.0,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    UserEntity user = state.users[index];
                    return _buildUserCard(context, user, l10n);
                  },
                );
              }
            } else if (state is UserError) {
              return Center(child: Text("${l10n.error}: ${state.message}"));
            }
            return Center(child: Text(l10n.noData));
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _isOnline ? Colors.green : Colors.grey,
          onPressed: _isOnline ? _showCreateDialog : null,
          child: Icon(
            Icons.add,
            color: _isOnline ? Colors.white : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    UserEntity user,
    AppLocalizations l10n,
  ) {
    if (ResponsiveHelper.isMobile(context)) {
      return Column(
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Slidable(
                key: ValueKey(user.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: _isOnline
                          ? (_) {
                              context.read<UserBloc>().add(
                                DeleteUserEvent(user.id),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.lightGreen,
                                  content: Text("Item deleted Successfully"),
                                ),
                              );
                            }
                          : (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${l10n.noInternetConnection}. ${l10n.checkInternetMessage}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                      backgroundColor: _isOnline ? Colors.red : Colors.grey,
                      icon: Icons.delete,
                      label: l10n.delete,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  title: Text("${user.firstName} ${user.lastName}"),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: _isOnline ? Colors.green : Colors.grey,
                    ),
                    onPressed: _isOnline
                        ? () => _showUpdateDialog(user.id)
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    } else {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: ResponsiveHelper.isTablet(context) ? 40 : 30,
                backgroundImage: NetworkImage(user.avatar),
              ),
              const SizedBox(height: 12),
              Text(
                "${user.firstName} ${user.lastName}",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _isOnline
                        ? () => _showUpdateDialog(user.id)
                        : null,
                    icon: Icon(Icons.edit, color: Colors.blue),
                    tooltip: l10n.edit,
                  ),
                  IconButton(
                    onPressed: _isOnline
                        ? () {
                            context.read<UserBloc>().add(
                              DeleteUserEvent(user.id),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${l10n.noInternetConnection}. ${l10n.checkInternetMessage}',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                    icon: Icon(
                      Icons.delete,
                      color: _isOnline ? Colors.red : Colors.grey,
                    ),
                    tooltip: l10n.delete,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
