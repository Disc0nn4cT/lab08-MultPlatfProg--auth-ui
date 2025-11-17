import 'package:flutter/material.dart';
import '../main.dart'
    show PatternKind, PatternHeader, PatternButton,
    validateEmail, validatePassword, validateRequired;
import 'signup_screen.dart';
import 'reset_password_screen.dart';

class SignInScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const SignInScreen({
    super.key,
    required this.pattern,
    required this.onChangePattern,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login OK (demo)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final cs  = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        actions: [
          TextButton(
            onPressed: widget.onChangePattern,
            child: Text(
              'Pattern: ${widget.pattern.name}',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
        ],
        flexibleSpace: PatternHeader(pattern: widget.pattern),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FlutterLogo(size: 84),
                  const SizedBox(height: 16),
                  Text('Flutter', textAlign: TextAlign.center, style: txt.titleLarge),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'name@example.com',
                    ),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _pass,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 20),

                  PatternButton(
                    pattern: widget.pattern,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignupScreen(
                            pattern: widget.pattern,
                            onChangePattern: widget.onChangePattern,
                          ),
                        ),
                      );
                    },
                    child: const Text('Sign up'),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: PatternButton.filled(
                          pattern: widget.pattern,
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PatternButton.outline(
                          pattern: widget.pattern,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResetPasswordScreen(
                                  pattern: widget.pattern,
                                  onChangePattern: widget.onChangePattern,
                                ),
                              ),
                            );
                          },
                          child: const Text('Reset password'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'Validation: required, email format, password ≥ 7',
                    style: txt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.7)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
