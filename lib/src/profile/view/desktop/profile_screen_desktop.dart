import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salesbets/src/common/widgets/dashboard_scaffold.dart';
import 'package:salesbets/src/profile/bloc/profile_bloc.dart';
import 'package:salesbets/src/profile/bloc/profile_event.dart';
import 'package:salesbets/src/profile/bloc/profile_state.dart';

class ProfileScreenDesktop extends StatelessWidget {
  const ProfileScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      selectedIndex: 2,
      title: 'My Profile',
      onMenuTap: (index) {
        if (index == 0) context.go('/dashboard');
        if (index == 1) context.go('/dashboard');
        if (index == 2) context.go('/dashboard');
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.profileStatus == ProfileStatus.loaded) {
            final user = state.usersModel;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user.name}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(Icons.person, 'Name', user.name),
                          const SizedBox(height: 16),
                          _buildInfoRow(Icons.email, 'Email', user.email),
                          const SizedBox(height: 16),
                          _buildInfoRow(Icons.phone, 'Phone', user.phone),
                          const SizedBox(height: 16),
                          _buildInfoRow(Icons.badge, 'Role', user.roleId),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state.profileStatus == ProfileStatus.loggedout) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/login');
            });
            return const SizedBox();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
