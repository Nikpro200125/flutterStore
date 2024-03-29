import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store/constants.dart';
import 'package:store/screens/auth.dart';
import 'package:store/screens/home.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialisation = Firebase.initializeApp();
    return FutureBuilder(
      future: _initialisation,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Ошибка ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Ошибка ${streamSnapshot.error}'),
                  ),
                );
              }

              if (streamSnapshot.connectionState == ConnectionState.active) {
                User user = streamSnapshot.data;

                if (user == null) {
                  return AuthorizationPage();
                } else {
                  return HomePage();
                }
              }

              return Scaffold(
                body: Center(
                  child: Text(
                    'Checking authentication...',
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: Text(
              'Connecting to the app...',
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
