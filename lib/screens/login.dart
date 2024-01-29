import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordcraft/screens/home.dart';
import 'package:wordcraft/services/auth.dart';
import 'package:logging/logging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Logger _log = Logger('LoginPage');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
            child: Column(
          children: [
            const Spacer(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Image.asset('assets/icon.png'),
            ),
            const Spacer(),
            Text(
              'Welcome to Word Craft',
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Learn GRE words and improve your vocabulary',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  'Please sign in to continue',
                  textAlign: TextAlign.center,
                )),
            ElevatedButton(
              onPressed: () async {
                final localContext = context;
                try {
                  final user = await AuthService.signInWithGoogle();
                  if (user != null && mounted) {
                    Navigator.of(localContext).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  }
                } on FirebaseAuthException catch (e) {
                  _log.severe('FirebaseAuthException: ${e.message}');
                  if (mounted) {
                    ScaffoldMessenger.of(localContext).showSnackBar(
                      SnackBar(
                        content: Text(e.message ?? 'Something went wrong'),
                      ),
                    );
                  }
                } catch (e) {
                  _log.severe('AuthService Exception: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(localContext).showSnackBar(
                      const SnackBar(
                        content: Text('Something went wrong'),
                      ),
                    );
                  }
                }
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login),
                  SizedBox(width: 10),
                  Text('Sign in with Google'),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
