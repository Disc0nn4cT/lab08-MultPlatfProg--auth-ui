import 'package:flutter/material.dart';
import '../main.dart'
    show PatternKind, PatternHeader, PatternButton, validateEmail, validateRequired;

class ResetPasswordScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const ResetPasswordScreen({
    super.key,
    required this.pattern,
    required this.onChangePattern,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _sendReset() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset link sent to ${_email.text} (demo)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final cs  = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
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
                  Text('Enter your email', style: txt.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => validateRequired(v) ?? validateEmail(v),
                  ),
                  const SizedBox(height: 20),
                  PatternButton.filled(
                    pattern: widget.pattern,
                    onPressed: _sendReset,
                    child: const Text('Send reset link'),
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
