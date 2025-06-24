import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salesbets/src/loigin_firebase/bloc/login_firebase_bloc.dart';

class TopBarHeader extends StatelessWidget {
  final String title;

  const TopBarHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<LoginFirebaseBloc, LoginFirebaseState>(
            builder: (context, state) {
              if (state.status == LoginFirebaseStatus.loggedIn) {
                final email = state.user.email;
                final username = email.contains('@')
                    ? email.split('@')[0]
                    : 'User';
                final displayName = username.isNotEmpty
                    ? '${username[0].toUpperCase()}${username.substring(1)}'
                    : "User";
                return Row(
                  children: [
                    Text(
                      "Hi, $displayName",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      onSelected: (value) {
                        if (value == 'profile') {
                          context.go('/profile');
                        } else if (value == 'logout') {
                          context.read<LoginFirebaseBloc>().add(
                            const LogoutRequested(),
                          );
                          context.go('/login');
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'profile', child: Text('Profile')),
                        PopupMenuItem(value: 'logout', child: Text('Logout')),
                      ],
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
