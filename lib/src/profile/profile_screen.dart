import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:salesbets/src/common/common.dart';
import 'package:salesbets/src/common/services/services_locator.dart';
import 'package:salesbets/src/loigin_firebase/bloc/login_firebase_bloc.dart';
import 'package:salesbets/src/profile/bloc/profile_bloc.dart';
import 'package:salesbets/src/profile/bloc/profile_event.dart';
import 'package:salesbets/src/profile/repo/profile_repository.dart';
import 'package:salesbets/src/profile/view/desktop/profile_screen_desktop.dart';
import 'package:salesbets/src/profile/view/mobile/profile_screen_mobile.dart';
import 'package:salesbets/src/profile/view/tablet/profile_screen_tablet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        repository: ProfileRepository(prefRepo: getIt<PreferencesRepository>()),
      )..add(InitialProfile()),
      child: BlocListener<LoginFirebaseBloc, LoginFirebaseState>(
        listener: (context, state) {
          if (state.status == LoginFirebaseStatus.loggedOut) {
            context.go('/login');
          }
        },
        child: ResponsiveValue<Widget>(
          context,
          defaultValue: const ProfileScreenDesktop(),
          conditionalValues: const [
            Condition.equals(name: TABLET, value: ProfileScreenTablet()),
            Condition.smallerThan(name: TABLET, value: ProfileScreenMobile()),
          ],
        ).value!,
      ),
    );
  }
}
