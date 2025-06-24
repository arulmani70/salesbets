import 'package:salesbets/src/base/base_view.dart';

import 'package:salesbets/src/common/widgets/file_not_found.dart';

import 'package:salesbets/src/home/home_view.dart';

import 'package:salesbets/src/loigin_firebase/bloc/login_firebase_bloc.dart';
import 'package:salesbets/src/loigin_firebase/logine_firebase_page.dart';

import 'package:salesbets/src/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salesbets/src/app/route_names.dart';
import 'package:logger/logger.dart';
import 'package:salesbets/src/common/widgets/splashscreen.dart';

class Routes {
  final log = Logger();

  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouteNames.splashscreen,
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        name: RouteNames.login,
        path: "/login",
        builder: (BuildContext context, GoRouterState state) {
          return LoginFirebasePage();
        },
      ),
      GoRoute(
        name: RouteNames.dashboard,
        path: '/dashboard',
        builder: (context, state) => HomePage(),
      ),

      GoRoute(
        name: RouteNames.profile,
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
      ),

      GoRoute(
        name: RouteNames.base,
        path: "/base",
        builder: (BuildContext context, GoRouterState state) {
          return BaseView();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final log = Logger();
      final bool signedIn =
          context.read<LoginFirebaseBloc>().state.status ==
          LoginFirebaseStatus.loggedIn;
      log.d("Routes:::Redirect:Is LoggedIn: $signedIn");
      final bool signingIn = state.matchedLocation == '/login';
      log.d("Routes:::Redirect:MatchedLocation: ${state.matchedLocation}");
      log.d(
        "Routes:::sssssRedirect:: ${state.matchedLocation == '/' && !signedIn}",
      );
      if (state.matchedLocation == '/' && !signedIn) {
        return null;
      }

      if (!signedIn && !signingIn) {
        return '/login';
      } else if (signedIn && signingIn) {
        return '/base';
      }

      return null;
    },
    debugLogDiagnostics: true,
    errorBuilder: (contex, state) {
      return FileNotFound(message: "${state.error?.message}");
    },
  );
}
