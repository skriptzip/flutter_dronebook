import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isLoginMode = true;

  String _getErrorMessage(AppLocalizations l10n, dynamic error, bool isSignUp) {
    if (error is AuthException) {
      final message = error.message.toLowerCase();
      final code = error.code?.toLowerCase() ?? '';

      print('Auth Error - Full Message: ${error.message}');
      print('Auth Error - Code: ${error.code}');
      print('Auth Error - Is SignUp: $isSignUp');

      if (isSignUp) {
        if (message.contains('already registered') ||
            message.contains('user already exists') ||
            code.contains('user_already_exists')) {
          return l10n.authErrorEmailRegistered;
        }
        if (message.contains('invalid email') ||
            code.contains('invalid_email')) {
          return l10n.authErrorInvalidEmail;
        }
        if ((message.contains('password') && message.contains('weak')) ||
            code.contains('weak_password')) {
          return l10n.authErrorWeakPassword;
        }
        if (message.contains('validation failed') ||
            message.contains('email not confirmed')) {
          return l10n.authErrorEmailNotConfirmedSignUp;
        }
      }

      if (message.contains('security') ||
          message.contains('request') ||
          message.contains('for security') ||
          code.contains('over_request') ||
          code.contains('rate_limit')) {
        return l10n.authErrorTooManyAttempts;
      }

      if (message.contains('invalid login credentials') ||
          message.contains('invalid email or password') ||
          code.contains('invalid_credentials')) {
        return l10n.authErrorInvalidCredentials;
      }
      if (message.contains('email not confirmed')) {
        return l10n.authErrorEmailNotConfirmedSignIn;
      }
      if (message.contains('too many') ||
          message.contains('rate limit') ||
          code.contains('rate_limit_exceeded')) {
        return l10n.authErrorTooManyAttemptsLater;
      }

      print('Unhandled auth error: ${error.message}');
      return error.message;
    }

    print('Non-auth error: $error');
    return l10n.authErrorUnexpected;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLoginMode) {
        print('Attempting sign in with email: ${_emailController.text}');
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        print('Sign in successful: ${response.user?.id}');
      } else {
        print('Attempting sign up with email: ${_emailController.text}');
        final response = await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        print('Sign up response - User: ${response.user?.id}');
        print('Sign up response - Session: ${response.session?.user.id}');
        print(
          'Sign up response - User confirmed: ${response.user?.userMetadata}',
        );

        if (response.user != null) {
          print('User created successfully: ${response.user?.email}');
          if (response.session == null) {
            if (mounted) {
              final l10n = AppLocalizations.of(context)!;
              _showSuccessDialog(
                l10n.accountCreatedTitle,
                l10n.accountCreatedMessage(_emailController.text),
                () {
                  setState(() {
                    _isLoginMode = true;
                    _passwordController.clear();
                  });
                },
              );
            }
            return;
          }
        }
      }
    } on AuthException catch (e) {
      print('AuthException caught: ${e.message} (Code: ${e.code})');
      if (mounted) {
        final errorMessage = _getErrorMessage(l10n, e, !_isLoginMode);
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      final errorMsg = l10n.errorWithMessage(e.toString());
      print(errorMsg);
      if (mounted) {
        _showErrorDialog(errorMsg);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.errorDialogTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String title, String message, VoidCallback onOk) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onOk();
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isLoginMode ? l10n.signInTitle : l10n.createAccountTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (!_isLoginMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          l10n.confirmationEmailNotice,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.emailLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.emailRequired;
                        }
                        if (!value.contains('@')) {
                          return l10n.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.passwordLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.passwordRequired;
                        }
                        if (value.length < 6) {
                          return l10n.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_isLoginMode ? l10n.signInButton : l10n.signUpButton),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                                _emailController.clear();
                                _passwordController.clear();
                                _formKey.currentState?.reset();
                              });
                            },
                      child: Text(
                        _isLoginMode
                            ? l10n.needAccountSignUp
                            : l10n.alreadyHaveAccountSignIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
