import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salesbets/src/home/bloc/home_bloc.dart';
import 'package:salesbets/src/home/views/desktop/widgets/betslip_panel.dart';
import 'package:salesbets/src/loigin_firebase/bloc/login_firebase_bloc.dart';
import 'package:logger/logger.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  final log = Logger();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          final String title =
              state.homePageData['title'] ??
              'Welcome to the Virtual Business Challenge';
          final String subtitle =
              state.homePageData['subtitle'] ??
              'Compete with top sales professionals in a gamified tournament.';
          final String about =
              state.homePageData['about'] ??
              'Salesbets is an innovative platform...';

          log.d("titletitle :: ${state.homePageData}");

          return Row(
            children: [
              NavigationRail(
                selectedIndex: 0,
                onDestinationSelected: (int index) {},
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard),
                    label: Text('Dashboard'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.sports_esports),
                    label: Text('Business'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.account_balance_wallet),
                    label: Text('Bet Slip'),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      color: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'SalesBets Platform',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BlocBuilder<LoginFirebaseBloc, LoginFirebaseState>(
                            builder: (context, state) {
                              if (state.status ==
                                  LoginFirebaseStatus.loggedIn) {
                                log.d("state.userstate.user ${state.user}");
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
                                        PopupMenuItem(
                                          value: 'profile',
                                          child: Text('Profile'),
                                        ),
                                        PopupMenuItem(
                                          value: 'logout',
                                          child: Text('Logout'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  children: [
                                    TextButton(
                                      onPressed: () => context.go('/login'),
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: () => context.go('/signup'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: const Text('Sign Up'),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/banner_sales.png',
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    subtitle,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 24),
                                  const Card(
                                    child: ListTile(
                                      leading: Icon(Icons.flag),
                                      title: Text('Join Current Challenge'),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'About Us',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(about),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Useful Links',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text('Home'),
                                            Text('News & Updates'),
                                            Text('Contact'),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Company Policy',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text('Privacy Policy'),
                                            Text('Terms of Service'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          BetSlipPanel(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
