import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// ===== Патерни (видимі на ч/б друці) =====
enum PatternKind { xHatch, stripes, dots }

/// ===== Спільні валідатори для ЛР9 =====
bool _isValidEmail(String s) {
  final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  return re.hasMatch(s);
}

String? validateRequired(String? v, {String label = 'Field'}) {
  if (v == null || v.trim().isEmpty) return '$label is required';
  return null;
}

String? validateEmail(String? v) {
  final base = validateRequired(v, label: 'Email');
  if (base != null) return base;
  if (!_isValidEmail(v!.trim())) return 'Invalid email';
  return null;
}

String? validatePassword(String? v) {
  final base = validateRequired(v, label: 'Password');
  if (base != null) return base;
  if (v!.trim().length < 7) return 'Password must be at least 7 chars';
  return null;
}

/// ===== Програма =====
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PatternKind _pattern = PatternKind.xHatch;

  void _cyclePattern() {
    setState(() {
      _pattern = PatternKind.values[(_pattern.index + 1) % PatternKind.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(seedColor: Colors.indigo);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 09 — Forms & Validation',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: cs,
        appBarTheme: AppBarTheme(
          backgroundColor: cs.surfaceVariant,
          foregroundColor: cs.onSurfaceVariant,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cs.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: cs.outline),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: cs.primary, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: SignInScreen(pattern: _pattern, onChangePattern: _cyclePattern),
    );
  }
}

/// ===== Патернова “шапка” для AppBar =====
class PatternHeader extends StatelessWidget implements PreferredSizeWidget {
  final PatternKind pattern;
  const PatternHeader({super.key, required this.pattern});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: .999,
        child: PatternBox(pattern: pattern, gap: 10, stroke: 1.6, opacity: .18),
      ),
    );
  }
}

/// ===== Canvas-патерни та кнопки з патерном =====
class PatternBox extends StatelessWidget {
  final PatternKind pattern;
  final double gap;
  final double stroke;
  final double opacity;
  final BorderRadius? radius;
  const PatternBox({
    super.key,
    required this.pattern,
    this.gap = 8,
    this.stroke = 1.5,
    this.opacity = .12,
    this.radius,
  });
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PatternPainter(
        pattern: pattern,
        gap: gap,
        stroke: stroke,
        color: Colors.black.withOpacity(opacity),
      ),
      child: SizedBox.expand(
        child: radius == null ? null : ClipRRect(borderRadius: radius!, child: const SizedBox.expand()),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final PatternKind pattern;
  final double gap;
  final double stroke;
  final Color color;
  _PatternPainter({required this.pattern, required this.gap, required this.stroke, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;
    switch (pattern) {
      case PatternKind.xHatch:
        for (double y = 0; y < size.height; y += gap) {
          for (double x = 0; x < size.width; x += gap) {
            canvas.drawLine(Offset(x, y), Offset(x + gap * .6, y + gap * .6), paint);
            canvas.drawLine(Offset(x + gap * .6, y), Offset(x, y + gap * .6), paint);
          }
        }
        break;
      case PatternKind.stripes:
        for (double d = -size.height; d < size.width; d += gap) {
          canvas.drawLine(Offset(d, 0), Offset(d + size.height, size.height), paint);
        }
        break;
      case PatternKind.dots:
        final dotPaint = Paint()..color = color..style = PaintingStyle.fill;
        for (double y = 0; y < size.height; y += gap) {
          for (double x = 0; x < size.width; x += gap) {
            canvas.drawCircle(Offset(x + gap * .3, y + gap * .3), stroke, dotPaint);
          }
        }
        break;
    }
  }
  @override
  bool shouldRepaint(covariant _PatternPainter old) =>
      old.pattern != pattern || old.gap != gap || old.stroke != stroke || old.color != color;
}

// ================= PatternButton (fixed) =================
class PatternButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final PatternKind pattern;
  final double radius;
  final EdgeInsets padding;

  const PatternButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.pattern,
    this.radius = 10,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : super(key: key);

  // redirecting ctor: ЖОДНИХ super.key і ініціалізаторів полів тут
  const PatternButton.filled({
    Key? key,
    required Widget child,
    required VoidCallback? onPressed,
    required PatternKind pattern,
    double radius = 10,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12),
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    pattern: pattern,
    radius: radius,
    padding: padding,
  );

  const PatternButton.outline({
    Key? key,
    required Widget child,
    required VoidCallback? onPressed,
    required PatternKind pattern,
    double radius = 10,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12),
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    pattern: pattern,
    radius: radius,
    padding: padding,
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: cs.outline, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: cs.surface.withOpacity(.45),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: PatternBox(
                    pattern: pattern,
                    gap: 10,
                    stroke: 1.4,
                    opacity: .18,
                    radius: BorderRadius.circular(radius),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: padding.vertical / 2,
                ),
                child: Center(
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// ===== 1) SIGN IN (з формою) =====
class SignInScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const SignInScreen({super.key, required this.pattern, required this.onChangePattern});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  @override
  void dispose() { _email.dispose(); _pass.dispose(); super.dispose(); }
  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login OK (demo)')));
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
            child: Text('Pattern: ${widget.pattern.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                    decoration: const InputDecoration(labelText: 'Email', hintText: 'name@example.com'),
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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => SignupScreen(
                            pattern: widget.pattern, onChangePattern: widget.onChangePattern),
                      ));
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
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => ResetPasswordScreen(
                                  pattern: widget.pattern, onChangePattern: widget.onChangePattern),
                            ));
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

/// ===== 2) SIGN UP (з формою) =====
class SignupScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const SignupScreen({super.key, required this.pattern, required this.onChangePattern});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name  = TextEditingController();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  @override
  void dispose() { _name.dispose(); _email.dispose(); _pass.dispose(); super.dispose(); }
  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration OK (demo)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        actions: [
          TextButton(
            onPressed: widget.onChangePattern,
            child: Text('Pattern: ${widget.pattern.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                  const FlutterLogo(size: 72),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) => validateRequired(v, label: 'Full name'),
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
                    onPressed: _register,
                    child: const Text('Create account'),
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

/// ===== 3) RESET PASSWORD (з формою) =====
class ResetPasswordScreen extends StatefulWidget {
  final PatternKind pattern;
  final VoidCallback onChangePattern;
  const ResetPasswordScreen({super.key, required this.pattern, required this.onChangePattern});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  @override
  void dispose() { _email.dispose(); super.dispose(); }
  void _sendReset() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset link sent (demo)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        actions: [
          TextButton(
            onPressed: widget.onChangePattern,
            child: Text('Pattern: ${widget.pattern.name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                  const FlutterLogo(size: 72),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: validateEmail,
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
