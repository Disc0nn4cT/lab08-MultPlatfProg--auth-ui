import 'package:flutter/material.dart';
import '../main.dart'
    show PatternKind, PatternHeader, PatternButton,
    validateEmail, validatePassword, validateRequired;

class SignupScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const SignupScreen({
    super.key,
    required this.pattern,
    required this.onChangePattern,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup OK (demo)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final cs  = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        actions: [
          TextButton(
            onPressed: widget.onChangePattern,
            child: Text('Pattern: ${widget.pattern.name}',
                style: TextStyle(color: cs.onSurfaceVariant)),
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
                  Text('Create account', style: txt.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: validateRequired,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
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
                  PatternButton.filled(
                    pattern: widget.pattern,
                    onPressed: _signUp,
                    child: const Text('Create'),
                  ),
                  const SizedBox(height: 12),
                  PatternButton.outline(
                    pattern: widget.pattern,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to sign in'),
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
